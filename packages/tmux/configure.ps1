. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("tmux", "git", "bash")

# get tmux plugins manager
if (-Not (Test-Path "$HOME/.tmux/plugins/tpm")) {
    "git clone https://github.com/tmux-plugins/tpm '$HOME/.tmux/plugins/tpm'" | Invoke-FailFastExpression
}

LinkToHome $PSScriptRoot ".tmux.conf"

# install plugins
"bash $HOME/.tmux/plugins/tpm/bin/install_plugins" | Invoke-FailFastExpression

