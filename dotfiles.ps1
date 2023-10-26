<#
.SYNOPSIS
Meow meow meow meow toDododo

.DESCRIPTION
USAGE
    ./dotfiles.ps1 <command>

COMMANDS
    up          run `docker-compose up`
    down        run `docker-compose down`
    help, -?    show this help message
#>
param(
  [Parameter(Position=0, Mandatory=$True)]
  [ValidateSet("list", "configure", "install",  "help")]
  [string]
  $Command,
  [Parameter(Position=1, ValueFromRemainingArguments=$true)]
  $Rest
)

. $PSScriptRoot/utils.ps1

function List {
    $osMarker = $IsWindows ? '\.windows' : '\.linux'
    Get-ChildItem -Recurse -File -Path $PSScriptRoot -Force
        | Where-Object { $_.Name -match $osMarker }
        | Split-Path -Parent
        | Split-Path -Leaf
}

# todo tool naming variable
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

function Install {
    $pathToPackages = Join-Path $PSScriptRoot "packages" "packages.json"
    Write-Host "Installing from '$pathToPackages'" -ForegroundColor Green
    # TODO dry it
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
    "help" { Get-Help $PSCommandPath }
}
