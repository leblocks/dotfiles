. $PSScriptRoot/../utils.ps1

Describe 'dotfiles' {
    It 'dotfiles command is on $PATH' {
        Test-Command dotfiles.ps1| Should -Be $true
    }
}

