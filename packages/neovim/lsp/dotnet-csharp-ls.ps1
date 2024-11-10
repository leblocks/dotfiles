param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("dotnet"))

$toolPath = Join-Path $rootPath "csharp-ls"

Write-Message "installing csharp-ls at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

Write-Output @(
     "dotnet tool uninstall csharp-ls",
     "dotnet new tool-manifest",
     "dotnet tool install csharp-ls --tool-path ."
 ) -NoEnumerate | Invoke-Expressions

Set-EnvironmentVariable "CSHARP_LS_LANGUAGE_SERVER" (Join-Path $toolPath "csharp-ls.exe")

Pop-Location

