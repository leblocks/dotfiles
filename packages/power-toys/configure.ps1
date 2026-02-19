. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("winget")

$path = Join-Path $PSScriptRoot configuration.yaml

# TODO add here check for esting if powertoys are installed
winget configure $path --accept-configuration-agreements

