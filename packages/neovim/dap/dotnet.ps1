param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

if ($IsLinux) {
    Test-Dependencies(@("tar"))
}

$toolPath = Join-Path $rootPath "dap" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing netcoredbg at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$netcoredbg = ($IsWindows ? "netcoredbg-win64.zip" : "netcoredbg-linux-amd64.tar.gz")
$downloadLink = "https://github.com/Samsung/netcoredbg/releases/latest/download/$netcoredbg"

Invoke-WebRequest $downloadLink -OutFile $netcoredbg -MaximumRetryCount 5 -RetryIntervalSec 3

if ($IsWindows) {
    Expand-Archive -LiteralPath $netcoredbg -DestinationPath . -Force
} else {
    "tar -xvf $netcoredbg" | Invoke-FailFastExpression
}

$pathToNetcoredbg = Join-Path $toolpath "netcoredbg" ($IsWindows ? "netcoredbg.exe" : "netcoredbg")

Set-EnvironmentVariable "NETCOREDBG_PATH" $pathToNetcoredbg

Pop-Location

