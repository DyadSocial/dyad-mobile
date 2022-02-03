# Referencced from matsp/docker-flutter
# Ubuntu Official Image
FROM ubuntu:20.04

# Set ENV VARS

# Prerequisites for Flutter, Android SDK, and downloading tools
ENV JAVA_VERSION="8"
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update \
  && apt install -y --no-install-recommends curl sed git unzip xz-utils zip openjdk-8-jdk wget xz-utils ssh sudo tar

# New non-root user, dev
ENV UID="1000"
ENV GID="1000"
ENV USER="dev"
RUN groupadd --gid $GID %USER \
  && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

# Install Android SDK
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
ENV ANDROID_VERSION="28"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/home/$USER/Android"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV REPOS="/home/$USER/repos"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$REPOS/protoc/bin:$REPOS/protoc:$REPOS/protoc_plugin/protobuf.dart-protoc-plugin-19.2.0-1/protoc_plugin/bin:$PATH:/home/$USER/flutter/.pub-cache/bin"
RUN mkdir -p $ANDROID_SDK_ROOT \
  && mkdir -p /home/$USER/.android \
  && touch /home/$USER/.android/repositories.cfg \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
  && rm android_tools.zip \
  && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" \
  && yes "y" | sdkmanager "emulator" \
  && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"

# Install Flutter
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="2.2.1"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
RUN curl -o flutter.tar.xz $FLUTTER_URL \
  && mkdir -p $FLUTTER_HOME \
  && tar -xvf flutter.tar.xz -C /home/$USER

RUN flutter config --android-sdk $ANDROID_SDK_ROOT\
  && flutter config --no-analytics --enable-web \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  && flutter update-packages

# Install protoc binary and protoc_plugin for dart
ENV PROTOC_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip"
ENV PROTOC_PLUGIN_URL="https://github.com/google/protobuf.dart/archive/refs/tags/protoc_plugin-19.2.0+1.zip"
RUN mkdir -p /home/$USER/repos/protoc \
  && mkdir -p /home/$USER/repos/protoc_plugin \
  && wget $PROTOC_URL -O /home/$USER/repos/protoc.zip \
  && wget $PROTOC_PLUGIN_URL -O /home/$USER/repos/protoc_plugin.zip \
  && unzip /home/$USER/repos/protoc.zip -d /home/$USER/repos/protoc \
  && unzip /home/$USER/repos/protoc_plugin.zip -d /home/$USER/repos/protoc_plugin 
  # flutter run pub global activate protoc_plugin # run in project root dir

WORKDIR "/workspaces/dyad-mobile/dyadapp"
RUN flutter pub global activate protoc_plugin
ENV PATH="/home/$USER/.pub-cache/bin:${PATH}"