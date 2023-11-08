param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("python", "fd"))

$toolPath = Join-Path $rootPath "dap" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing debugpy at $toolPath"

New-Folder($toolPath)

Push-Location $toolPath

"python -m venv venv" | Invoke-Expression

$pathToActivate = $IsWindows ? (Join-Path $toolPath "venv" "Scripts" "Activate.ps1")
    : (Join-Path $toolPath "venv" "bin" "Activate.ps1")

$pathToActivate | Invoke-Expression
"python -m pip install debugpy" | Invoke-Expression

"deactivate" | Invoke-Expression

$searchCommand  = $IsWindows ? "fd python.exe -aH" : "fd python$ -aH -t l"

Set-EnvironmentVariable "DEBUGPY_PATH" $($searchCommand | Invoke-Expression)

Pop-Location

