. $PSScriptRoot/../../utils.ps1

Describe 'powershell' {
    It 'Powershell $PROFILE exists' {
        Test-Path $PROFILE | Should -Be $True
    }

    It 'Powershell $PROFILE content must be equal to profile.ps1' {
        $pathToProfileInRepo = Join-Path $PSScriptRoot ".." ".." "packages" "oh-my-posh" "profile.ps1"
        Get-Content $PROFILE | Should -Be (Get-Content $pathToProfileInRepo)
    }
}
