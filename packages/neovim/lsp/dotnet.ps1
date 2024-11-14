param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

$ROSLYN_VERSION = "4.13.0-2.24563.22"

. $PSScriptRoot/../../../utils.ps1

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing roslyn at $toolPath"

function Get-Link([string] $arch, [string] $version) {
    return "https://pkgs.dev.azure.com/azure-public/vside/_apis/packaging/feeds/vs-impl/nuget/packages/Microsoft.CodeAnalysis.LanguageServer.$arch/versions/$version/content?api-version=7.1-preview.1"
}

$link = ""
if ($IsWindows) {
    $link = Get-Link "win-x64" $ROSLYN_VERSION
} elseif (Test-Command("pacman") ) {
    $link = Get-Link "linux-x64" $ROSLYN_VERSION
} elseif (Test-Command("apk")) {
    $link = Get-Link "linux-musl-x64" $ROSLYN_VERSION
} elseif (Test-Command("brew")) {
    $link = Get-Link "linux-x64" $ROSLYN_VERSION
} else {
    throw "unsupported OS"
}

New-Folder $toolPath

Push-Location $toolPath

Invoke-WebRequest `
    -Uri $link `
    -OutFile "roslyn.nupkg" `
    -MaximumRetryCount 5 `
    -RetryIntervalSec 3

Expand-Archive `
    -LiteralPath "roslyn.nupkg" `
    -DestinationPath . `
    -Force

$path = Get-ChildItem `
    . -Include "Microsoft.CodeAnalysis.LanguageServer.dll" `
    -Recurse `
    -Force `
    -File `
    | ForEach-Object { $_.FullName }
    | Select-Object -First 1

Set-EnvironmentVariable "ROSLYN_SERVER_DLL_LOCATION" $path

Pop-Location

