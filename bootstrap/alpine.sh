#! /bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/ strict mode for sh
set -euox

# script is taken from here https://learn.microsoft.com/en-us/powershell/scripting/install/install-alpine?view=powershell-7.3
POWERSHELL_VERSION=7.3.9

# install the requirements
apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl

apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

curl -L https://github.com/PowerShell/PowerShell/releases/download/v"${POWERSHELL_VERSION}"/powershell-"${POWERSHELL_VERSION}"-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz

mkdir -p /opt/microsoft/powershell/7
tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
chmod +x /opt/microsoft/powershell/7/pwsh
ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

