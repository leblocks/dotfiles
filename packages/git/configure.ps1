. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("git"))

# linking .gitconfig to the $HOME is not that great
# it will override custom defined stuff, so I'll do inlcude instead
"git config --global include.path `"$(Resolve-Path (Join-Path $PSScriptRoot .gitconfig))`"" | Invoke-FailFastExpression

