. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("winget"))

$path = Join-Path $PSScriptRoot "configuration.yaml"

"winget configure $path --accept-configuration-agreements" | Invoke-Expression

