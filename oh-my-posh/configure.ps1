
if ($IsWindows) {
}

if ($IsLinux) {
    $encoding = [System.Text.Encoding]::UTF8
    $script = Invoke-WebRequest https://ohmyposh.dev/install.sh | Select-Object -ExpandProperty Content
    if (Get-Command bash -ErrorAction SilentlyContinue) {
        $encoding.GetString($script) | bash -s
    } else {
        $encoding.GetString($script) | sh -s
    }
}

if (!(Test-Path $PROFILE)) {
    # TODO use Join-Path instead string template
    New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$PSScriptRoot/profile.ps1" -Force
}

. $PROFILE
