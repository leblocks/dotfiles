param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("npm", "fd"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing bash-language-server at $toolPath"

New-Folder($toolPath)

Push-Location $toolPath

"npm init -y" | Invoke-Expression
"npm install bash-language-server" | Invoke-Expression

$searchCommand = $IsWindwos ? "fd bash-language-server.cmd -aH"
    : "fd bash-language-server -aH -t l"

Set-EnvironmentVariable "BASH_LANGUAGE_SERVER" $($searchCommand | Invoke-Expression)

Pop-Location

