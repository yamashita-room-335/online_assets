# online_assets

This sample flutter application integrates the functions of Play Asset Delivery (Android) and On-Demand Resources (iOS).

## Getting Started

### Android Test

This method of testing is only available for Android versions below 12. Alternatively, you can publish your app to the Google Play Store for internal testing.

1. Download the [BundleTool](https://github.com/google/bundletool/releases).

2. Build your app bundle:

    - **Build your app bundle:**
        ```bash
        flutter build appbundle
        ```

3. Use the following example commands. (Of course, you can change the path and file name.):

    - **Generate the APKs:**
        ```bash
        java -jar bundletool-all-1.18.1.jar build-apks --overwrite --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/app-release-pad-test.apks --local-testing
        ```

    - **Install the APKs on your device:**
        ```bash
        java -jar bundletool-all-1.18.1.jar install-apks --apks=build/app/outputs/bundle/release/app-release-pad-test.apks
        ```

4. To get the final APK size:
    ```bash
    java -jar bundletool-all-1.18.1.jar get-size total --apks=build/app/outputs/bundle/release/app-release-pad-test.apks --dimensions=SDK
    ```

