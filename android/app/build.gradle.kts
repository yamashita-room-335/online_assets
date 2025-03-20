plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kourokuroom.online_assets"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    // https://developer.android.com/guide/playcore/asset-delivery/integrate-java#build_for_kotlin_and_java
    assetPacks += listOf(":install_time_sample_pack", ":fast_follow_sample_pack", ":on_demand_sample_pack")

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kourokuroom.online_assets"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            proguardFiles(
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // https://developer.android.com/guide/playcore/asset-delivery/integrate-java#kts
    implementation("com.google.android.play:asset-delivery:2.3.0")
    implementation("com.google.android.play:asset-delivery-ktx:2.3.0")
}