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
  [string]$Command,

  [Parameter(Position=1, ValueFromRemainingArguments=$true)]
  $Rest
)

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
        Write-Error "Could not find configuration for '$tool', check available configurations with 'dotfiles list' command."
        exit
    } else {
        $configurationPath = Get-PathToConfigure $tool
        $programsToConfigure.Add($configurationPath)
    }

    foreach ($path in $scriptsToInvoke) {
        Write-Host "running $path"
        & $path
    }
}

function Install {
    Write-Host "installing from packages.txt"
}

function Get-PathToConfigure($tool) {
    return Join-Path -Path $PSScriptRoot -ChildPath (Join-Path -Path $tool -ChildPath "configure.ps1")
}

switch ($Command) {
    "list" { List }
    "configure" { Configure $Rest }
    "install" { Install }
    "help" { Get-Help $PSCommandPath }
}

