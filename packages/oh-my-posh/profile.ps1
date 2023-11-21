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
                [System.Environment]::SetEnvironmentVariable($name, $value)
            }
        }
}

<#
    PATH ENTRIES LOAD
#>
$path = Join-Path $HOME ".path.json"
if (Test-Path $path) {
    $separator = [IO.Path]::PathSeparator

    $pathEntries = [System.Collections.Generic.HashSet[string]]($env:PATH.Split($separator, 
        [System.StringSplitOptions]::RemoveEmptyEntries))

    foreach ($entry in (Get-Content -Path $path | ConvertFrom-Json)) {
        $pathEntries.Add($entry) | Out-Null
    }

    $newPath = $pathEntries | Join-String -Separator $separator -OutputSuffix $separator
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath)
}

