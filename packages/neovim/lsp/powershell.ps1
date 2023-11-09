param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("curl", "unzip", "fd"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing powershell editor services at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$fileName = "PowerShellEditorServices.zip"

"curl -LO https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/$fileName"
    | Invoke-Expression

"unzip $fileName" | Invoke-Expression

Remove-Item $fileName -Force

Set-EnvironmentVariable "POWERSHELL_LANGUAGE_SERVER" $toolPath

Pop-Location

