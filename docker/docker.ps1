param([Parameter(Position=0, Mandatory=$True)] [ValidateSet("archlinux", "ubuntu")] [string] $ImageName)

. $(Join-Path $PSScriptRoot .. utils.ps1)

$contaienerName = $ImageName + "-" + [Guid]::NewGuid().ToString()
$repoRootFolder = Join-Path $PSScriptRoot ".."

$entrypointArgument = "`"" +
            [string]::Join(" && ",

                "/dotfiles/bootstrap/$ImageName.sh",
                "pwsh -f /dotfiles/dotfiles.ps1 kaboom",
                "pwsh"
            ) + "`""

switch ($ImageName) {
    "archlinux" {
        $containerCommand = [string]::Join(" ", "--entrypoint", "/bin/bash", "archlinux:base", "-c", $entrypointArgument)
    }
    "ubuntu" {
        $containerCommand = [string]::Join(" ", "--entrypoint", "/bin/bash", "homebrew/brew", "-c", $entrypointArgument)
    }
}

$commandToInvoke = [string]::Join(" ",
    "docker run",
    "--rm",
    "--name $contaienerName",
    "--interactive",
    "--tty",
    "--volume $repoRootFolder`:/dotfiles",
    "--volume $((Get-Location).Path)`:/host-system",
    "--env TERM=xterm-256color",
    "--env DOTFILES_DEBUG=true",
    "--network=host",
    $containerCommand)

Write-Message "invoking $commandToInvoke" -ForegroundColor Green

$commandToInvoke | Invoke-Expression

