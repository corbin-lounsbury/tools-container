FROM ubuntu:24.10
ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# install basic tools
RUN apt update && apt install -y \
    wget \
    curl \
    git \
    unzip \
    nano \
    jq \
    gnupg \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    software-properties-common\
    python3 \
    python3-pip \
    pipx \
    mkisofs \
    gpg

# install terraform and packer latest versions
RUN wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list &&\
    apt update && apt install packer terraform

# install PowerShell core
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt update && apt install -y powershell


# Install ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

# entrypoint that allows commands to be run and can run interactively
ENTRYPOINT ["/bin/bash"]