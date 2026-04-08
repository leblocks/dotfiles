. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("nvim", "git")

# make sure all instances are shutdown
$processes = Get-Process nvim -ErrorAction SilentlyContinue

if ($processes)
{
    $processes | Stop-Process
}

$pathToLink = $IsWindows ? (Join-Path $HOME "AppData" "Local" "nvim")
    : (Join-Path $HOME ".config" "nvim")

if ($IsLinux) {
    $linuxPathToConfig = Join-Path $HOME ".config"
    if (-Not (Test-Path $linuxPathToConfig)) {
        New-Item -ItemType Directory -Path $linuxPathToConfig -Force
    }
}

$pathToConfig = Join-Path $PSScriptRoot "config"

# recreate link to neovim config to $HOME folder
Remove-Item -Path $pathToLink -ErrorAction SilentlyContinue -Force

New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force

# install\update plugins
"nvim --headless -c `"VimPackUpdate`" -c `"qall`""
    | Invoke-FailFastExpression

$pathToLanguageTools = Join-Path $HOME ".neovim"
New-Folder $pathToLanguageTools

. $PSScriptRoot/lsp/typescript.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/bash.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/python.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/lua.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/powershell.ps1 $pathToLanguageTools
. $PSScriptRoot/lsp/roslyn.ps1 $pathToLanguageTools
. "$PSScriptRoot/lsp/vscode-langservers-extracted.ps1" $pathToLanguageTools
. $PSScriptRoot/lsp/sqlite.ps1 $pathToLanguageTools

