<#
.SYNOPSIS
This script is an example of how any .ps1 script can provide content to `Get-Help`.

.DESCRIPTION
USAGE
    ./dotfiles.ps1 <command>

COMMANDS
    up          run `docker-compose up`
    down        run `docker-compose down`
    build       run `dotnet build`
    test        run `dotnet test`
    ip          get your local ip
    help, -?    show this help message
#>
param(
  [Parameter(Position=0, Mandatory=$True)]
  [ValidateSet("list", "configure", "remove", "update", "help")]
  [string]$Command,

  [Parameter(Position=1, ValueFromRemainingArguments=$true)]
  $Rest
)

function List {
    Write-Host "listing stuff here and there"
}

# todo arguments
function Configure {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Program
    )
    Write-Host "installing stuff here and there"
}

# todo arguments
function Remove {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Program
    )
    Write-Host "removing stuff here and there"
}

# todo arguments
function Update {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Program
    )
    Remove $Program
    Configure $Program
}

switch ($Command) {
    "list" { List }
    "configure" { Configure $Rest }
    "remove" { Remove $Rest }
    "update" { Update $Rest }
    "help" { Get-Help $PSCommandPath  }
}

