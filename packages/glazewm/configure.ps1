. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("winget")

winget install GlazeWM

# recreate config link
LinkToHome $PSScriptRoot ".glzr"


