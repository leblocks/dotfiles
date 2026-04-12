. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("npm")

$toolPath = Get-LspToolPath "vscode-langservers-extracted"

Write-Message "installing vscode-langservers-extracted at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"npm init -y" | Invoke-FailFastExpression
"npm install vscode-langservers-extracted" | Invoke-FailFastExpression

$fileName = "vscode-html-language-server" + ($IsWindows ? ".cmd" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File
    | ForEach-Object { $_.FullName }
    | Select-Object -First 1

Set-EnvironmentVariable "NEOVIM_VSCODE_HTML_LANGUAGE_SERVER" $path

Pop-Location

