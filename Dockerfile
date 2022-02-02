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
ENV ANDROID_SDK_ROOT="home/$USER/Android"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"
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
ENV FLUTTER_VERSION="2.8.1"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_WEB_PORT="8090"
ENV FLUTTER_DEBUG_PORT="42000"
ENV FLUTTER_EMULATOR_NAME="flutter_emulator"
RUN curl -o flutter.tar.xz $FLUTTER_URL \
  && tar-xvf flutter.tar.xz -C /home/$USER
RUN mkdir -p $FLUTTER_HOME \
  && tar -xvf flutter.tar.xz -C /home/$USER \
  && ls /home/$USER/flutter \
  && flutter config --no-analytics \
  && flutter precache \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  && flutter emulators --create \
  && flutter update-packages

# Install protoc binary and protoc_plugin for dart
ENV PROTOC_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip"
ENV PROTOC_PLUGIN_URL="https://github.com/google/protobuf.dart/archive/refs/tags/protoc_plugin-19.2.0+1.zip"
RUN mkdir -p /home/$USER/repos/ \
  && wget $PROTOC_URL -o /home/$USER/repos/protoc.zip \
  && wget $PROTOC_PLUGIN_URL -o /home/$USER/repos/protoc_plugin.zip \
  && unzip /home/$USER/repos/protoc.zip -d /home/$USER/repos/protoc \
  && unzip /home/$USER/repos/protoc_plugin.zip -d /home/$USER/repos/ \
  && mv /home/$USER/repos/protoc/bin/* /usr/bin \
  && mv /home/$USER/repos/protoc/include /usr/bin \
  && mv /home/$USER/repos/protoc_plugin/protobuf.dart-protoc-plugin-19.2.0-1/protoc_plugin/bin/* /usr/bin \
  && flutter run pub global activate protoc_plugin

#COPY entrypoint.sh /usr/local/bin/
#COPY chown.sh /usr/local/bin
#COPY flutter-android-emulator.sh /usr/local/bin/flutter-android-emulator
#ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
