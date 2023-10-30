. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("git"))

$pathToLink = Join-Path $HOME ".gitconfig"
$pathToGitConfig = Join-Path $PSScriptRoot ".gitconfig"

# recreate gitconfig link
Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToGitConfig -Force

