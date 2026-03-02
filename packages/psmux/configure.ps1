. $(Join-Path $PSScriptRoot .. .. utils.ps1)

Test-Dependencies @("psmux", "git")

LinkToHome $PSScriptRoot ".psmux.conf"

$plugins = $(Join-Path $env:USERPROFILE .psmux plugins psmux-plugins)

# get ppm plugins manager
if (-Not (Test-Path $plugins)) {
    git clone https://github.com/marlocarlo/psmux-plugins $plugins
}

try
{
    # get latest plugins repo
    Push-Location $plugins
    git pull
    . $(Join-Path $plugins ppm ppm.ps1)
    Install-AllPlugins
}
finally { Pop-Location }



