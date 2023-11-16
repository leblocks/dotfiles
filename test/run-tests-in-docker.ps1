param([Parameter(Position=0, Mandatory=$True)] [ValidateSet("archlinux")] [string] $ImageName)

. $PSScriptRoot/../utils.ps1

$contaienerName = $ImageName + "-" + [Guid]::NewGuid().ToString()
$repoRootFolder = Join-Path $PSScriptRoot ".."

switch ($ImageName) {
    "archlinux" {
        $containerCommand = [string]::Join(" ",
            "--entrypoint", "/bin/bash",
            "archlinux",
            "-c", "`"" +
            [string]::Join(" && ",
                "/dotfiles/bootstrap/archlinux.sh",
                "pwsh -f /dotfiles/dotfiles.ps1 install",
                "pwsh -f /dotfiles/dotfiles.ps1 configure all",
                "pwsh -f /dotfiles/dotfiles.ps1 test",
                "pwsh"
            ) + "`""
        )
    }
}

$command = [string]::Join(" ",
    "docker run",
    "--rm",
    "--name $contaienerName",
    "--interactive",
    "--tty",
    "--volume $repoRootFolder`:/dotfiles",
    "--env TERM=xterm-256color",
    $containerCommand)

Write-Host "invoking $command" -ForegroundColor Green

$command | Invoke-Expression

