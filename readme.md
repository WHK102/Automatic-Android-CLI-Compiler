# Automatic Compiler for Android Projects

Automatic compiler via Bash script. Generate APK without the need of Android Studio or graphic interface.


## Advantage

- It's free.
- Automatically detects and installs the version of the SDK to be compiled.
- Automatically detects and installs the Build Tools version to be compiled.
- Organize the files as a database.
- Update repositories that have already been previously cloned.
- Customizable for compilation with pki keys.
- No root privilegies required.


## Howto use?

    whk@machine:~$ ./compile.sh https://github.com/googlesamples/android-vision.git visionSamples/FaceTracke
    + Upgrading SDK Tools ...
    + Upgrading project ...
    + Updating Build tools 24.0.2 ...
    + Compilling ...
    + Application compiled in: 458816d1f97d529c1d2fe9dcf3127e1a/apk/app-release-unsigned.apk

If need Android SDK can download:

    curl --location http://dl.google.com/android/android-sdk_r22.3-linux.tgz | tar -x -z -C $HOME

No matter the version of the SDK to be downloaded, it will be updated automatically depending on each project.


## How to contribute?

|METHOD                 |WHERE                                                                                        |
|-----------------------|---------------------------------------------------------------------------------------------|
|Donate                 |[Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KM2KBE8F982KS) |
|Find bugs              |Using the [Issues tab](https://github.com/WHK102/Automatic-Android-CLI-Compiler/issues)      |
|Providing new ideas    |Using the [Issues tab](https://github.com/WHK102/Automatic-Android-CLI-Compiler/issues)      |
|Creating modifications |Using the [Pull request tab](https://github.com/WHK102/Automatic-Android-CLI-Compiler/pulls) |
