. $PSScriptRoot/../../utils.ps1

Describe 'git' {
    It 'link to .gitconfig exists' {
        Test-Path "$HOME/.gitconfig" | Should -Be $true
    }

    It 'include.path has correct value' {
        $link = "$HOME/.gitconfig"
        $pathToConf = Resolve-Path "$PSScriptRoot/../../packages/git/.gitconfig"
        $pathToConf | Should -Be ("git config --get include.path" | Invoke-Expression)
    }
}

