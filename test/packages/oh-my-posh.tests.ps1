. $PSScriptRoot/../../utils.ps1

Describe 'oh-my-posh' {
    It 'Powershell $PROFILE exists' {
        Test-Path $PROFILE | Should -Be $True
    }

    It 'Powershell $PROFILE content must be equal to profile.ps1' {
        $pathToProfileInRepo = Join-Path $PSScriptRoot ".." ".." "packages" "oh-my-posh" "profile.ps1"
        Get-Content $PROFILE | Should -Be (Get-Content $pathToProfileInRepo)
    }

    It 'Powershell telemetry should be turned off' {
        $env:POWERSHELL_TELEMETRY_OPTOUT | Should -Be $true
    }

    It 'oh-my-posh is installed' {
        Test-Command "oh-my-posh" | Should -Be $true
    }
}
