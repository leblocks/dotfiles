#! /bin/bash
set -euo pipefail
set -x
IFS=$'\n\t'

POWERSHELL_VERSION=7.5.4
POWERSHELL_HOME=~/powershell
POWERSHELL_ARCHIVE=$POWERSHELL_HOME/powershell-"${POWERSHELL_VERSION}".tar.gz
POWERSHELL_BINARIES_FOLDER=$POWERSHELL_HOME/$POWERSHELL_VERSION
POWERSHELL_BINARIES=$POWERSHELL_BINARIES_FOLDER/pwsh

if [ -f $POWERSHELL_BINARIES ] ; then
    echo $POWERSHELL_BINARIES already exists
    rm $POWERSHELL_BINARIES_FOLDER -rf
fi

DOWNLOAD_LINK=https://github.com/PowerShell/PowerShell/releases/download/v"${POWERSHELL_VERSION}"/powershell-"${POWERSHELL_VERSION}"-linux-x64.tar.gz

mkdir -p $POWERSHELL_BINARIES_FOLDER

# download binaries
curl -L -o $POWERSHELL_ARCHIVE $DOWNLOAD_LINK

# extract
tar zxf $POWERSHELL_ARCHIVE -C $POWERSHELL_BINARIES_FOLDER

# cleanup
rm $POWERSHELL_ARCHIVE -f

chmod -x $POWERSHELL_BINARIES

if [ -f /usr/bin/pwsh ] ; then
    rm /usr/bin/pwsh -f
fi

# create link
# ln -s $POWERSHELL_BINARIES_FOLDER/pwsh /usr/bin/pwsh

# to change default shell
# chsh -s $POWERSHELL_BINARIES_FOLDER/pwsh
# or
# ln -s $POWERSHELL_BINARIES_FOLDER/pwsh /usr/bin/pwsh

