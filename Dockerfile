# syntax=docker/dockerfile:1.4

FROM ghcr.io/jimpick/lotus-fvm-localnet-ready@sha256:f181f34189fd9b4ec7e3690ceca2c7d3d620a3fa9c9a06fb766049742d58b161

USER root

#RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
#RUN apt install -y nodejs

# Ubuntu "jammy" is too new and not supported by nodesource yet
# https://github.com/nodesource/distributions#manual-installation
ENV KEYRING=/usr/share/keyrings/nodesource.gpg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee "$KEYRING" >/dev/null
# wget can also be used:
# wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee "$KEYRING" >/dev/null
RUN gpg --no-default-keyring --keyring "$KEYRING" --list-keys
ENV VERSION=node_17.x
# The below command will set this correctly, but if lsb_release isn't available, you can set it manually:
# - For Debian distributions: jessie, sid, etc...
# - For Ubuntu distributions: xenial, bionic, etc...
# - For Debian or Ubuntu derived distributions your best option is to use the codename corresponding to the upstream release your distribution is based off. This is an advanced scenario and unsupported if your distribution is not listed as supported per earlier in this README.
RUN lsb_release -s -c
#ENV DISTRO="$(lsb_release -s -c)"
# Override DISTRO as "jammy" is not supported yet
ENV DISTRO=focal
RUN echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt install -y nodejs

RUN apt upgrade -y


WORKDIR /home/ubuntu/web

COPY . .

RUN chown -R ubuntu. .

USER ubuntu

RUN npm install

EXPOSE 3000

CMD node server.mjs
