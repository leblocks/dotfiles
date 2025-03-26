param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("tar"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing lua-language-server at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$ARCH = ""
switch (Get-PackageManager) {
    "scoop" { $ARCH = "win32-x64.zip" }
    { ($_ -eq "brew") -or ($_ -eq "pacman") } { $ARCH = "linux-x64.tar.gz" }
    default { throw "unsupported OS" }
}

# getting latest version of lua server
$tags = git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' https://github.com/LuaLS/lua-language-server.git
    | Select-Object -Last 1

$VERSION = ($tags -Replace "^.*tags/", "") -Replace "\^\{\}", ""

$luaServerLink = "https://github.com/LuaLS/lua-language-server/releases/download/$VERSION/lua-language-server-$VERSION-$ARCH"

Invoke-WebRequest `
    -Uri $luaServerLink `
    -OutFile "luaserver" `
    -MaximumRetryCount 5 `
    -RetryIntervalSec 3

if ($IsWindows) {
    Expand-Archive `
        -LiteralPath "luaserver" `
        -DestinationPath . `
        -Force
} else {
    "tar -xvf luaserver" | Invoke-FailFastExpression
}

Remove-Item luaserver -Force

$path = Get-ChildItem . -Include *lua-language-server* -Recurse -Force -File | ForEach-Object { $_.FullName }

Set-EnvironmentVariable "NEOVIM_LUA_LANGUAGE_SERVER" $path

Pop-Location
