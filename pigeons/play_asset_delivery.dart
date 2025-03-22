import 'package:pigeon/pigeon.dart';

// Since Pigeon does not support other imports, conversion is done in a separate class file.

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/play_asset_delivery.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/kourokuroom/online_assets/PlayAssetDelivery.g.kt',
    kotlinOptions: KotlinOptions(),
  ),
)
@EventChannelApi()
abstract class PlayAssetDeliveryEventChannelMethods {
  AndroidAssetPackStatePigeon streamAssetPackState();
}

@HostApi()
abstract class PlayAssetDeliveryHostApiMethods {
  @async
  AndroidAssetPackStatesPigeon requestPackStates({
    required List<String> packNames,
  });

  @async
  AndroidAssetPackStatesPigeon requestFetch({required List<String> packNames});

  /// It is not possible to obtain the file path of the asset file itself.
  /// Therefore, the path of the copied file as a temporary file is obtained.
  /// Note that using this function uses twice as much device storage due to the asset and the copied files.
  ///
  /// If this function is called and the file has already been copied and the file size is the same, the overwrite copy process is not performed.
  ///
  /// If you are replacing asset files when updating your app and the file size is the same as the file before the replacement, you will need to call [getAssetFilePathOnDownloadAsset] function.
  @async
  String? getCopiedAssetFilePathOnInstallTimeAsset({
    required String assetPackName,
    required String relativeAssetPath,
  });

  /// Delete the copied asset file.
  ///
  /// Returns true if the target file or folder was successfully deleted.
  /// Also returns true if the target file or folder does not yet exist.
  ///
  /// If [assetPackName] = null, all install-time pack folder is deleted.
  /// If [relativeAssetPath] = null, [assetPackName]'s install-time pack folder is deleted.
  ///
  /// Call this function if you are replacing assets and the file size is the same as the file before the replacement and want to be sure to update the files.
  @async
  bool deleteCopiedAssetFileOnInstallTimeAsset({
    String? assetPackName,
    String? relativeAssetPath,
  });

  @async
  String? getAssetFilePathOnDownloadAsset({
    required String assetPackName,
    required String relativeAssetPath,
  });
}

/// https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackStates
class AndroidAssetPackStatesPigeon {
  AndroidAssetPackStatesPigeon({
    required this.packStates,
    required this.totalBytes,
  });

  /// Map from a pack's name to its state
  Map<String, AndroidAssetPackStatePigeon> packStates;
  int totalBytes;
}

/// https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackState
class AndroidAssetPackStatePigeon {
  AndroidAssetPackStatePigeon({
    required this.bytesDownloaded,
    required this.errorCode,
    required this.name,
    required this.status,
    required this.totalBytesToDownload,
    required this.transferProgressPercentage,
  });

  int bytesDownloaded;
  AndroidAssetPackErrorCode errorCode;
  String name;
  AndroidAssetPackStatus status;
  int totalBytesToDownload;
  int transferProgressPercentage;
}

/// https://developer.android.com/reference/com/google/android/play/core/assetpacks/model/AssetPackErrorCode
enum AndroidAssetPackErrorCode {
  noError,
  appUnavailable,
  packUnavailable,
  invalidRequest,
  downloadNotFound,
  apiNotAvailable,
  networkError,
  accessDenied,
  insufficientStorage,
  appNotOwned,
  confirmationNotRequired,
  unrecognizedInstallation,
  internalError,
  unknown,
}

/// https://developer.android.com/reference/com/google/android/play/core/assetpacks/model/AssetPackStatus
enum AndroidAssetPackStatus {
  unknown,
  notInstalled,
  pending,
  waitingForWifi,
  requiresUserConfirmation,
  downloading,
  transferring,
  completed,
  failed,
  canceled,
}
