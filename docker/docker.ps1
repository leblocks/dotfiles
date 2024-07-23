param([Parameter(Position=0, Mandatory=$True)] [ValidateSet("archlinux", "alpine", "ubuntu")] [string] $ImageName)

. $PSScriptRoot/../utils.ps1

$contaienerName = $ImageName + "-" + [Guid]::NewGuid().ToString()
$repoRootFolder = Join-Path $PSScriptRoot ".."

$entrypointArgument = "`"" +
            [string]::Join(" && ",
                "/dotfiles/bootstrap/$ImageName.sh",
                "pwsh -f /dotfiles/dotfiles.ps1 kaboom",
                "pwsh"
            ) + "`""

switch ($ImageName) {
    "alpine" {
        $containerCommand = [string]::Join(" ", "--entrypoint", "/bin/sh", "alpine", "-c",  $entrypointArgument) 
    }
    "archlinux" {
        $containerCommand = [string]::Join(" ", "--entrypoint", "/bin/bash", "archlinux:base", "-c", $entrypointArgument)
    }
    "ubuntu" {
        $containerCommand = [string]::Join(" ", "--entrypoint", "/bin/bash", "ubuntu:22.04", "-c", $entrypointArgument)
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
    $containerCommand)

Write-Message "invoking $commandToInvoke" -ForegroundColor Green

$commandToInvoke | Invoke-Expression

