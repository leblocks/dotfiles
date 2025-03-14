#! /bin/sh

# http://redsymbol.net/articles/unofficial-bash-strict-mode/ strict mode for sh
set -euox

POWERSHELL_VERSION=`cat /dotfiles/bootstrap/.version`

# install the requirements
apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    musl-dev \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl \
    python3 \
    nodejs \
    npm \
    git

apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

curl -L https://github.com/PowerShell/PowerShell/releases/download/v"${POWERSHELL_VERSION}"/powershell-"${POWERSHELL_VERSION}"-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz --retry 5

mkdir -p /opt/microsoft/powershell/7
tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
chmod +x /opt/microsoft/powershell/7/pwsh
ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

