. $PSScriptRoot/../../utils.ps1

Describe 'vsvim' -Skip:$IsLinux {
    It 'link to .vsvrimrc exists' {
        Test-Path "$HOME/.vsvimrc" | Should -Be $true
    }

    It 'link to .vsvimrc has correct content' {
        $link = "$HOME/.vsvimrc"
        $conf = "$PSScriptRoot/../packages/vsvim/.vsvimrc"
        Get-Content $link | Should -Be (Get-Content $conf)
    }
}

