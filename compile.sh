#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [git url] [directory of project (default is /)]";
    echo "example: $0 https://github.com/googlesamples/android-vision.git visionSamples/FaceTracker";
    exit;
fi

if [ "$#" -lt 2 ]; then
    $2="/";
fi

GIT_URL="${1}";
BASE_DIR=`pwd`;
HASH_DIR=`echo -n ${GIT_URL} | md5sum | awk '{ print $1 }'`;
GIT_DIR="${BASE_DIR}/${HASH_DIR}/git";
APK_DIR="${BASE_DIR}/${HASH_DIR}/apk";
APP_URL="${GIT_DIR}/${2}";
ANDROID_DIR="${HOME}/Android/Sdk";

if [ -d $ANDROID_DIR ]; then

    export ANDROID_HOME="${ANDROID_DIR}";
    export ANDROID_SDK="${ANDROID_DIR}";

    echo "+ Upgrading SDK Tools ...";
    "${ANDROID_DIR}/tools/bin/sdkmanager" --update
    # printf 'y\n' | "${ANDROID_DIR}/tools/android" update sdk --no-ui;

    if [ ! -d "${BASE_DIR}/${HASH_DIR}/" ]; then
        echo "+ Setting workspace ...";
        mkdir -p "${GIT_DIR}" "${APK_DIR}";
    fi

    if [ -d "${GIT_DIR}/.git" ]; then
        echo "+ Upgrading project ...";
        cd "${GIT_DIR}/";
        git pull origin master;

    else
        echo "+ Cloning project ...";
        git clone "${GIT_URL}" "${GIT_DIR}";

    fi

    if [ -f "${APP_URL}/gradlew" ]; then
        cd "${APP_URL}/";
        chmod +x "${APP_URL}/gradlew";
        # ./gradlew assembleRelease -Pandroid.injected.signing.store.file="./../../key-store/production-${2}.jks" -Pandroid.injected.signing.store.password="${6}" -Pandroid.injected.signing.key.alias="${4}" -Pandroid.injected.signing.key.password="${5}";

        BUILD_STR_VERSION=`cat "${APP_URL}/app/build.gradle" | grep "buildToolsVersion"`;
        REGEX='buildToolsVersion\s+"(.*?)"'
        if [[ $BUILD_STR_VERSION =~ $REGEX ]]; then
            BUILD_VERSION="${BASH_REMATCH[1]}"

            echo "+ Updating Build tools ${BUILD_VERSION} ...";
            "${ANDROID_DIR}/tools/bin/sdkmanager" "build-tools;${BUILD_VERSION}" 
            # printf 'y\n' | "${ANDROID_DIR}/tools/android" list sdk -a | grep "${BUILD_VERSION}";

            echo "+ Compiling ...";
            ./gradlew clean assembleRelease -Pandroid.builder.sdkDownload=true;

            if [ -f "${APP_URL}/app/build/outputs/apk/app-release-unsigned.apk" ]; then
                mv "${APP_URL}/app/build/outputs/apk/app-release-unsigned.apk" "${APK_DIR}/app-release-unsigned.apk"
                echo "+ Application compiled in: ${APK_DIR}/app-release-unsigned.apk";

            else
                echo "! Unable compile the project.";
            fi
        else
            echo "! Unable get Build Tools version from project";
        fi
    else
        echo "! Unable clone the project.";
    fi
else
    echo "! SDK not found. Download into ${HOME}/Android/Sdk";
    echo 'Example: curl --location http://dl.google.com/android/android-sdk_r22.3-linux.tgz | tar -x -z -C $HOME';
fi
