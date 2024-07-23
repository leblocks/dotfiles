#! /bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/ strict mode for sh
set -euox


apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
apt-get install -y wget git curl apt-transport-https software-properties-common 
source /etc/os-release
wget -q "https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update
apt-get install -y powershell

wget "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

chmod u+x install.sh

NONINTERACTIVE=1 ./install.sh

