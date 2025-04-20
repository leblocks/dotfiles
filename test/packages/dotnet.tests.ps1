. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Describe 'dotnet' {
    It 'dotnet command is on $PATH' {
        Test-Command dotnet | Should -Be $true
    }

    It 'dotnet telemetry is disabled' {
        $env:DOTNET_CLI_TELEMETRY_OPTOUT | Should -Be "true"
    }
}

