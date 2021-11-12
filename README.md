# My Beauty Advisor

A D2C mobile application

# Installation and Usage
1. Follow the installation instructions on https://flutter.io/get-started/install/ to install Flutter.
    * System requirements
        * Operating System of 64 bit (Windows, MacOs, Linux)
        * Disk Space: Windows - 400 MB, MacOs - 700 MB, Linux - 600 MB
        * Tools: Windows (git), MacOs-Linux (bash, mkdir, rm, git, curl, unzip, which)
    * Get the Flutter SDK
To get Flutter, use git to clone this [repository](https://github.com/flutter/flutter) and then add the flutter tool (path\to\flutter\bin) to your computer path.
    * run "flutter doctor" on command prompt or POWER SHELL.
    Running flutter doctor shows any remaining dependencies you may need to install.
    * iOS setup
        - Install Xcode
        - Set up the iOS simulator
        - if you want to deploy to iOs devices you need to intall these dependencies:
    homebrew, libimobiledevice, ideviceinstaller, ios-deploy, cocoapods
    * Android setup 
        - Install Android Studio, IntelliJ or Visual Studio Code
        - Dependencies: Flutter and Dart plugins (Android Studio, IntelliJ) - dart code Extension (Visual Studio Code)
        - Set up your Android device or emulator
2. Clone this repository
```
git clone https://github.com/Cosme-code/mybeautyadvisor.git
```
3. Launching the application
    In the root of the project run the command 
```
flutter run
```

# Some knowledge
## Restart and hot restart
    Flutter known with his ability of hot restart (building only the modified widget instead
    of building all the app in case of you change the code)
* Restart
```
flutter run
```
* Hot Restart
```
flutter Run
```

## Clean the build
```
flutter clean
```

## Get the dependencies
```
flutter pub  get
```

# Dependencies
    All the dependencies are located in ```pubspec.yaml```

# Build the APKs for Android
```
flutter build apk --split-per-abi
```

# Keys
## release  key
The key is in: `android/upload-keystore.jks`
```
${keytool} -list -v -storetype jks -keystore {keystore_file}
```
infos is in `android/key.properties`
```
storePassword = mybeautyadvisor
keyPassword = mybeautyadvisor
keyAlias = alias_name
storeFile = /upload-keystore.jks
```
## facebook hash
The key is in: `android/fb_hash.txt`
```
${keytool} -exportcert -alias fb-android-hash -keystore my-release-key.keystore | ${openssl} sha1 -binary | ${openssl} base64
```

## Google play Console Tips:
Build The Bundle (you can putthe fat apk, but it's preferable to build the bundle)
```
flutter build appbundle
```
To be able to add various versions, we have to edit the
- **versionCode**
- **versionName**
in `android/app/build.gradle`


## Firebase account
Im using my personal account, plz create a firebase account and change the json file


# Owner
- **Cosmecode**
