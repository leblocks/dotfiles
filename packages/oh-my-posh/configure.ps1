. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("unzip", "curl"))

if ($IsWindows) {
    winget install JanDeDobbeleer.OhMyPosh -s winget
}

if ($IsLinux) {
    $sudo = ((Test-Command -Command "sudo") ? "sudo" : "")
    $shell = ((Test-Command -Command "bash") ? "bash" : "sh")
    "curl -s https://ohmyposh.dev/install.sh | $sudo $shell -s" | Invoke-Expression
}

# recreate profile link
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue

$pathToProfile = Join-Path $PSScriptRoot "profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $pathToProfile -Force

Set-EnvironmentVariable "POWERSHELL_TELEMETRY_OPTOUT" "true"

. $PROFILE
