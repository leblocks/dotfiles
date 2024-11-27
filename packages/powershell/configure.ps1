. $PSScriptRoot/../../utils.ps1

# recreate profile link
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue

$pathToProfile = Join-Path $PSScriptRoot "profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $pathToProfile -Force

. $PROFILE

