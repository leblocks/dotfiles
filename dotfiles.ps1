<#
.SYNOPSIS
Meow meow meow meow

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
    $os = $IsWindows ? '\.windows' : '\.linux'
    Get-ChildItem -Recurse -File -Path $PSScriptRoot -Force 
        | Where { $_.Name -match $os } 
        | Split-Path -Parent 
        | Split-Path -Leaf
}

function Configure {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Program
    )
     # todo support all

    $programs = List
    if (!($programs -contains $Program)) {
        # todo use exception
        Write-Error "Could not find configuration for $Program, check available configurations with 'list' command"
        exit
    }
    Write-Host "installing $Program here and there"
}

function Install {
    Write-Host "installing from packages.txt"
}

switch ($Command) {
    "list" { List }
    "configure" { Configure $Rest }
    "Install" { Install }
    "help" { Get-Help $PSCommandPath  }
}

