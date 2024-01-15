
function Test-Command ([string] $Command) {
    [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-Dependencies ([string[]] $packages) {
    $errors = $packages
        | Where-Object { (-Not (Test-Command -Command $_)) }
        | ForEach-Object { "Package '$_' could not be found." }

    if (($errors | Measure-Object).Count -gt 0) {
        throw [string]::Concat([Environment]::NewLine, $errors)
    }
}

function LinkToHome ([string] $folder, [string] $fileName) {
    $pathToLink = Join-Path $HOME $fileName
    $pathToConfig = Join-Path $folder $fileName
    Remove-Item -Path $pathToLink -Force -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path $pathToLink -Target $pathToConfig -Force
}

function Install-Package ([string] $package) {
    # TODO rework logic here
    $sudo = ((Test-Command -Command "sudo") ? "sudo" : "")

    if ($IsWindows) {
        Test-Dependencies(@("choco"))
        "choco upgrade $package --confirm" | Invoke-Expression
    } elseif (Test-Command -Command "apk") {
        "$sudo apk add $package --no-cache" | Invoke-Expression
    } elseif (Test-Command -Command "pacman") {
        "$sudo pacman -Sy --noconfirm $package" | Invoke-Expression
    } elseif (Test-Command -Command "brew") {
        "brew install $package" | Invoke-Expression
    } else {
        throw "Could not find supported package manager for installation."
    }
}

function Set-EnvironmentVariable ([string] $name, [string] $value) {
    $path = Join-Path $HOME ".environment.json"

    if (-Not (Test-Path $path)) {
        New-Item $path -ItemType "file" -Force
        # new file must be valid json
        Set-Content $path "{}"
    }

    $environment = Get-Content $path | ConvertFrom-Json
    $exists = [bool](Get-Member -InputObject $environment -MemberType NoteProperty -Name $name)

    if ($exists) {
        $environment."$name" = $value
    } else {
        Add-Member -InputObject $environment -MemberType NoteProperty -Name $name -Value $value
    }

    $environment | ConvertTo-Json | Set-Content $path
}

function Add-PathEntry ([string] $pathEntry) {
    $path = Join-Path $HOME ".path.json"
    # .path.json is an array of additional path entries, that
    # must be unique, we don't want duplicates
    if (-Not (Test-Path $path)) {
        $pathEntries = New-Object System.Collections.Generic.HashSet[string]
    } else {
        $pathEntries = [System.Collections.Generic.HashSet[string]](Get-Content $path | ConvertFrom-Json)
    }

    $pathEntries.Add($pathEntry) | Out-Null
    $pathEntries | ConvertTo-Json | Set-Content $path
}

function New-Folder ([string] $path) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path $path -ItemType "directory" -Force
}

function Write-Message ([string] $message) {
    Write-Host $message -ForegroundColor Yellow
}

function Get-Files {
    Get-ChildItem . -Force
}

