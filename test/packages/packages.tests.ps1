
function Get-PackagesList {
    $packages = Join-Path $PSScriptRoot ".." ".." "packages" "packages.json"
    Get-Content $packages | ConvertFrom-Json
}

BeforeAll {
    . $PSScriptRoot/../../utils.ps1
    $exceptions = @{
        neovim = 'nvim'
        ripgrep = 'rg'
        bottom = 'btm'
        mingw = 'bash'
        'universal-ctags' = 'ctags'
    }
}

Describe 'packages from packages.json were installed' {
    It "common package <_> is installed" -ForEach (Get-PackagesList).common {
        if ($exceptions.ContainsKey($_)) {
            Test-Command $exceptions[$_] | Should -Be $true
        } else {
            Test-Command $_ | Should -Be $true
        }
    }

    It "linux package <_> is installed" -Skip:$IsWindows -ForEach (Get-PackagesList).linux {
        Test-Command $_ | Should -Be $true
    }

    It "windows package <_> is installed" -Skip:$IsLinux -ForEach (Get-PackagesList).windows {
        if ($exceptions.ContainsKey($_)) {
            Test-Command $exceptions[$_] | Should -Be $true
        } else {
            Test-Command $_ | Should -Be $true
        }
    }
}


