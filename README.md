# Readme Language

[English](README.md) | [日本語](README.ja.md)

# online_assets

## Introduction

This is a sample Flutter application that integrates the functions of Play Asset Delivery (Android) and On-Demand Resources (iOS).

The license is MIT, so feel free to customize or library it individually.

## Quick Usage Guide

1. Set up assets according to the functions of Play Asset Delivery (Android) and On-Demand Resources (iOS).

2. Call `OnlineAssets.instance.init()` to provide the asset pack names and types.

    ```dart
    void main() {
      // ...
      OnlineAssets.instance.init(
        assetPackSettingsList: [
          OnlineAssetPackSettings(
            packName: 'install_time_sample_pack',
            androidAssetPackDeliveryMode: AndroidAssetPackDeliveryMode.installTime,
            iosOnDemandResourceType: IOSOnDemandResourceType.assetsWithoutTag,
          ),
          // ...
        ],
      );
    
      runApp(const MyApp());
    }
    ```

3. Call `OnlineAssets.instance.streamFile()` to start downloading the assets and get the status and downloaded files.

    ```dart
    StreamBuilder<(File?, OnlinePack)>(
      stream: OnlineAssets.instance.streamFile(
        packName:'install_time_sample_pack',
        relativePath: 'install_time_sample_pack/dog/image.png',
      ),
      // ...
    )
    ```

That's all for the basic usage!
There are many other features as well.

- Call `OnlineAssets.instance.fetch()` to download the assets.

    ```dart
    OnlineAssets.instance.fetch([
      'on_demand_sample_pack',
    ])
    ```

- You can also check the download status of the packs.

    ```dart
    StreamBuilder(
      stream: OnlineAssets.instance.onlinePackSubjectMap['on_demand_sample_pack']!,
      builder: (
        BuildContext context,
        AsyncSnapshot<OnlinePack> snapshot,
      ) {
        // ...
        final onlinePack = snapshot.data!;
        // ...
    ```

- If you are sure that the files exist, such as "using Android's install-time asset pack", "using iOS's Initial install tags assets", or "confirmed that they have been downloaded on the previous screen", you can call `OnlineAssets.instance.getFile()`.

    ```dart
    FutureBuilder<File?>(
      future: OnlineAssets.instance.getFile(
        packName: assetName,
        relativePath: relativePath,
      ),
      // ...
    )
    ```

    However, if the file cannot be obtained, null will be returned.
    
    Therefore, on pages using this, you need to monitor the pack status and navigate to another page if there is a problem, or make the UI such that it is not a problem if it is not displayed.


## Notes for iOS Testing

You cannot obtain On-Demand Resources with the run button of Android Studio or flutter run.
You can check the On-Demand Resources function by running with the Run button of Xcode, but there is a restriction that resources that come with the app at the time of installation do not exist, so you need to be careful about the following points.

- Initial install tags resources do not exist at the time of installation and cannot be downloaded, so they cannot be checked.
- Prefetch tag order resources are not automatically downloaded after installation and need to be called for download, so they can only be checked in the same way as On-Demand.

If you deliver the app to App Store Connect and test it via TestFlight, it will work properly.
Therefore, in the initial implementation, use resources other than Initial install tags and switch the resource types with TestFlight.

## Notes for Android Testing

You cannot obtain Asset Pack with the run button of Android Studio or flutter run.
You can check the Play Asset Delivery function by using BundleTool, but there is a restriction that all Asset Packs are installed on the device, so you can only check the normal case where they can be downloaded.

If you place the app on the Google Play Console and test it via internal testing, it will work properly.
Therefore, in the initial implementation, test with BundleTool and test error cases on the Google Play Console.

