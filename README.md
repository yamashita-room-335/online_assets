# online_assets

This sample flutter application integrates the functions of Play Asset Delivery (Android) and On-Demand Resources (iOS).

## Getting Started

If you touch this project in Android Studio, the following settings will make it easier to see.
- Add ` .pigeon.dart;` to settings of the ".dart" file nesting (Project View (the folder symbol in the upper left corner) > Options > Appearance > File Nesting...)
- "Do not format" setting (menu > File > Settings... > Editor > Code Style > Formatter > Do not format) to `*.{freezed,pigeon}.dart`.

## Android Test

This method of testing is only available for Android versions below 12. Alternatively, you can publish your app to the Google Play Store for internal testing.

1. Download the [BundleTool](https://github.com/google/bundletool/releases).

2. Build your app bundle:

    - **Build your app bundle:**
        ```bash
        flutter build appbundle
        ```

3. Use the following commands:

    - **Generate the APKs:**
        ```bash
        java -jar bundletool-all-<version>.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=<your_temp_dir>/app-release-pad-test.apks --local-testing
        ```

    - **Install the APKs on your device:**
        ```bash
        java -jar bundletool-all-<version>.jar install-apks --apks=<your_temp_dir>/app-release-pad-test.apks
        ```

4. To get the final APK size:
    ```bash
    java -jar bundletool-all-<version>.jar get-size total --apks=<your_temp_dir>/app-release-pad-test.apks --dimensions=SDK
    ```

