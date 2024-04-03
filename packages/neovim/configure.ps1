. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("nvim", "git"))

$pathToLink = $IsWindows ? (Join-Path $HOME "AppData" "Local" "nvim")
    : (Join-Path $HOME ".config" "nvim")

if ($IsLinux) {
    $linuxPathToConfig = Join-Path $HOME ".config"
    if (-Not (Test-Path $linuxPathToConfig)) {
        New-Item -Path $linuxPathToConfig -ItemType Directory -Force
    }
}

$pathToConfig = Join-Path $PSScriptRoot "config"

# recreate link to neovim config to $HOME folder
Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force

$pathToPacker = $IsWindows ? (Join-Path $HOME "\AppData\Local\nvim-data\site\pack\packer\start\packer.nvim")
    : (Join-Path $HOME "/.local/share/nvim/site/pack/packer/start/packer.nvim")

# ensure packer is bootstrapped
if (-Not (Test-Path $pathToPacker)) {
    "git clone --depth 1 https://github.com/wbthomason/packer.nvim $pathToPacker" | Invoke-FailFastExpression
}

# update plugins
"nvim --headless -c `"autocmd User PackerComplete quitall`" -c `"PackerSync`"" | Invoke-FailFastExpression

$pathToLanguageTools = Join-Path $HOME ".neovim-language-support"
New-Folder $pathToLanguageTools

. $PSScriptRoot/lsp/typescript.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/bash.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/python.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/lua.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/powershell.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/dotnet.ps1 $pathToLanguageTools

. $PSScriptRoot/dap/python.ps1 $pathToLanguageTools
. $PSScriptRoot/dap/dotnet.ps1 $pathToLanguageTools

