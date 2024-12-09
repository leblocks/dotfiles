Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# import utils.ps1, this file is being symlinked so
# I have to do some magic to get actual file location
$actualProfileLocation = [System.IO.Path]::GetDirectoryName((Get-Item (Join-Path $PSScriptRoot $MyInvocation.MyCommand.Name)).Target)

. $actualProfileLocation/../../utils.ps1
. $actualProfileLocation/watchFiles.ps1

# add dotfiles to path
Add-PathEntry (Join-Path $actualProfileLocation .. ..)

<#
    prompt setup
#>
function prompt {
    $esc = [char]27
    $folder = Get-Location | Split-Path -Leaf

    $gitBranchName = Get-CurrentGitBranch
    if ($gitBranchName -ne "") {
        $gitBranchName = " $esc[32m($esc[31m$gitBranchName$esc[32m)$esc[0m"
    }

    return " $folder$gitBranchName$esc[32m >$esc[0m "
}

<#
    ALIASES
#>
Set-Alias which Get-Command
Set-Alias ll Get-Files
Set-Alias mtail Watch-Files
Set-Alias lp Get-Ports
Set-Alias pop Pop-Location
Set-Alias push Push-Location

function gto { Push-Location $env:OneDrive/devbox-config }
function env { Get-ChildItem env: }
function top { "btm -b" | Invoke-Expression }

function touch([string] $Path) {
    if (Test-Path -Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $Path
    }
}

<#
    ENVIRONMENT VARIABLES LOAD
#>
$path = Join-Path $HOME ".environment.json"
if (Test-Path $path) {
    Get-Content -Path $path 
        | ConvertFrom-Json
        | ForEach-Object {
            foreach ($ev in $_.PSObject.Properties) {
                $name = $ev.Name
                $value = $ev.Value
                [System.Environment]::SetEnvironmentVariable($name, $value)
            }
        }
}

<#
    PATH ENTRIES LOAD
#>
$path = Join-Path $HOME ".path.json"
if (Test-Path $path) {
    $separator = [IO.Path]::PathSeparator

    $pathEntries = [System.Collections.Generic.HashSet[string]]($env:PATH.Split($separator, 
        [System.StringSplitOptions]::RemoveEmptyEntries))

    foreach ($entry in (Get-Content -Path $path | ConvertFrom-Json)) {
        $pathEntries.Add($entry) | Out-Null
    }

    $newPath = $pathEntries | Join-String -Separator $separator -OutputSuffix $separator
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath)
}

