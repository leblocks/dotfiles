. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("npm", "fd"))

function Install-BashLanguageServer {
    $pathToBashTools = Join-Path $pathToLanguageTools "bash"
    New-Item -Path $pathToBashTools -ItemType "directory"
    Push-Location $pathToBashTools
    "npm init -y" | Invoke-Expression
    "npm install bash-language-server" | Invoke-Expression
    $executable = $IsWindows ? "bash-language-server.cmd" : "bash-language-server"
    Set-EnvironmentVariable "BASH_LANGUAGE_SERVER" $("fd $executable -aH" | Invoke-Expression)
    Pop-Location
}

function Install-TypeScriptLanguageServer {
    $pathToBashTools = Join-Path $pathToLanguageTools "typescript"
    New-Item -Path $pathToBashTools -ItemType "directory"
    Push-Location $pathToBashTools
    "npm init -y" | Invoke-Expression
    "npm install typescript-language-server" | Invoke-Expression
    $executable = $IsWindows ? "typescript-language-server.cmd" : "typescript-language-server"
    Set-EnvironmentVariable "TYPESCRIPT_LANGUAGE_SERVER" $("fd $executable -aH" | Invoke-Expression)
    Pop-Location
}
