FROM ubuntu:latest

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#
# Install needed packages for linux development, setup user and clean up.
RUN  apt-get update \
	&& apt install -y sudo \
	&& apt install -y openjdk-17-jdk-headless --no-install-recommends \
	&& apt install -y wget curl git xz-utils zip unzip --no-install-recommends \
	&& apt install -y clang cmake ninja-build pkg-config gnupg2 libgtk-3-dev \
	&& apt install -y adb

# add user and setup as sudoer
RUN	groupadd --gid $USER_GID $USERNAME
RUN	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN	echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN	chmod 0440 /etc/sudoers.d/$USERNAME

# add to plugdev group
RUN usermod -aG plugdev $USERNAME
   
# Clean Up
RUN	apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* 

#[optional] install chrome inside of devcontainer
#           can be done but is not necessary since the host web browser will be used alternatively
# ENV DEBIAN_FRONTEND noninteractive
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
#     && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
# RUN apt-get update && apt-get -y install google-chrome-stable

#
# Android SDK
# https://developer.android.com/studio#downloads
ENV ANDROID_SDK_TOOLS_VERSION=8512546
ENV ANDROID_PLATFORM_VERSION=33
ENV ANDROID_BUILD_TOOLS_VERSION=33.0.0
ENV ANDROID_HOME=/home/${USERNAME}/android-sdk-linux
ENV ANDROID_SDK_ROOT="$ANDROID_HOME"
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator


# Android SDK	
####### get the newest Android SDK version at: https://androidsdkoffline.blogspot.com/p/android-sdk-cmdline-tools-offline.html
RUN curl -C - --output android-sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9644228_latest.zip \
	&& mkdir -p ${ANDROID_HOME}/ \
	&& unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
	&& rm android-sdk-tools.zip \
	&& yes | sdkmanager --licenses \
	&& touch $HOME/.android/repositories.cfg \
	&& sdkmanager platform-tools \
	&& sdkmanager emulator \
	&& sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
	&& sdkmanager --install "cmdline-tools;latest" 
# create emulator android	
RUN echo 'export ANDROID_HOME="${ANDROID_HOME}"' >> /home/$USERNAME/.bashrc
RUN echo 'export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT}"' >> /home/$USERNAME/.bashrc
ENV export PATH="$PATH:${ANDROID_HOME}/bin"
RUN echo 'export PATH="$PATH:${ANDROID_HOME}/bin"' >> /home/$USERNAME/.bashrc

RUN  sdkmanager "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64" \
	 && echo no | avdmanager create avd -n Android${ANDROID_PLATFORM_VERSION} -k "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64"

ENV FLUTTER_DIR=/home/${USERNAME}
####### get the newest flutter version at: https://docs.flutter.dev/get-started/install/linux
RUN wget -O flutter_linux.zip.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.4-stable.tar.xz \
 && tar xf flutter_linux.zip.tar.xz -C $FLUTTER_DIR && rm flutter_linux.zip.tar.xz

RUN export PATH="$PATH:/home/developer/flutter/bin"
RUN echo 'export PATH="$PATH:/home/developer/flutter/bin"' >> /home/$USERNAME/.bashrc

 
RUN curl -sL https://firebase.tools | bash

ENV NODE_VERSION=18.17.1
# RUN apt install -y curl
ENV NVM_DIR=/home/developer/.nvm
RUN mkdir -p ${NVM_DIR}
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/home/developer/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN echo 'export PATH="$PATH":"/home/developer/.nvm/versions/node/v${NODE_VERSION}/bin/"' >> /home/$USERNAME/.bashrc
RUN chown -R developer:developer ${NVM_DIR}
RUN npm install -g typescript

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
RUN echo 'export PATH="$PATH":"/usr/local/gcloud/google-cloud-sdk/bin"' >> /home/$USERNAME/.bashrc

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:deadsnakes/ppa && \
apt-get update && apt-get install -y python3.11 python3-pip python3.11-venv python3.11-distutils && \
python3 -m pip install fastapi[all] uvicorn python-geohash geopy pytz firebase-admin google-cloud google-api-python-client ipykernel requests
# RUN echo 'alias python=python3' >> /home/$USERNAME/.bashrc


WORKDIR /home/$USERNAME
USER $USERNAME


RUN export PATH="$PATH:/home/developer/flutter/bin" \
 && flutter config --android-sdk ${ANDROID_SDK_ROOT} \
 && flutter config --no-analytics \
 && flutter update-packages \
 && yes | flutter doctor --android-licenses

RUN export PATH="$PATH":"$HOME/.pub-cache/bin"
RUN echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> /home/$USERNAME/.bashrc
RUN export PATH="$PATH:/home/developer/flutter/bin" \
    && dart pub global activate flutterfire_cli
