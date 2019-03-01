#https://stackoverflow.com/questions/48104954/adding-net-core-to-docker-container-with-jenkins

FROM jenkins/jenkins:lts
# Switch to root to install .NET Core SDK
USER root

# Just for my sanity... Show me this distro information!
RUN uname -a && cat /etc/*release

# Based on instructiions at https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
# Install depency for dotnet core 2.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl libunwind8 gettext apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-get update

# Install the .Net Core framework, set the path, and show the version of core installed.
RUN apt-get install -y dotnet-sdk-2.2 && \
    export PATH=$PATH:$HOME/dotnet && \
    dotnet --version

#Based on instructions from https://docs.docker.com/install/linux/docker-ce/ubuntu/
# Install packages to allow apt to use a repository over HTTPS
#RUN apt-get install -y \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg-agent \
#    software-properties-common

# Add Docker's official GPG key
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify that you now have the key by searching the last 8 characters of the fingerpring
#RUN apt-key fingerprint 0EBFCD88

# Setup the stable repository
#RUN add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"

# Update apt-get again
#RUN apt-get update

# Finally, install the latest version of Docker CE and containerd
#RUN apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker via convenience script
#RUN -fsSL https://get.docker.com -o get-docker.sh
#RUN sudo sh get-docker.sh

# Good idea to switch back to the jenkins user.
USER jenkins