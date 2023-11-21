oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_lean.omp.json" | Invoke-Expression

<#
    ALIASES
#>
function Get-TopTenProcesses {
    Get-Process | Sort-Object WS, CPU -Descending | Select-Object -First 10
}

Set-Alias top10 Get-TopTenProcesses

if ($IsWindows) {
    Set-Alias ll Get-ChildItem
    Set-Alias which Get-Command
}

<#
    ENVIRONMENT VARIABLES LOAD
#>
$path = Join-Path $HOME ".environment.json"
if (Test-Path $path) {
    Get-Content -Path $path 
        | ConvertFrom-Json
        | ForEach-Object {
            foreach ($ev in $_.PSObject.Properties) {
                $name = $ev.Name
                $value = $ev.Value
                Write-Host "$name=$value" -ForegroundColor DarkYellow
                [System.Environment]::SetEnvironmentVariable($name, $value)
            }
        }
}

