param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

$python = Get-PythonExecutable

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing pyright at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

"$python -m venv venv" | Invoke-FailFastExpression

$pathToActivate = $IsWindows ? (Join-Path $toolPath "venv" "Scripts" "Activate.ps1")
    : (Join-Path $toolPath "venv" "bin" "Activate.ps1")

$pathToActivate | Invoke-FailFastExpression
"python -m pip install pyright" | Invoke-FailFastExpression
"deactivate" | Invoke-FailFastExpression

$fileName = "pyright-python-langserver" + ($IsWindows ? ".exe" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File | ForEach-Object { $_.FullName }

Set-EnvironmentVariable "NEOVIM_PYRIGHT_LANGUAGE_SERVER" $path

Pop-Location

