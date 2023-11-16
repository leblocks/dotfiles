if (-Not (Get-InstalledModule -Name "Pester")) {
    Install-Module "Pester" -Force
}

Import-Module Pester -PassThru

Invoke-Pester -Path $PSScriptRoot/*.tests.ps1 -Output Detailed

