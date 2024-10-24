param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("npm"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing vscode-langservers-extracted at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"npm init -y" | Invoke-FailFastExpression
"npm install vscode-langservers-extracted" | Invoke-FailFastExpression

$fileName = "vscode-html-language-server" + ($IsWindows ? ".cmd" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File 
    | ForEach-Object { $_.FullName } 
    | Select-Object -First 1

Set-EnvironmentVariable "VSCODE_HTML_LANGUAGE_SERVER" $path

Pop-Location