1. Download [BundleTool](https://github.com/google/bundletool/releases).

2. Build the app.

    ```bash
    flutter build appbundle
    ```

3. Run the following commands. (Of course, you can change the paths and file names)

    ```bash
    java -jar bundletool-all-1.18.1.jar build-apks --overwrite --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/app-release-pad-test.apks --local-testing
    ```

    ```bash
    java -jar bundletool-all-1.18.1.jar install-apks --apks=build/app/outputs/bundle/release/app-release-pad-test.apks
    ```

- You can check the information with the following commands as needed.

    - Check the final APK size

        ```bash
        java -jar bundletool-all-1.18.1.jar get-size total --apks=build/app/outputs/bundle/release/app-release-pad-test.apks --dimensions=SDK
        ```

### Details
- [Integrate asset delivery (Kotlin and Java)  |  Google Play  |  Android Developers](https://developer.android.com/guide/playcore/asset-delivery/integrate-java)
- [Test asset delivery  |  Google Play  |  Android Developers](https://developer.android.com/guide/playcore/asset-delivery/test)

---

# Explanation of Sample App Implementation

To help you implement it in your app, here is an explanation of the implementation of this sample app.

The files committed first were created with "New Project" in Android Studio.

Therefore, the contents added in the implementation of the sample app can be checked in the diff files between the first commit and the latest commit.

Even if Flutter or each plugin becomes outdated, you can understand this implementation and create a new Flutter project to migrate the diff files and make it work.

## Supported Platforms

The implementation of this sample app supports both Android and iOS, but does not support other platforms.

Therefore, to incorporate this function into an app that also implements other platforms, you need to handle it with a separate branch in Git, etc.

For example, keep the implementation using Flutter assets in the main branch, and move from Flutter assets to platform-specific assets in the branch for this function (Android & iOS).

It is probably possible to manage with Flavor, but since the author has not tried it, unexpected problems may occur.

## Play Asset Delivery (Android)

### Setup of Asset and Gradle Settings

Referring to the [Android developers site](https://developer.android.com/guide/playcore/asset-delivery/integrate-java#build_for_kotlin_and_java), I added asset and Gradle settings on the Android side.

As of March 23, 2025, it is stated that the AndroidManifest.xml of each asset pack is generated during Gradle build, but it is not automatically generated in Flutter 3.29.2.

Therefore, I created a pure Android app, performed a Gradle build to check the AndroidManifest.xml, and created the AndroidManifest.xml for each asset pack by referring to the [description of the AndroidManifest.xml of another function](https://developer.android.com/guide/playcore/feature-delivery/instant).

### Notes on Android Asset Specifications

#### Regarding namespace for Android asset packs

It is possible to install files with the same relative path in different asset packs, but that requires that the contents of the files must also be the same.

For example, suppose you put assets as follows.

* android/install_time_sample_pack/src/main/assets/dog/image.png
* android/on_demand_sample_pack/src/main/assets/dog/image.png

If image.png is the same image file, the build will succeed, but if it is a different image file, the following build error will occur

```bash
FAILURE: Build failed with an exception.

* What went wrong: Execution failed for task ':app
Execution failed for task ':app:packageReleaseBundle'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.PackageBundleTask$BundleToolWorkAction
   > Modules 'install_time_sample_pack' and 'on_demand_sample_pack' contain entry 'assets/dog/image.png' with different content.
```

Therefore, it would be safer to create a folder with the pack name under the assets folder, as in this sample app.

* android/install_time_sample_pack/src/main/assets/install_time_sample_pack/dog/image.png
* android/on_demand_sample_pack/src/main/assets/on_demand_sample_pack/dog/image.png

#### Restrictions on Android Asset Packs

There are restrictions listed in the [Play Console Help](https://support.google.com/googleplay/android-developer/answer/9859372#size_limits).

- Size limit of individual asset packs: 1.5GB
- Cumulative size limit of all modules and install-time asset packs: 4GB
- Cumulative size limit of on-demand and fast-follow asset packs: 4GB
- Maximum number of asset packs: 100

If the app size is likely to become large enough to consider the size limit, it is recommended to divide the asset packs by major functions.

Also, understand the types and restrictions of On-Demand Resources mentioned later and think about how to divide the asset packs.

#### Resolution of Android Assets

Unlike Flutter assets and Android resources, Android assets do not have a mechanism to switch files called by device resolution.

Therefore, this sample app only has one type of resolution.

If you want to use such a function, you need to implement switching the asset pack (or files for each device resolution in the same asset pack) for each device resolution on the app side.

※ Pull requests for this function are welcome.

If you use asset packs for each device resolution, you can reduce the app size because files of unused resolutions will not be downloaded.
However, there is a disadvantage that the number of packs will easily reach the upper limit of 100 if you consider "5 types of resolutions" and divide the packs by app function.

If you use files for each device resolution in the same asset pack, there is an advantage that the number of packs will not easily reach the upper limit, so you can distribute them as packs for each function.
However, files of unused device resolutions will also be downloaded.

Choose the appropriate one based on how your app users use each function.

### Add Proguard workaround
In Flutter 3.29.2, adding asset packs and performing a release build (`flutter build appbundle`) causes the following error.

```bash
ERROR: Missing classes detected while running R8. Please add the missing classes or apply additional keep rules that are generated in C:\src\online_assets\build\app\outputs\mapping\release\missing_rules.txt.
ERROR: R8: Missing class com.google.android.gms.common.annotation.NoNullnessRewrite (referenced from: void com.google.android.play.core.ktx.zzn.onSuccess(java.lang.Object))

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:minifyReleaseWithR8'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.R8Task$R8Runnable
   > Compilation failed to complete
```

Since I do not know the appropriate countermeasure, I added `dontwarn` as follows to avoid this.

* `android/app/build.gradle.kts`

    ```android/app/build.gradle.kts
    android {
        // ...
        buildTypes {
            release {
                // ...
                proguardFiles(
                    "proguard-rules.pro"
                )
            }
        }
    }
    ```

* `android/app/proguard-rules.pro`

    ```android/app/proguard-rules.pro
    -dontwarn com.google.android.gms.common.annotation.NoNullnessRewrite
    ```

If you know the appropriate countermeasure, please send an issue or pull request.

That's all you need to use Play Asset Delivery on Android, the rest will be described in "Flutter-related implementation" later.

## On-Demand Resources (iOS)

### Setup Asset and On-Demand Resources Tags configuration

Open ios/Runner.xcworkspace in Xcode and add asset files to `Assets`.

To prevent path names from colliding between asset packs, the following rules are used to store the files.

- Drag and drop [folders (or files) in the assets folder of each asset pack on the Android side] to `Assets` on Xcode.

- Set the top folder (or file) to `On-Demand Resource Tags`: [asset pack name].

  The `On-Demand Resource Tags` in the parent folder are automatically inherited, so there is no need to set them in the inner folders.

  (Rather, it is preferable to avoid setting them individually, as this will cause forgetting to update them when moving to another asset pack.)

- Set “`Provides Namespace`: Enabled” for all folders so that they are on the same path as Android.

  This should be set for the inner folders as well as the parent folders.

Example:
- Android

    - Path: `android/install_time_sample_pack/src/main/assets/install_time_sample_pack/dog_image.png`

- iOS

   - Display path in Xcode: `install_time_sample_pack/dog_image` 

- Flutter call (details will be described later)

    ```.dart
    OnlineAssets.instance.streamFile(
      packName: 'install_time_sample_pack',
      relativePath: 'install_time_sample_pack/dog_image.png',
    )
    ```

The [On-Demand Resources Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/Tagging.html#//apple_ref/doc/uid/TP40015083-CH3-SW1) describes the types and settings of On-Demand Resources Tags.

- `Initial install tags`: Resources are downloaded with the app. However, since they can be deleted, it is necessary to check whether they exist before use.
- `Prefetch tag order`: Download starts after the app is installed.
- `Downloaded only on demand`: Downloaded when requested.

Distribute the tags according to the above page.

Since it is necessary to check whether the resources exist for all of the above, there was no mechanism in On-Demand Resources that ensures they exist like Android's install-time.

Therefore, in this sample app, in addition to the above three, pure iOS assets without On-Demand Resource Tags can also be used. (`IOSOnDemandResourceType.assetsWithoutTag`)

### Notes on iOS On-Demand Resources Specifications

#### Restrictions on iOS On-Demand Resources Tags

As described in the [documentation](https://developer.apple.com/help/app-store-connect/reference/on-demand-resources-size-limits/), there are restrictions on the iOS side as well.

- Size of reduced asset packs: 512 MB
- Total size of Initial install and prefetched tags: 4 GB
- App bundle size: 2 GB

Understand the restrictions on the Android side as well and think about how to divide the asset packs.

Basically, you will divide the asset packs considering the restrictions of "iOS asset pack size below 512MB" and "Android asset pack number below 100".

If it seems that you will reach the limit in the future, you will need to either "split the iOS asset packs" or "merge the Android asset packs" and control the asset pack names in the code.

```.dart
OnlineAssets.instance.streamFile(
  assetName: Platform.isAndroid ? 'install_time_sample_pack' : 'install_time_sample_pack_1',
  relativePath: 'dog_shetland_sheepdog_blue_merle.png',
)
```

That's all you need to use On-Demand Resources on iOS, the rest will be described in "Flutter-related implementation" later.

## Flutter-related Implementation

### Libraries Used

#### Pigeon

The communication between Flutter and each platform is implemented using a library called [Pigeon](https://pub.dev/packages/pigeon).

Referring to the [Example app](https://github.com/flutter/packages/tree/main/packages/pigeon/example/app) in the Pigeon library, I implemented it.

Pigeon has the following description.

> ## Stability of generated code
> 
> Pigeon is intended to replace direct use of method channels in the internal implementation of plugins and applications. Because the expected use of Pigeon is as an internal implementation detail, its development strongly favors improvements to generated code over consistency with previous generated code, so breaking changes in generated code are common.
> 
> As a result, using Pigeon-generated code in public APIs is strongly discouraged, as doing so will likely create situations where you are unable to update to a new version of Pigeon without causing breaking changes for your clients.

This means that you should not use the code generated by Pigeon (`lib/on_demand_resources.g.dart` or `lib/play_asset_delivery.g.dart`) with `@EventChannelApi()` or `@HostApi()` outside the library.

Therefore, when creating a library, it means that you should create a class (like the OnlineAssets class) that processes the results received from Pigeon or calls Pigeon.

Of course, you can also rewrite it to MethodChannel without using Pigeon.

#### Freezed

I used a library called [Freezed](https://pub.dev/packages/freezed) to make the data received from Pigeon easier to implement and process.

This is because there is a restriction that you cannot use imports other than Pigeon in the file declaring the data class to be exchanged with Pigeon (`pigeons/on_demand_resources.dart` or `pigeons/play_asset_delivery.dart`), and to make it easier to process the data class, you need to declare it in another file.

However, there is no big reason to use Freezed, so you can delete Freezed and implement it as a data class with `@immutable`.

#### RxDart

I used `@EventChannelApi()` of Pigeon to continuously send pack information from the platform to Flutter.

On the Flutter side, I wanted to keep the latest information of each pack and get this information as a Stream when subscribing with Widget, etc.

Normal Stream does not have a mechanism to get the latest information at the moment of subscription.

[RxDart](https://pub.dev/packages/rxdart) has a BehaviorSubject that evolves Stream, and by using this, you can get the latest value at the moment of subscribing to the Stream.

Since I used RxDart for that function, you can delete this library if you implement it with another logic.

#### Path

Used to extract the extension from a relative path or only the extension from a relative path as a value to be passed to an iOS method.

This library can be removed if implemented in a different logic for simple processing.

#### Video Player

I adopted it just to handle large file size assets in the sample, so of course, you can delete it.

## Handling of Asset Files

As you can see from the platform-side code, Android's install-time assets and all iOS assets are implemented to be copied as temporary files and then passed their paths.

The reason for this is that although I can obtain the contents of those files, I do not know how to obtain the file paths themselves.

Therefore, there is a problem that storage is doubled.

And to prioritize reading speed, I only check the file size to see if the already saved temporary file is the same content as the asset.
As a result, if the asset file is updated with an app update, the old file will be displayed unless the temporary file is deleted if the file size is exactly the same.
(However, it is unlikely that the content will be different with the exact same file size.)

If you know how to obtain these file paths, please send an issue or pull request.

I also considered passing the data as bytes, but I could not adopt it because it might consume a lot of memory if the file size is huge, such as videos.

If you know how to properly pass data between the platform and Flutter and display it with Widget, please send an issue or pull request.

## Execution thread

Android uses `CoroutineScope(Dispatchers.IO)` where file operations are performed.

However, iOS is not able to implement this in a thread-aware manner. (Todo)

If you are concerned about processing speed or have knowledge of threads or parallel processing, please submit a modified pull request.

It's no problem to avoid using [DispatchQueue](https://developer.apple.com/documentation/dispatch/dispatchqueue), change the sample app to iOS 13.0+ and use [Task](https://developer.apple.com/documentation/swift/task).

---

For other parts, I added many code comments, so please look at them to understand the structure!

If you have any questions, please write them in Discussions.
