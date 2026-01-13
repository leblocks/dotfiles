param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing roslyn at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$arch = ($IsWindows ? "win" : "linux")

$params = @{
    Uri = "https://github.com/Crashdummyy/roslynLanguageServer/releases/latest/download/microsoft.codeanalysis.languageserver.$ARCH-x64.zip"
    OutFile = "roslyn.zip"
    MaximumRetryCount = 5
    RetryIntervalSec = 3
}

Invoke-WebRequest @params

Expand-Archive -LiteralPath "roslyn.zip" -DestinationPath . -Force

$path = (Resolve-Path *LanguageServer.dll).Path

Set-EnvironmentVariable "NEOVIM_ROSLYN_LANGUAGE_SERVER" $path

Pop-Location
