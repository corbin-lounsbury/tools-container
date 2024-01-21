FROM ubuntu:22.04

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
    python3-pip

# install terraform and packer latest versions
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && apt install terraform packer

# install PowerShell core
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt update && apt install -y powershell

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash