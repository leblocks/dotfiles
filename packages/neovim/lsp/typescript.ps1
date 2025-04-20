param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $(Join-Path $PSScriptRoot .. .. .. utils.ps1)

Test-Dependencies @("npm")

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing typescript-language-server at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"npm init -y" | Invoke-FailFastExpression
"npm install typescript-language-server typescript" | Invoke-FailFastExpression

$fileName = "typescript-language-server" + ($IsWindows ? ".cmd" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File | ForEach-Object { $_.FullName }

Set-EnvironmentVariable "NEOVIM_TYPESCRIPT_LANGUAGE_SERVER" $path

Pop-Location

