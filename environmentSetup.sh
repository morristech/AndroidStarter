#!/bin/bash

# Fix the CircleCI path
function getAndroidSDK {
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

  DEPS="$ANDROID_HOME/installed-dependencies"

  if [ ! -e $DEPS ]; then
    echo y | android update sdk -u -a -t android-25 &&
    echo y | android update sdk -u -a -t platform-tools &&
    echo y | android update sdk -u -a -t build-tools-23.0.3 &&
    echo y | android update sdk -u -a -t "extra-android-m2repository" &&
    echo y | android update sdk -u -a -t "extra-android-support" &&
    echo y | android update sdk -u -a -t "extra-google-m2repository" &&
    echo y | android update sdk -a --no-ui --filter sys-img-armeabi-v7a-android-25 &&
    echo no | android create avd -n testAVD -f -t android-25 --abi default/armeabi-v7a &&
    touch $DEPS
  fi
}

function waitForAVD {
  local bootanim=""
  export PATH=$(dirname $(dirname $(which android)))/platform-tools:$PATH
  until [[ "$bootanim" =~ "stopped" ]]; do
    sleep 5
    bootanim=$(adb -e shell getprop init.svc.bootanim 2>&1)
    echo "emulator status=$bootanim"
  done
}
