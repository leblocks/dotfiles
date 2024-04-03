BeforeAll {
    . $PSScriptRoot/../utils.ps1
}

Describe 'utils environment variable manipulation' {
    AfterEach {
        # remove all TEST_ properties from .environment.json
        $environment = Join-Path $HOME ".environment.json"
        Get-Content $environment
            | ConvertFrom-Json
            | Select-Object -Property * -ExcludeProperty TEST_*
            | ConvertTo-Json
            | Set-Content $environment

        # remove all TEST_ entries from .path.json
        $path = Join-Path $HOME ".path.json"
        Get-Content $path
            | ConvertFrom-Json
            | Where-Object { $_ -notLike "TEST_*" }
            | ConvertTo-Json
            | Set-Content $path
    }

    It 'Can set environment variable' {
        Set-EnvironmentVariable "TEST_VAR" "TEST_VALUE"
        . $PROFILE
        $env:TEST_VAR | Should -Be "TEST_VALUE"
    }

    It 'Can set environment variable multiple times' {
        Set-EnvironmentVariable "TEST_VAR" "TEST_VALUE1"
        Set-EnvironmentVariable "TEST_VAR" "TEST_VALUE2"
        . $PROFILE
        $env:TEST_VAR | Should -Be "TEST_VALUE2"
    }

    It 'Can set multiple environment variables' {
        Set-EnvironmentVariable "TEST_VAR1" "TEST_VALUE1"
        Set-EnvironmentVariable "TEST_VAR2" "TEST_VALUE2"
        . $PROFILE
        $env:TEST_VAR1 | Should -Be "TEST_VALUE1"
        $env:TEST_VAR2 | Should -Be "TEST_VALUE2"
    }

    It 'Can add element to $PATH' {
        Add-PathEntry "TEST_my_path_entry"
        . $PROFILE

        [System.Collections.Generic.HashSet[string]]($env:PATH.Split($separator, 
            [System.StringSplitOptions]::RemoveEmptyEntries)) | Should -Contain "TEST_my_path_entry"
    }

    It 'Can add element to $PATH multiple times' {
        Add-PathEntry "TEST_my_path_entry"
        Add-PathEntry "TEST_my_path_entry2"
        Add-PathEntry "TEST_my_path_entry3"
        . $PROFILE

        $pathEntries = [System.Collections.Generic.HashSet[string]]($env:PATH.Split($separator,
            [System.StringSplitOptions]::RemoveEmptyEntries))

        $pathEntries | Should -Contain "TEST_my_path_entry"
        $pathEntries | Should -Contain "TEST_my_path_entry2"
        $pathEntries | Should -Contain "TEST_my_path_entry3"
    }
}

Describe 'utils' {
    It 'calling New-Folder for non existing folder' {
        $random = [Guid]::NewGuid().ToString()
        $folder = Join-Path ([System.IO.Path]::GetTempPath()) "meowing-$random"

        Test-Path $folder | Should -Be $false
        New-Folder $folder
        Test-Path $folder | Should -Be $true
    }

    It 'calling New-Folder on existing non-empty folder recreates it' {
        $random = [Guid]::NewGuid().ToString()
        $pathToFolder = Join-Path ([System.IO.Path]::GetTempPath()) "meowing-$random" "meow-meow"
        $pathToFile = Join-Path $pathToFolder "meow-file.txt"

        New-Item -Path $pathToFile -ItemType File -Force
        Test-Path $pathToFile | Should -Be $true
        New-Folder $pathToFolder
        Test-Path $pathToFolder | Should -Be $true
        Test-Path $pathToFile | Should -Be $false
    }

    It "calling Invoke-FailFastExpression throws on failed commands" {
        { Invoke-FailFastExpression "non-existing-command" } | Should -Throw
    }

    It "calling Invoke-FailFastExpression on success does not produce output" {
        Invoke-FailFastExpression "echo 1" | Should -Be $Null
    }

    It "calling Invoke-FailFastExpression on success provides output with debug flag" {
        [System.Environment]::SetEnvironmentVariable("DOTFILES_DEBUG", "1")
        Invoke-FailFastExpression "echo 1" | Should -Be "1"
        [System.Environment]::SetEnvironmentVariable("DOTFILES_DEBUG", "")
    }
}

