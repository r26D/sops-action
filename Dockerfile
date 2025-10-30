#This docker file was based on one from LICENSE.DavidTesar
FROM debian:trixie-slim

# Sops is used to handle the decryption of secrets by helm secerts
#Version can be found at
#https://github.com/getsops/sops/releases
ENV SOPS_VERSION="3.11.0"

#The PLUGINS directory gets unset and breaks the scripts later
ENV HELM_PLUGINS="/root/.local/share/helm/plugins"
RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y install ca-certificates bash git ssh curl gnupg  wget  grep vim




RUN wget -q https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -O /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops


#WORKDIR /config
COPY sops_test_files /sops_test_files
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
