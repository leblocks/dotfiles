<#
.SYNOPSIS
   Watches text files for changes and prints the specified number of lines from the end of the file.
.DESCRIPTION
   This function monitors a set of text files for changes and prints the content to the console.
   Each line printed is prefixed by the filename.
.PARAMETER Paths
   An array of paths to text files to monitor. This parameter is mandatory.
.PARAMETER Tail
   Number of lines to print from the end of each file initially.
.PARAMETER ThrottleLimit
   Limits the number of script blocks running in parallel.
   By default, it is set to the number of paths passed.
.EXAMPLE
   Watch-Files -Paths "C:\File1.txt", "C:\File2.txt" -Tail 10
   # watching files in a path by a glob
   Write-Output (Get-ChildItem *.txt) -NoEnumerate | Watch-Files
#>
function Watch-Files {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification='script is being executed on a console')]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]] $Paths,
        [int] $Tail = 10,
        [int] $ThrottleLimit
    )

    if ($ThrottleLimit -eq 0) {
        $ThrottleLimit = $Paths.Length
    }

    $Paths |
        ForEach-Object -Parallel {
            $path = $_;
            $fileName = (Get-ChildItem $path).Name
            Get-Content -Wait -Tail $($using:Tail) -Path $path
                | ForEach-Object {
                    $colors = [Enum]::GetNames([System.ConsoleColor])
                        | Select-Object -Skip 1

                    $index = [array]::IndexOf($($using:Paths), $path)

                    $color = $colors[$index % $colors.Length]
                    Write-Host "[$fileName] " -NoNewLine -ForegroundColor $color
                    Write-Host ${_}
                }
        } -ThrottleLimit $ThrottleLimit
}

