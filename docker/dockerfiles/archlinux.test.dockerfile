FROM sashag1990/powershell-on-archlinux:7.5.3

RUN pacman-key --refresh-keys \
    && pacman -Syu \
        --noconfirm \
        git \
        nodejs \
        npm \
        python3 \
        less

CMD [ pwsh ]
