. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("dotnet")

dotnet tool install -g git-credential-manager

if ($IsWindows) {
    Set-EnvironmentVariable GCM_CREDENTIAL_STORE "wincredman"
} else {
    Set-EnvironmentVariable GCM_CREDENTIAL_STORE "cache"
}
