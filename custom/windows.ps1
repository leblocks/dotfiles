<#
    custom windows installation based on scoop where
    git, npm and other packages are already installed and managed
    by other admin
#>

. (Join-Path $PSScriptRoot ".." "utils.ps1")

if (-Not (Test-Command -Command "scoop")) {
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

Write-Output @(
        "scoop bucket add extras",
        "scoop bucket add nerd-fonts",
        "scoop install python",
        "scoop install nerd-fonts/CascadiaMono-NF",
        "scoop install extras/flow-launcher",
        "git config include.path `"$(Resolve-Path ..\packages\git\.gitconfig)`""
        ) -NoEnumerate | Invoke-Expressions

. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") install

. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure "oh-my-posh"
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure glazewm
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure neovim
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure vsvim

