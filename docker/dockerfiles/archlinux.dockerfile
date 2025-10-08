FROM archlinux:base

COPY bootstrap/archlinux.sh .

ARG POWERSHELL_VERSION

ENV POWERSHELL_VERSION=${POWERSHELL_VERSION}

RUN /bin/bash -c /archlinux.sh

CMD [ pwsh ]

