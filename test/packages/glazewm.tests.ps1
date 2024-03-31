. $PSScriptRoot/../../utils.ps1

Describe 'glazewm' -Skip:$IsLinux {
    It 'link to .glazewm configuration exists' {
        Test-Path "$HOME/.glaze-wm/config.yaml" | Should -Be $true
    }

    It 'link to .glazewm config has correct content' {
        $link = "$HOME/.glaze-wm/config.yaml"
        $conf = "$PSScriptRoot/../../packages/glazewm/.glaze-wm/config.yaml"
        Get-Content $link | Should -Be (Get-Content $conf)
    }
}

