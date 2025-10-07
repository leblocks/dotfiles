[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification='no malicious code can be injected')]
param([Parameter(Position=0, Mandatory=$True)] [string] $rootPath)

. $PSScriptRoot/../../../utils.ps1

if ($IsLinux) {
    Test-Dependencies(@("tar"))
}

$toolPath = Join-Path $rootPath "lsp" ($MyInvocation.MyCommand.Name.Replace(".ps1", ""))

Write-Message "installing omnisharp at $toolPath"

New-Folder $toolPath

Push-Location $toolPath

$omnisharp = ($IsWindows ? "omnisharp-win-x64-net6.0.zip" : "omnisharp-linux-x64-net6.0.tar.gz")
$downloadLink = "https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/$omnisharp"

Invoke-WebRequest `
    -Uri $downloadLink `
    -OutFile $omnisharp `
    -MaximumRetryCount 5 `
    -RetryIntervalSec 3

if ($IsWindows) {
    Expand-Archive -LiteralPath $omnisharp -DestinationPath . -Force
} else {
    "tar -xvf $omnisharp" | Invoke-Expression
}

$pathToOmnisharp = Join-Path $toolPath ($IsWindows ? "OmniSharp.exe" : "OmniSharp")

Set-EnvironmentVariable "OMNISHARP_LANGUAGE_SERVER" $pathToOmnisharp

Pop-Location

