#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
POWERSHELL_VERSION="$(cat "${SCRIPT_DIRECTORY}"/.version)"

curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v"${POWERSHELL_VERSION}"/powershell-"${POWERSHELL_VERSION}"-linux-x64.tar.gz
rm /opt/microsoft/powershell/7 -rf
mkdir -p /opt/microsoft/powershell/7
tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
chmod +x /opt/microsoft/powershell/7/pwsh

if [ -f /usr/bin/pwsh ] ; then
    rm /usr/bin/pwsh
fi


ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

