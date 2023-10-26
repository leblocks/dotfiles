
function Test-Command ([string] $Command) {
    [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-Dependencies ([string[]] $packages) {
    $errors = $packages 
        | Where-Object { (-Not (Test-Command -Command $_)) }
        | ForEach-Object { "Package '$_' could not be found." }

    if ($errors.Length -gt 0) {
        throw [string]::Concat([Environment]::NewLine, $errors)
    }
}

function Install-Package ([string] $package) {
    if ($IsWindows) {
        Test-Dependencies(@("choco"))
        "choco upgrade $package --confirm" | Invoke-Expression
    } else {
        # TODO linux installation test multiple package managers apk, pacman
    }
}
