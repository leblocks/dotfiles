# download sqlite3 dll for sqlite.lua (windows only)
#
. $(Join-Path $PSScriptRoot .. .. utils.ps1)

if (-Not ($IsWindows)) {
    return
}

$SQLITE_BINARY_VERSION = "3490200"

$toolPath = Join-Path (Get-NeovimPath) "dll"

Write-Message "downloading sqlite.dll at $toolPath"

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

Remove-Item "sqlitedll.zip"

Set-EnvironmentVariable "NEOVIM_SQLITE_DLL_PATH" (Resolve-Path sqlite3.dll).Path.Replace('\', '/')

Pop-Location

