
function Get-PackagesList
{
    . $(Join-Path $PSScriptRoot .. .. utils.ps1)

    $path = Join-Path $PSScriptRoot ".." ".." "packages" "packages.json"

    $packages = Get-Content $path | ConvertFrom-Json

    $packageManager = Get-PackageManager

    $packages.PSObject.properties[$packageManager].Value
}

BeforeAll {
    . $(Join-Path $PSScriptRoot .. .. utils.ps1)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '')]
    $exceptions = @{
        neovim = 'nvim'
        ripgrep = 'rg'
        bottom = 'btm'
        mingw = 'bash'
        'universal-ctags' = 'ctags'
    }
}

Describe 'packages from packages.json were installed' {
    It "package <_> is installed" -ForEach (Get-PackagesList) {
        if ($exceptions.ContainsKey($_))
        {
            Test-Command $exceptions[$_] | Should -Be $true
        } else
        {
            Test-Command $_ | Should -Be $true
        }
    }
}

