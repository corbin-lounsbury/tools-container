FROM ubuntu:25.10
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
    mkisofs

# install terraform and packer latest versions
RUN wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    sudo apt update && sudo apt install packer terraform

# install PowerShell core
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt update && apt install -y powershell

# install Azure CLI
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt install azure-cli

# Install azure functions core tools
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    curl -sL https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/microsoft-prod.list && \
    apt update && apt install -y azure-functions-core-tools-4

# Install ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

# Install ansible pyvomi vsphere sdk
RUN python3 -m pip config set global.break-system-packages true
RUN pip3 install pyvmomi ansible requests
RUN pip3 install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

# entrypoint that allows commands to be run and can run interactively
ENTRYPOINT ["/bin/bash"]