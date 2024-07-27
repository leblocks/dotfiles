#! /bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/ strict mode for sh
set -euox

sudo apt-get update
sudo apt-get install -y \
        wget \
        apt-transport-https \
        software-properties-common \
        build-essential

source /etc/os-release

wget -q "https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y powershell

