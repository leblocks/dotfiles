<#
.SYNOPSIS
Development environment setup helper.

.DESCRIPTION
USAGE
    ./dotfiles.ps1 <command>

COMMANDS
    list                   list packages available for configuration
    configure [packageName] runs packages/packageName/configure.ps1, passing
                           "all" will invoke configuration of all available packages
    install                installs packages listed in packages/packages.json
    test                   run self checks
    docker                 run installation scripts in a docker container
    kaboom                 run install, configure all and test
    lint                   run lint checks on a repository
    help, -?               show this help message
#>
param(
  [Parameter(Position=0, Mandatory=$True)]
  [ValidateSet("list", "configure", "install",  "test", "docker", "kaboom", "lint", "help")]
  [string]
  $Command,
  [Parameter(Position=1, ValueFromRemainingArguments=$true)]
  $Rest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. $(Join-Path $PSScriptRoot utils.ps1)

Test-Dependencies @("git", "node", "npm", "python3")

function List {
    $osMarker = '\.linux'

    if ($IsWindows) {
        $osMarker = '\.windows'
    }

    Get-ChildItem -Recurse -File -Path $PSScriptRoot -Force
        | Where-Object { $_.Name -match $osMarker }
        | Split-Path -Parent
        | Split-Path -Leaf
}

function Configure {
    param ([Parameter(Position=0, Mandatory=$True)] [string] $tool)

    $configurations = List
    [System.Collections.ArrayList] $scripts = @()

    if ($tool -eq "all") {
        $scripts = $configurations | ForEach-Object { Get-PathToConfigure $_ }
    } elseif (-Not ($configurations -contains $tool)) {
        throw "Could not find configuration for '$tool', check available configurations with 'dotfiles list' command."
    } else {
        $script = Get-PathToConfigure $tool
        $scripts.Add($script)
    }

    $i = 0
    foreach ($script in $scripts) {
        $i += 1
        $percent = [int](($i / $scripts.Count) * 100)

        & $script

        Write-Progress -Activity "configuring packages" -Status $script -PercentComplete $percent
    }
}

function Invoke-Tests {
    if (-Not ([bool](Get-InstalledModule -Name "Pester" -ErrorAction SilentlyContinue))) {
        Install-Module "Pester" -Force
    }
    Import-Module Pester -PassThru

    $paths = @(
        (Join-Path $PSScriptRoot test ** *.tests.ps1),
        (Join-Path $PSScriptRoot test *.tests.ps1)
    )

    Invoke-Pester -Path $paths -Output Detailed
}

function Install {
    $pathToPackages = Join-Path $PSScriptRoot "packages" "packages.json"
    Get-Content $pathToPackages -Raw
        | ConvertFrom-Json
        | ForEach-Object {
            $packageManager = Get-PackageManager
            $packages = $_.PSObject.properties[$packageManager].Value
            Install-Packages -PackageManager $packageManager -Packages $packages
        }
}

function Get-PathToConfigure($tool) {
    return Join-Path $PSScriptRoot "packages" $tool "configure.ps1"
}

switch ($Command) {
    "list" { List }
    "configure" { Configure $Rest }
    "install" { Install }
    "test" { Invoke-Tests }
    "docker" { . (Join-Path $PSScriptRoot "docker" "docker.ps1") $Rest }
    "kaboom" {
        Install
        Configure "all"
        . $PROFILE
        Invoke-Tests
    }
    "lint" {
        Invoke-PSScriptAnalyzer $PSScriptRoot
        Invoke-Luacheck
        Invoke-Stylua
    }
    "help" { Get-Help $PSCommandPath }
}
