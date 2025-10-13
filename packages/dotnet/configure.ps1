param([Parameter(Position=0, Mandatory=$False)] [string] $Version = "latest")

. $(Join-Path $PSScriptRoot .. .. utils.ps1)

if ($IsLinux) {
    Test-Dependencies @("bash")
}

$installationScript = "dotnet-install." + ($IsWindows ? "ps1" : "sh")
$pathToScript = Join-Path ([System.IO.Path]::GetTempPath()) $installationScript

# always get newest installation script
if (Test-Path $pathToScript) {
    Remove-Item -Path $pathToScript -Force
}

$params = @{
    Uri = "https://dot.net/v1/$installationScript"
    OutFile = $pathToScript
    MaximumRetryCount = 5
    RetryIntervalSec = 3
}

Invoke-WebRequest @params

$DOTNET_ROOT = Join-Path $HOME ".dotnet"

$command = @(
    ($IsWindows ? "pwsh" : "bash"),
    $pathToScript,
    ($IsWindows ? "-NoPath" : "--no-path"),
    ($IsWindows ? "-InstallDir" : "--install-dir"), $DOTNET_ROOT,
    ($IsWindows ? "-Version" : "--version"), $Version
) -Join " "

$command | Invoke-FailFastExpression

Add-PathEntry $DOTNET_ROOT
Add-PathEntry (Join-Path $DOTNET_ROOT "tools")

Set-EnvironmentVariable "DOTNET_ROOT" $DOTNET_ROOT
Set-EnvironmentVariable "DOTNET_CLI_TELEMETRY_OPTOUT" "true"

if ($IsLinux) {
    Set-EnvironmentVariable "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT" "1"
}

