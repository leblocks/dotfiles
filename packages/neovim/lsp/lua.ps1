param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

Test-Dependencies(@("curl", "tar", "fd"))

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing lua-language-server at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$ARCH = ""
if ($IsWindows) {
    $ARCH = "win32-x64.zip"
} elseif (Test-Command("pacman")) {
    $ARCH = "linux-x64.tar.gz"
} else {
    throw "unsupported OS"
}

# getting latest version of lua server
$tags = git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' https://github.com/LuaLS/lua-language-server.git 
    | Select-Object -Last 1

$VERSION = ($tags -Replace "^.*tags/", "") -Replace "\^\{\}", ""

$luaServerLink = "https://github.com/LuaLS/lua-language-server/releases/download/$VERSION/lua-language-server-$VERSION-$ARCH"

"curl -L $luaServerLink -o luaserver" | Invoke-Expression

($IsWindows ? "unzip luaserver" : "tar -xvf luaserver" ) | Invoke-Expression

Remove-Item luaserver -Force

$searchCommand = $IsWindows ? "fd lua-language-server -aH" : "fd lua-language-server -aH -t x"

Set-EnvironmentVariable "LUA_LANGUAGE_SERVER" $($searchCommand | Invoke-Expression)

Pop-Location
