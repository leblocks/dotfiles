BeforeAll {
    . $(Join-Path $PSScriptRoot .. utils.ps1)
}

Describe 'dotfiles' {
    It 'dotfiles command is on $PATH' {
        Test-Command dotfiles.ps1 | Should -Be $true
    }

    It 'dotfiles repository is formatted' -Tag Format {
        Invoke-PSScriptAnalyzer (Join-Path -Path $PSScriptRoot -ChildPath "..")
            | Should -BeNullOrEmpty
    }
}

