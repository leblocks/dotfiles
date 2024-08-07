
. (Join-Path $PSScriptRoot ".." "utils.ps1")

Test-Dependencies(@("scoop"))

. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") install
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure neovim
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure vsvim
. (Join-Path $PSScriptRoot ".." "dotfiles.ps1") configure "oh-my-posh"

