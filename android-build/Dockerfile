# syntax=docker/dockerfile:latest

# Nu: 0.100.0, Node: v20.18.0 LTS, npm: 10.8.2, pnpm: 9.12.3, Git: 2.39.5, fnm 1.37.2
# GNU bash: 5.2.15, Wget 1.21.3, aria2: 1.36.0, curl: 7.88.1, ripgrep 13.0.0, sd 1.0.0
# /etc/os-release: Debian GNU/Linux 12 (bookworm)
# Kernel: Linux bdbfa1bb3a92 6.4.16-linuxkit #1 SMP PREEMPT_DYNAMIC Thu Nov 16 10:55:59 UTC 2023 x86_64 GNU/Linux
# Build cmd: docker build . -t hustcer/rn-builder:android35-gradle8.10-jdk17-node20.18 --no-cache
FROM hustcer/debian-nu:0.100-node.20.18.lts

LABEL maintainer=hustcer<hustcer@outlook.com>

LABEL Description="This image provides a base Android development environment for React Native."

ENV DEBIAN_FRONTEND=noninteractive

# set default build arguments
ARG NODE_VERSION=20.18.0
ARG CMAKE_VERSION=3.22.1
# https://services.gradle.org/distributions/gradle-8.10.2-all.zip
ARG GRADLE_VERSION=8.10.2
ARG WATCHMAN_VERSION=4.9.0
ARG ANDROID_BUILD_VERSION=35
ARG NDK_VERSION=27.1.12297006
ARG ANDROID_TOOLS_VERSION=35.0.0
# https://developer.android.com/studio#command-tools
ARG SDK_VERSION=commandlinetools-linux-11076708_latest.zip

# set default environment variables, please don't remove old env for compatibilty issue
ENV ADB_INSTALL_TIMEOUT=10
ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/$NDK_VERSION

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CMAKE_BIN_PATH=${ANDROID_HOME}/cmake/$CMAKE_VERSION/bin

ENV PATH=${CMAKE_BIN_PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_NDK_HOME}:${PATH}

# Install system dependencies
RUN apt update -qq && apt install -qq -y --no-install-recommends --no-install-suggests \
        file \
        gcc \
        g++ \
        gnupg2 \
        libc++1 \
        libgl1 \
        libtcmalloc-minimal4 \
        make \
        openjdk-17-jdk-headless \
        openssh-client \
        patch \
        python3 \
        python3-distutils \
        rsync \
        ruby \
        ruby-dev \
        tzdata \
        sudo \
        ninja-build \
        zip \
        ccache \
        # Dev libraries requested by Hermes
        libicu-dev \
        # Dev dependencies required by linters
        jq \
        shellcheck \
    && gem install bundler \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y

# Download and setup Gradle
RUN mkdir -p ${ANDROID_HOME}/gradle && curl -sSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -o gradle-${GRADLE_VERSION}-all.zip  \
    && unzip gradle-${GRADLE_VERSION}-all.zip -d ${ANDROID_HOME}/gradle  \
    && mkdir -p ${ANDROID_HOME}/gradle/wrapper/distributions \
    && mv gradle-${GRADLE_VERSION}-all.zip ${ANDROID_HOME}/gradle/wrapper/distributions/

COPY init.gradle /root/.gradle/init.gradle
COPY init.gradle /root/.gradle/init.gradle.kts

# Set environment variables for Gradle
ENV GRADLE_HOME=${ANDROID_HOME}/gradle/gradle-${GRADLE_VERSION}
ENV GRADLE_USER_HOME=${ANDROID_HOME}/gradle
ENV PATH=${GRADLE_HOME}/bin:$PATH
ENV GRADLE_OPTS="-Dgradle.user.home=${GRADLE_USER_HOME} \
    -Dorg.gradle.daemon=false \
    -Dorg.gradle.parallel=true \
    -Dorg.gradle.jvmargs=-Xmx4096m \
    -Dorg.gradle.configureondemand=true \
    -Dorg.gradle.caching=true"

# Full reference at https://dl.google.com/android/repository/repository2-1.xml
# download and unpack android
RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && unzip -q -d ${ANDROID_HOME}/cmdline-tools /tmp/sdk.zip \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/sdk.zip \
    && yes | sdkmanager --licenses \
    && yes | sdkmanager "platform-tools" \
        "platforms;android-$ANDROID_BUILD_VERSION" \
        "build-tools;$ANDROID_TOOLS_VERSION" \
        "cmake;$CMAKE_VERSION" \
        "ndk;$NDK_VERSION" \
    && rm -rf ${ANDROID_HOME}/.android \
    # Disable git safe directory check as this is causing GHA to fail on GH Runners
    && git config --global --add safe.directory '*'

# 确保所有缓存目录都有正确的权限
RUN chmod -R 777 /root/.gradle \
    && chmod -R 777 ${ANDROID_HOME} \
    && chmod -R 777 ${GRADLE_USER_HOME}
