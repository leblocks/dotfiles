param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

$ROSLYN_VERSION = "5.0.0-1.25127.3"

. $PSScriptRoot/../../../utils.ps1

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing roslyn at $toolPath"

function Get-Link([string] $arch, [string] $version) {
    return "https://pkgs.dev.azure.com/azure-public/vside/_apis/packaging/feeds/vs-impl/nuget/packages/Microsoft.CodeAnalysis.LanguageServer.$arch/versions/$version/content?api-version=7.1-preview.1"
}

$arch = ""
switch (Get-PackageManager) {
    "scoop" { $arch = "win-x64" }
    { ($_ -eq "brew") -or ($_ -eq "pacman") } { $arch = "linux-x64" }
    default { throw "unsupported OS" }
}

$link = Get-Link $arch $ROSLYN_VERSION

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

Set-EnvironmentVariable "NEOVIM_ROSLYN_SERVER_DLL_LOCATION" $path

Pop-Location

