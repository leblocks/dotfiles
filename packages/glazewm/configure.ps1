. $PSScriptRoot/../../utils.ps1

Test-Dependencies(@("winget"))

winget install GlazeWM

# add to autostart like admin
$autoStart = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\run"
$pathToExe = (which glazewm).Path

Remove-ItemProperty -Path $autoStart -Name glazewm -ErrorAction SilentlyContinue
New-ItemProperty -Path $autoStart -Name glazewm -Value $pathToExe

# recreate config link
LinkToHome $PSScriptRoot ".glaze-wm"

