. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("unzip"))

if ($IsWindows) {
    winget install JanDeDobbeleer.OhMyPosh -s winget
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

# recreate profile link
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue

$pathToProfile = Join-Path $PSScriptRoot "profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $pathToProfile -Force

. $PROFILE
