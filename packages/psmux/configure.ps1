. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("psmux", "git")

LinkToHome $PSScriptRoot ".psmux.conf"

# get tmux plugins manager
if (-Not (Test-Path "$HOME/.tmux/plugins/tpm")) {
    git clone https://github.com/marlocarlo/psmux-plugins "$env:USERPROFILE\.psmux\plugins\psmux-plugins"
}

. $env:USERPROFILE\.psmux\plugins\psmux-plugins\ppm\ppm.ps1

Install-AllPlugins

