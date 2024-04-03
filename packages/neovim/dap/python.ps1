param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("python", "fd"))

$toolPath = Join-Path $rootPath "dap" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing debugpy at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$python = $IsWindows ? "python" : (((Test-Command -Command "python3") ? "python3" : "python"))

"$python -m venv venv" | Invoke-FailFastExpression

$pathToActivate = $IsWindows ? (Join-Path $toolPath "venv" "Scripts" "Activate.ps1")
    : (Join-Path $toolPath "venv" "bin" "Activate.ps1")

$pathToActivate | Invoke-FailFastExpression
"$python -m pip install debugpy" | Invoke-FailFastExpression

"deactivate" | Invoke-FailFastExpression

$fileName = "python" + ($IsWindows ? ".exe" : "")

$path = Get-ChildItem . -Include $fileName -Recurse -Force -File | ForEach-Object { $_.FullName }

Set-EnvironmentVariable "DEBUGPY_PATH" $path

Pop-Location

