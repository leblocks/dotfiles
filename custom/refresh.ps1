<#
    refreshes environment links, useful in case
    when multiple machines configured via one set of configs mounted
    on cloud drive
#>

. (Join-Path $PSScriptRoot ".." "utils.ps1")

# fix git config
Write-Output @(
        "git config --global include.path `"$(Join-Path $PSScriptRoot ".." "packages\git\.gitconfig")`""
        ) -NoEnumerate | Invoke-Expressions

# powershell profile
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Join-Path $PSScriptRoot ".." "packages\oh-my-posh\profile.ps1") -Force

# neovim
$pathToLink = Join-Path $HOME "AppData" "Local" "nvim"
$pathToConfig = Join-Path $PSScriptRoot ".." "packages\neovim\config"
Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force

# vsvim
$pathToLink = Join-Path $HOME ".vsvimrc"
$pathToConfig = Join-Path $PSScriptRoot ".." "packages\vsvim\.vsvimrc"
Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force

