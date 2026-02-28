. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("psmux", "git")

LinkToHome $PSScriptRoot ".psmux.conf"

