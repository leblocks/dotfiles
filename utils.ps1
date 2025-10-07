
function Test-Command ([string] $Command)
{
    [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-Dependencies ([string[]] $packages)
{
    $errors = $packages
    | Where-Object { (-Not (Test-Command -Command $_)) }
    | ForEach-Object { "Package '$_' could not be found." }

    if (($errors | Measure-Object).Count -gt 0)
    {
        throw [string]::Concat([Environment]::NewLine, $errors)
    }
}

function LinkToHome ([string] $folder, [string] $fileName)
{
    $pathToLink = Join-Path $HOME $fileName

    Remove-Item `
        -Path $pathToLink `
        -ErrorAction SilentlyContinue `
        -Force

    New-Item `
        -ItemType SymbolicLink `
        -Path $pathToLink `
        -Target (Join-Path $folder $fileName) `
        -Force
}

function Get-PackageManager
{
    if (Test-Command -Command "brew")
    { return "brew"
    }
    if (Test-Command -Command "scoop")
    { return "scoop"
    }
    if (Test-Command -Command "pacman")
    { return "pacman"
    }
    throw "Could not find supported package manager for installation."
}

function Get-PackageManagerInstallCommand([string] $PackageManager, [string] $Package)
{
    switch($PackageManager)
    {
        "brew"
        { return "brew install $Package"
        }
        "scoop"
        { return "scoop install $Package"
        }
        "pacman"
        {
            $sudo = ""

            if (Test-Command -Command "sudo")
            {
                $sudo = "sudo"
            }

            return "$sudo pacman -Sy --noconfirm $Package"
        }
        default
        { throw "$PackageManager is not supported."
        }
    }
}

function Install-Packages([string] $PackageManager, [string[]] $Packages)
{
    $counter = 0
    foreach ($package in $Packages)
    {
        $counter++
        $progress = [int](($counter / $Packages.Count) * 100)

        Get-PackageManagerInstallCommand `
            -PackageManager $PackageManager `
            -Package $package
        | Invoke-FailFastExpression

        Write-Progress `
            -Activity "installing packages" `
            -Status $package `
            -PercentComplete $progress
    }
}

function Set-EnvironmentVariable ([string] $name, [string] $value)
{
    $path = Join-Path $HOME ".environment.json"

    if (-Not (Test-Path $path))
    {
        New-Item `
            -Path $path `
            -ItemType File `
            -Force

        # new file must be valid json
        Set-Content $path "{}"
    }

    $environment = Get-Content $path | ConvertFrom-Json
    $exists = [bool](Get-Member -InputObject $environment -MemberType NoteProperty -Name $name)

    if ($exists)
    {
        $environment."$name" = $value
    } else
    {
        Add-Member `
            -InputObject $environment `
            -MemberType NoteProperty `
            -Name $name `
            -Value $value
    }

    $environment
    | ConvertTo-Json
    | Set-Content $path
}

function Add-PathEntry ([string] $pathEntry)
{
    $path = Join-Path $HOME ".path.json"
    # .path.json is an array of additional path entries, that
    # must be unique, we don't want duplicates
    if (-Not (Test-Path $path))
    {
        $pathEntries = New-Object System.Collections.Generic.HashSet[string]
    } else
    {
        $pathEntries = [System.Collections.Generic.HashSet[string]](Get-Content $path | ConvertFrom-Json)
    }

    $pathEntries.Add($pathEntry)
    | Out-Null

    $pathEntries
    | ConvertTo-Json
    | Set-Content $path
}

function New-Folder ([string] $path)
{
    Remove-Item `
        -Path $path `
        -ErrorAction SilentlyContinue `
        -Recurse `
        -Force

    New-Item `
        -Path $path `
        -ItemType Directory `
        -Force
}

function Write-Message ([string] $message)
{
    Write-Host $message -ForegroundColor Green
}

function Get-Files
{
    Get-ChildItem . -Force
}

function Get-Ports
{
    Get-NetTCPConnection | ForEach-Object {
        Add-Member `
            -InputObject $_ `
            -MemberType NoteProperty `
            -Value (Get-Process -Id $_.OwningProcess).Path `
            -Name "Cmd" `
            -PassThru
    } | Select-Object "LocalAddress", "LocalPort", "RemoteAddress", "Remote-Port", "State", "OwningProcess", "Cmd"
}

function Invoke-FailFastExpression
{
    param (
        [parameter(ValueFromPipeline)]
        [string]$command
    )

    $debug = $env:DOTFILES_DEBUG

    try
    {
        if ($null -eq $debug)
        {
            Invoke-Expression $command | Out-Null
        } else
        {
            Invoke-Expression $command
        }
    } catch
    {
        throw "Invoke-FailFastExpression failed on $command with: $_"
    }
}

function Invoke-Expressions
{
    param (
        [parameter(ValueFromPipeline)]
        [string[]]$commands
    )

    $counter = 0;

    foreach ($command in $commands)
    {
        $counter++
        $progress = [int](($counter / $commands.Length) * 100)

        Write-Progress `
            -Activity $command `
            -PercentComplete $progress

        $command | Invoke-FailFastExpression
    }
}

# on different distributions
# python can be symlinked to python3
# we have to check always that we are working
# with python 3
function Get-PythonExecutable
{
    if (Test-Command -Command "python")
    {
        $isPython3 = "python -V"
        | Invoke-Expression
        | Select-String -Pattern " 3." -Quiet

        if ($isPython3)
        {
            return (Get-Command "python").Source
        }
    }

    if (Test-Command -Command "python3")
    {
        return (Get-Command "python3").Source
    }

    throw "Could not find python 3 executable"
}

function Get-CurrentGitBranch
{
    if (-Not [bool](Get-Command git))
    {
        return ""
    }

    $gitBranchName = (git branch --show-current 2>&1).ToString()

    if ($gitBranchName.Contains('fata'))
    {
        return ""
    }

    return $gitBranchName
}

function ConvertTo-Base64([string] $Content)
{
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    return [System.Convert]::ToBase64String($bytes)
}

function ConvertFrom-Base64([string] $Content)
{
    $bytes = [System.Convert]::FromBase64String($Content)
    return [System.Text.Encoding]::UTF8.GetString($bytes)
}

function New-Ctags([string] $Language)
{
    [string]::Join(" ",
        "ctags",
        "--recurse=yes",
        "--languages=$Language",
        "--tag-relative=yes",
        "--fields=+ailmnS",
        "--exclude=node_modules",
        "--totals=yes"
    ) | Invoke-Expression
}

function Invoke-PSScriptAnalyzer([string] $Path)
{
    $params = @{
        Path = $Path
        Recurse = $True
        ExcludeRule = @(
            "PSUseShouldProcessForStateChangingFunctions",
            "PSAvoidUsingPositionalParameters",
            "PSUseSingularNouns"
        )
    }

    return Invoke-ScriptAnalyzer @params
}

