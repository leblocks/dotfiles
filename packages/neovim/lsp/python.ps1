param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("python"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing pyright at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"python -m venv venv" | Invoke-Expression

$pathToActivate = $IsWindows ? (Join-Path $toolPath "venv" "Scripts" "Activate.ps1")
    : (Join-Path $toolPath "venv" "bin" "Activate.ps1")

$pathToActivate | Invoke-Expression
"python -m pip install pyright" | Invoke-Expression
"deactivate" | Invoke-Expression

$fileName = "pyright-python-langserver" + ($IsWindows ? ".exe" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File | ForEach-Object { $_.FullName }

Set-EnvironmentVariable "PYRIGHT_LANGUAGE_SERVER" $path

Pop-Location

