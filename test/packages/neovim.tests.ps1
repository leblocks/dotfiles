. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Describe 'neovim' {
    It 'neovim config link is set' {
        $pathToLink = $IsWindows ? (Join-Path $HOME "AppData" "Local" "nvim")
            : (Join-Path $HOME ".config" "nvim")
        Test-Path $pathToLink | Should -Be $true
    }

    It 'NEOVIM_TYPESCRIPT_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_TYPESCRIPT_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_BASH_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_BASH_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_PYRIGHT_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_PYRIGHT_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_LUA_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_LUA_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_POWERSHELL_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_POWERSHELL_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_VSCODE_HTML_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:NEOVIM_VSCODE_HTML_LANGUAGE_SERVER | Should -Be $true
    }

    It 'OMNISHARP_LANGUAGE_SERVER env variable is set and points to an existing path' {
        Test-Path $env:OMNISHARP_LANGUAGE_SERVER | Should -Be $true
    }

    It 'NEOVIM_SQLITE_DLL_PATH env variable is set and points to an existing path' -Skip:$IsLinux {
        Test-Path $env:NEOVIM_SQLITE_DLL_PATH  | Should -Be $true
    }

    It 'configuration luacheck pass' {
        & { Invoke-Luacheck }
        $LASTEXITCODE | Should -Be 0
    }

    It 'configuration stylua pass' {
        & { Invoke-Stylua }
        $LASTEXITCODE | Should -Be 0
    }
}

