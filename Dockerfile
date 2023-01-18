FROM jenkins/jnlp-slave

USER root

RUN apt-get update && apt-get install -y \
    curl \
    gradle \
    maven \
    wget

# Dependencies to execute Android builds
RUN dpkg --add-architecture i386 && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libc6:i386 \
    libgcc1:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# nvm environment variables
ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=14.15.0

# install gcloud
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz -O g.tar.gz && \
    tar xf g.tar.gz && \
    rm g.tar.gz && \
    mv google-cloud-sdk /opt/google-cloud-sdk && \
    /opt/google-cloud-sdk/install.sh -q && \
    /opt/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true
# add gcloud SDK to path
ENV PATH="${PATH}:/opt/google-cloud-sdk/bin/"

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

SHELL ["/bin/bash", "-c"]

# install node and npm
RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
