. $PSScriptRoot/../../utils.ps1

Describe 'neovim' {
    It 'neovim config link is set' {
        $pathToLink = $IsWindows ? (Join-Path $HOME "AppData" "Local" "nvim")
            : (Join-Path $HOME ".config" "nvim")
        Test-Path $pathToLink | Should -Be $true
    }

    It 'TYPESCRIPT_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:TYPESCRIPT_LANGUAGE_SERVER | Should -Be $true
    }

    It 'BASH_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:BASH_LANGUAGE_SERVER | Should -Be $true
    }

    It 'PYRIGHT_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:PYRIGHT_LANGUAGE_SERVER | Should -Be $true
    }

    It 'LUA_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:LUA_LANGUAGE_SERVER | Should -Be $true
    }

    It 'POWERSHELL_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:POWERSHELL_LANGUAGE_SERVER | Should -Be $true
    }

    It 'OMNISHARP_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:OMNISHARP_LANGUAGE_SERVER | Should -Be $true
    }

    It 'DEBUGPY_PATH env variable is set and points to an existing path' {
        Test-Path $env:DEBUGPY_PATH | Should -Be $true
    }

    It 'NETCOREDBG_PATH env variable is set and points to an existing path' {
        Test-Path $env:NETCOREDBG_PATH | Should -Be $true
    }
}

