. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Describe 'tree-sitter' -Skip:$IsLinux {
    It 'CC env variable is set to gcc' {
        $env:CC | Should -Be 'gcc'
    }
}

