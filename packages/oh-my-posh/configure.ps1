. $PSScriptRoot/../../utils.ps1

# unzip is required by oh-my-posh installation script
Test-Dependencies(@("winget", "unzip"))

if ($IsWindows -And (-Not (Test-Command -Command "oh-my-posh"))) {
    # on windows oh-my-posh can be installed in multiple
    # ways, so we don't want to have duplicate installation
    winget install JanDeDobbeleer.OhMyPosh -s winget
}

if ($IsLinux) {
    $sudo = ((Test-Command -Command "sudo") ? "sudo" : "")
    $shell = ((Test-Command -Command "bash") ? "bash" : "sh")
    $script = Join-Path ([System.IO.Path]::GetTempPath()) "install.sh"
    Invoke-WebRequest -Uri "https://ohmyposh.dev/install.sh" -OutFile $script -MaximumRetryCount 5 -RetryIntervalSec 3
    $installationPath = Join-Path $HOME "oh-my-posh"
    New-Folder($installationPath)
    "$sudo $shell $script -d $installationPath" | Invoke-FailFastExpression
    Remove-Item $script -Force
    Add-PathEntry $installationPath
}

# recreate profile link
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue

$pathToProfile = Join-Path $PSScriptRoot "profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $pathToProfile -Force

Set-EnvironmentVariable "POWERSHELL_TELEMETRY_OPTOUT" "true"

. $PROFILE
