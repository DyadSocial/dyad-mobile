# Ubuntu Official Image
FROM ubuntu:18.04

# Prerequisites for Flutter, Android SDK, and downloading tools
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# New non-root user, dev
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

# Android SDK dirs and System vars
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/dev/Android/sdk
RUN mkdir -p .android touch .android/repositories.cfg

# Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/dev/flutter/bin"

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" "cmdline-tools;latest" "system-images;android-29;google_apis_playstore;x86"
ENV PATH "$PATH:/home/dev/Android/sdk/platform-tools"
ENV PATH "$PATH:/home/dev/Android/sdk/cmdline-tools/latest/bin"

# Install Dart
RUN flutter doctor
