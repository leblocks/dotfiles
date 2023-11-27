. $PSScriptRoot/../../utils.ps1

Describe 'tmux' -Skip:$IsWindows {
    It 'tmux dependencies installed' {
        Test-Command git | Should -Be $true
        Test-Command tmux | Should -Be $true
        Test-Command bash | Should -Be $true
    }

    It 'tpm is installed' {
        Test-Path "$HOME/.tmux/plugins/tpm" | Should -Be $true
    }

    It 'link to .tmux.conf exists' {
        Test-Path "$HOME/.tmux.conf" | Should -Be $true
    }

    It 'link to .tmux.conf has correct content' {
        $link = "$HOME/.tmux.conf"
        $conf = "$PSScriptRoot/../../packages/tmux/.tmux.conf"
        Get-Content $link | Should -Be (Get-Content $conf)
    }

    It 'TERM environment variable has correct value' {
        $env:TERM | Should -Be "xterm-256color"
    }
}
