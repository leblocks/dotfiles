<#
.SYNOPSIS
Development environent setup helper.

.DESCRIPTION
USAGE
    ./dotfiles.ps1 <command>

COMMANDS
    list                   list packages available for configuraiton
    confiure [packageName] runs packages/packageName/configure.ps1, passing
                           "all" will invoke configuration of all available packages
    install                installs packages listed in packages/packages.json
    test                   run self checks
    docker [imageName]     run installation scrits in a docker container
    kaboom                 run install, configure all and test
    help, -?               show this help message
#>
param(
  [Parameter(Position=0, Mandatory=$True)]
  [ValidateSet("list", "configure", "install",  "test", "docker", "kaboom", "help")]
  [string]
  $Command,
  [Parameter(Position=1, ValueFromRemainingArguments=$true)]
  $Rest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. $PSScriptRoot/utils.ps1

function List {
    $osMarker = $IsWindows ? '\.windows' : '\.linux'
    Get-ChildItem -Recurse -File -Path $PSScriptRoot -Force
        | Where-Object { $_.Name -match $osMarker }
        | Split-Path -Parent
        | Split-Path -Leaf
}

function Configure {
    param ([Parameter(Position=0, Mandatory=$True)] [string] $tool)

    $availableConfigurations = List
    [System.Collections.ArrayList] $scriptsToInvoke = @()

    if ($tool -eq "all") {
        $scriptsToInvoke = $availableConfigurations | ForEach-Object { Get-PathToConfigure $_ }
    } elseif (-Not ($availableConfigurations -contains $tool)) {
        throw "Could not find configuration for '$tool', check available configurations with 'dotfiles list' command."
    } else {
        $configurationPath = Get-PathToConfigure $tool
        $scriptsToInvoke.Add($configurationPath)
    }

    foreach ($path in $scriptsToInvoke) {
        Write-Host "Running '$path'" -ForegroundColor Green
        & $path
    }
}

function Invoke-Tests {
    if (-Not ([bool](Get-InstalledModule -Name "Pester" -ErrorAction SilentlyContinue))) {
        Install-Module "Pester" -Force
    }
    Import-Module Pester -PassThru
    Invoke-Pester -Path $PSScriptRoot/test/**/*.tests.ps1, $PSScriptRoot/test/*.tests.ps1 -Output Detailed
}

function Install {
    $pathToPackages = Join-Path $PSScriptRoot "packages" "packages.json"
    Write-Host "Installing from '$pathToPackages'" -ForegroundColor Green
    Get-Content $pathToPackages -Raw
        | ConvertFrom-Json
        | ForEach-Object {
            $packagesToInstall = $_.common + ($IsWindows ? $_.windows : $_.linux)
            foreach ($package in $packagesToInstall) {
                Write-Host "Installing '$package'" -foregroundcolor yellow
                Install-Package $package
            }
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
    "help" { Get-Help $PSCommandPath }
}
