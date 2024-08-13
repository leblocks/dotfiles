
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
    $sudo = ((Test-Command -Command "sudo") ? "sudo" : "")

    if (Test-Command -Command "scoop") {
        $command = "scoop install $package"
    } elseif (Test-Command -Command "choco") {
        $command = "choco upgrade $package --confirm"
    } elseif (Test-Command -Command "apk") {
        $command = "$sudo apk add $package --no-cache"
    } elseif (Test-Command -Command "pacman") {
        $command = "$sudo pacman -Sy --noconfirm $package"
    } elseif (Test-Command -Command "brew") {
        $command = "brew install $package"
    } else {
        throw "Could not find supported package manager for installation."
    }

    $command | Invoke-FailFastExpression
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
    Write-Host $message -ForegroundColor Green
}

function Get-Files {
    Get-ChildItem . -Force
}

function Invoke-Btm {
    "btm -b" | Invoke-Expression
}

function Get-Ports {
    Get-NetTCPConnection
        | ForEach-Object { Add-Member -InputObject $_ -MemberType NoteProperty -Name "Cmd" -Value (Get-Process -Id $_.OwningProcess).Path -PassThru }
        | Select-Object LocalAddress, LocalPort, RemoteAddress, Remote-Port, State, OwningProcess, Cmd
}

function Invoke-FailFastExpression {
    param (
        [parameter(ValueFromPipeline)]
        [string]$command
    )

    $debug = [System.Environment]::GetEnvironmentVariable("DOTFILES_DEBUG")

    try {
        if ($debug -eq $Null) {
            Invoke-Expression $command | Out-Null
        } else {
            Invoke-Expression $command
        }
    } catch {
        Write-Error "Failed to execute $command, error details: $_"
        throw "Invoke-FailFastExpression failed"
    }
}

function Invoke-Expressions {
    param (
        [parameter(ValueFromPipeline)]
        [string[]]$commands
    )

    foreach ($command in $commands) {
        Write-Message "executing: '$command'"
        $command | Invoke-FailFastExpression
    }
}

# on different distributions
# python can be symlinked to python3
# we have to check always that we are working
# with python 3
function Get-PythonExecutable {
    if (Test-Command("python")) {
        $isPython3 = "python -V"
            | Invoke-Expression
            | Select-String -Pattern " 3." -Quiet

        if ($isPython3) {
            return (Get-Command "python").Source
        }
    }

    if (Test-Command("python3")) {
        return (Get-Command "python3").Source
    }

    throw "Could not find python 3 executable"
}

