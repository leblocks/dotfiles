param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("npm", "fd"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing typescript-language-server at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"npm init -y" | Invoke-Expression
"npm install typescript-language-server typescript" | Invoke-Expression

$searchCommand = $IsWindows ? "fd typescript-language-server.cmd -aH"
    : "fd typescript-language-server -aH -t l"

Set-EnvironmentVariable "TYPESCRIPT_LANGUAGE_SERVER" $($searchCommand | Invoke-Expression)

Pop-Location

