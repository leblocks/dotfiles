param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing powershell editor services at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$fileName = "PowerShellEditorServices.zip"

Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/$fileName" -OutFile $fileName -MaximumRetryCount 5 -RetryIntervalSec 3

Expand-Archive -LiteralPath $fileName -DestinationPath . -Force

Remove-Item $fileName -Force

Set-EnvironmentVariable "NEOVIM_POWERSHELL_LANGUAGE_SERVER" $toolPath

Pop-Location

