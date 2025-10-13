param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

if (-Not ($IsWindows)) {
    return
}

$SQLITE_BINARY_VERSION = "3490200"

. $(Join-Path $PSScriptRoot .. .. .. utils.ps1)

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "downloading sqlite.dll at $toolPath"
# download sqlite3 dll for sqlite.lua (windows only)

New-Folder $toolPath

Push-Location $toolPath

$params = @{
    Uri = "https://www.sqlite.org/2025/sqlite-dll-win-x64-$SQLITE_BINARY_VERSION.zip"
    OutFile = "sqlitedll.zip"
    MaximumRetryCount = 5
    RetryIntervalSec = 3
}

Invoke-WebRequest @params

Expand-Archive -LiteralPath "sqlitedll.zip" -DestinationPath . -Force

Set-EnvironmentVariable "NEOVIM_SQLITE_DLL_PATH" (Resolve-Path sqlite3.dll).Path.Replace('\', '/')

Pop-Location

