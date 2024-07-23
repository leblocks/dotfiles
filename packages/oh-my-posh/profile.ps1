Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# import utils.ps1, this file is being symlinked so
# I have to do some magic to get actual file location
$actualProfileLocation = [System.IO.Path]::GetDirectoryName((Get-Item (Join-Path $PSScriptRoot $MyInvocation.MyCommand.Name)).Target)

. $actualProfileLocation/../../utils.ps1
. $actualProfileLocation/watchFiles.ps1

# load powershell theme once
$themeLink = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_lean.omp.json" 
$themePath = Join-Path $HOME oh-my-posh.theme.json
if (-Not (Test-Path $themePath)) {
    Invoke-WebRequest $themeLink -OutFile $themePath
}

# add dotfiles to path
Add-PathEntry (Join-Path $actualProfileLocation .. ..)

<#
    ALIASES
#>
Set-Alias which Get-Command
Set-Alias ll Get-Files
Set-Alias top Invoke-Btm
Set-Alias mtail Watch-Files
Set-Alias lp Get-Ports

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

oh-my-posh init pwsh --config $themePath | Invoke-FailFastExpression

