. $PSScriptRoot/../../utils.ps1

Describe 'git' {
    It 'link to .gitconfig exists' {
        Test-Path "$HOME/.gitconfig" | Should -Be $true
    }

    It 'link to .gitconfig has correct content' {
        $link = "$HOME/.gitconfig"
        $conf = "$PSScriptRoot/../../packages/git/.gitconfig"
        Get-Content $link | Should -Be (Get-Content $conf)
    }
}

