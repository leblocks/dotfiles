oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression

if ($IsWindows) {
    Set-Alias ll Get-ChildItem
    Set-Alias which Get-Command
}
