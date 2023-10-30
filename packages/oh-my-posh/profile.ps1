oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression

function Get-TopTenProcesses {
    Get-Process | Sort-Object WS, CPU -Descending | Select-Object -First 10
}

Set-Alias top10 Get-TopTenProcesses

if ($IsWindows) {
    Set-Alias ll Get-ChildItem
    Set-Alias which Get-Command
}

