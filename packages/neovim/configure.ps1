. $PSScriptRoot/../../utils.ps1
. $PSScriptRoot/language-tools-installation-helpers.ps1

Test-Dependencies(@("nvim", "git"))

<#
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue

$pathToLink = $IsWindows ? (Join-Path $HOME "AppData" "Local" "nvim")
    : (Join-Path $HOME ".config" "nvim")

if ($IsLinux) {
    New-Item -Path (Join-Path $HOME ".config") -ItemType "directory" -Force
}

$pathToConfig = Join-Path $PSScriptRoot "config"

# recreate link to neovim config to $HOME folder
Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force

$pathToPacker = $IsWindows ? (Join-Path $HOME "\AppData\Local\nvim-data\site\pack\packer\start\packer.nvim")
    : (Join-Path $HOME "/.local/share/nvim/site/pack/packer/start/packer.nvim")

# ensure packer is bootstrapped
if (-Not (Test-Path $pathToPacker)) {
    "git clone --depth 1 https://github.com/wbthomason/packer.nvim $pathToPacker" | Invoke-Expression
}

# update plugins
"nvim --headless -c `"autocmd User PackerComplete quitall`" -c `"PackerSync`"" | Invoke-Expression

#>

# install lsp\dap stuff
$pathToLanguageTools = Join-Path $HOME ".neovim-lsp-dap-tools"

# recreate folder
Remove-Item -Path $pathToLanguageTools -Force -Recurse
New-Item -Path $pathToLanguageTools -ItemType "directory" -Force

# TODO test on linux
Install-BashLanguageServer
Install-TypeScriptLanguageServer




