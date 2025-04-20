. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("winget")

"winget install Microsoft.AzureDataStudio" | Invoke-FailFastExpression

$pathToExtension = Join-Path ([System.IO.Path]::GetTempPath()) "extension.vsix"
Remove-Item -Path $pathToExtension -Force -ErrorAction SilentlyContinue

# TODO download latest release
Invoke-WebRequest `
    -Uri "https://github.com/VSCodeVim/Vim/releases/download/v1.28.1/vim-1.28.1.vsix" `
    -OutFile $pathToExtension `
    -MaximumRetryCount 5 `
    -RetryIntervalSec 3

$pathToExecutable = Get-ChildItem `
    (Join-Path $HOME AppData Local Programs) `
    -Include "azuredatastudio.cmd" `
    -Recurse `
    -Force `
    -File `
    | ForEach-Object { $_.FullName }


Write-Output @(
    ". `"$pathToExecutable`" --install-extension $pathToExtension"
) -NoEnumerate | Invoke-Expressions

$pathToLink = Join-Path $env:AppData "azuredatastudio" "User" "settings.json"

Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target (Join-Path $PSScriptRoot  "settings.json") -Force

