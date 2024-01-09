<#
Contains helper commands to launch playgrounds in different languages
#>

$playgroundPath = Join-Path $HOME "playground"

if (-Not (Test-Path $playgroundPath)) {
    New-Item -Path $playgroundPath -ItemType "directory" -Force
}

function Get-TimeStamp () {
    [string](Get-Date -Format "ddMMyyyy_HH_mm_ss")
}


function New-DotnetPlayground() {
    $path = Join-Path $playgroundPath "$(Get-TimeStamp)_dotnet"
        New-Item -Path $path -ItemType "directory" -Force
        Push-Location $path
        "dotnet new console --output ." | Invoke-Expression
        "dotnet new editorconfig --output ." | Invoke-Expression

        $omnisharpConfig = @{
            FormattingOptions = @{
                EnableEditorConfigSupport = $True
                OrganizeImports = $True
            }
        }

        $omnisharpConfig | ConvertTo-Json | Out-File "omnisharp.json"
}
