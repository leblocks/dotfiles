param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

if ($IsWindows) {
    Test-Dependencies(@("unzip"))
} else {
    Test-Dependencies(@("tar"))
}

$toolPath = Join-Path $rootPath "dap" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing netcoredbg at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$netcoredbg = ($IsWindows ? "netcoredbg-win64.zip" : "netcoredbg-linux-amd64.tar.gz")
$downloadLink = "https://github.com/Samsung/netcoredbg/releases/latest/download/$netcoredbg"

Invoke-WebRequest $downloadLink -OutFile $netcoredbg

$command = ($IsWindows ? "unzip" : "tar -xvf") + " $netcoredbg"
$command | Invoke-Expression

$pathToNetcoredbg = Join-Path $toolpath "netcoredbg" ($IsWindows ? "netcoredbg.exe" : "netcoredbg")

Set-EnvironmentVariable "NETCOREDBG_PATH" $pathToNetcoredbg

Pop-Location

