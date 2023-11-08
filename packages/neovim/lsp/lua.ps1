param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("curl", "tar", "fd"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing lua-language-server at $toolPath"

New-Folder($toolPath)

Push-Location $toolPath

$VERSION = "3.7.1"
$ARCH = ""
if ($IsWindows) {
    $ARCH = "win32-x64.zip"
} elseif (Test-Command("apk")) {
    # alpine
    $ARCH = "linux-x64-musl.tar.gz"
} elseif (Test-Command("pacman")) {
    $ARCH = "linux-x64.tar.gz"
} else {
    throw "unsupported OS"
}

# TODO use git to get latest version number, example command
# git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' <repository>

$luaServerLink = "https://github.com/LuaLS/lua-language-server/releases/download/$VERSION/lua-language-server-$VERSION-$ARCH"

"curl -L $luaServerLink -o luaserver" | Invoke-Expression
($IsWindows ? "tar -xvf luaserver" : "unzip luaserver") | Invoke-Expression

$searchCommand = $IsWindows ? "" : "fd lua-language-server -t x"

Set-EnvironmentVariable "LUA_LANGUAGE_SERVER" $($searchCommand | Invoke-Expression)

Pop-Location
