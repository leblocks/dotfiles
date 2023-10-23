
# get tmux plugins manager
if (-Not (Test-Path "$HOME/.tmux/plugins/tpm")) {
    "git clone https://github.com/tmux-plugins/tpm '$HOME/.tmux/plugins/tpm'" | Invoke-Expression
}

# create link to the config file if it doesn't exist
$pathToConfig = Join-Path $HOME ".tmux.conf"
if (-Not (Test-Path $HOME/.tmux.conf)) {
    $pathToTarget = Join-Path $PSScriptRoot ".tmux.conf"
    New-Item -ItemType SymbolicLink -Path $pathToConfig -Target $pathToTarget -Force
}

$shell = [bool](Get-Command bash -ErrorAction SilentlyContinue) ? "bash" : "sh"

# install plugins
"$shell $HOME/.tmux/plugins/tpm/bin/install_plugins" | Invoke-Expression

