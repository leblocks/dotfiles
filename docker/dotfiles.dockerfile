FROM archlinux:base

COPY bootstrap/archlinux.sh .

ARG POWERSHELL_VERSION

ENV POWERSHELL_VERSION=${POWERSHELL_VERSION}

RUN /bin/bash -c /archlinux.sh \
    && pacman-key --refresh-keys \
    && pacman -Syu \
        --noconfirm \
        git \
        nodejs \
        npm \
        python3 \
        less

CMD [ "pwsh" ]

