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

$INSTALL_DIR = Join-Path $HOME ".dotnet"
$WINDOWS_GLOBAL_INSTALLATION = "C:\Program Files\dotnet"

if ($IsWindows -And (Test-Path $WINDOWS_GLOBAL_INSTALLATION)) {
    $INSTALL_DIR = "`"$WINDOWS_GLOBAL_INSTALLATION`""
}

$command = @(
    ($IsWindows ? "pwsh" : "bash"),
    $pathToScript,
    ($IsWindows ? "-NoPath" : "--no-path"),
    ($IsWindows ? "-InstallDir" : "--install-dir"), $INSTALL_DIR,
    ($IsWindows ? "-Version" : "--version"), $Version
) -Join " "

$command | Invoke-FailFastExpression

$DOTNET_ROOT = $INSTALL_DIR

# special case when we don't need to do anything on windows
if (-Not (Test-Path $WINDOWS_GLOBAL_INSTALLATION)) {
    Add-PathEntry $DOTNET_ROOT
    Add-PathEntry $(Join-Path $DOTNET_ROOT "tools")

    Set-EnvironmentVariable "DOTNET_ROOT" $DOTNET_ROOT
    Set-EnvironmentVariable "DOTNET_CLI_TELEMETRY_OPTOUT" "true"
    Set-EnvironmentVariable "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT" "1"
}

