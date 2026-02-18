. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("winget")

$path = Join-Path $PSScriptRoot configuration.yaml

winget install Microsoft.PowerToys --uninstall-previous
winget configure $path --accept-configuration-agreements

