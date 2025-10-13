. $(Join-Path $PSScriptRoot .. utils.ps1)

$newLine = [System.Environment]::NewLine

$repoRootFolder = Join-Path $PSScriptRoot ".."

$commandToInvoke = @(
    "docker run",
    "--rm",
    "--name $((New-Guid).ToString())",
    "--interactive",
    "--tty",
    "--volume $repoRootFolder`:/dotfiles",
    "--volume $((Get-Location).Path)`:/host-system",
    "--env TERM=xterm-256color",
    "--env DOTFILES_DEBUG=true",
    "--network=host",
    "sashag1990/dotfiles:7.5.3 pwsh -NoLogo -NoExit"
)

Write-Message "invoking $(Join-String -InputObject $commandToInvoke -Separator $newLine)"

$commandToInvoke
    | Join-String -Separator " "
    | Invoke-Expression

