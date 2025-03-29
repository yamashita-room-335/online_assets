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
abstract class PlayAssetDeliveryEventChannelApi {
  AndroidAssetPackStatePigeon streamAssetPackState();
}

@HostApi()
abstract class PlayAssetDeliveryHostApi {
  /// https://developer.android.com/reference/com/google/android/play/core/ktx/package-summary#requestpackstates
  @async
  AndroidAssetPackStatesPigeon requestPackStates({
    required List<String> packNames,
  });

  /// https://developer.android.com/reference/com/google/android/play/core/ktx/package-summary#requestfetch
  @async
  AndroidAssetPackStatesPigeon requestFetch({required List<String> packNames});

  /// https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackManager#showCellularDataConfirmation(android.app.Activity)
  bool showConfirmationDialog();

  /// Get the path to the copy of the Android install-time asset file.
  ///
  /// It is not possible to obtain the file path of the install-time asset file itself.
  /// Therefore, the path of the file copied to temporary directory is obtained.
  ///
  /// If the file is still in the temporary folder when this function is called and the file size is the same as the asset, file is reused.
  /// Therefore, if an asset is replaced by app update, etc., and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
  /// If you want to avoid this case, you call [deleteCopiedAssetFileOnInstallTimeAsset] function to delete cache on app update.
  /// However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
  ///
  /// Note that using this function uses twice as much device storage due to the assets of the system and the copied files.
  /// The copied files will be deleted by system when storage space is running low due to temporary files, but will be copied again on use.
  @async
  String? getCopiedAssetFilePathOnInstallTimeAsset({
    required String assetPackName,
    required String relativeAssetPath,
  });

  /// Delete the copied asset file.
  ///
  /// Returns true if the target file was successfully deleted.
  /// Also returns true if the target file does not yet exist.
  ///
  /// If the file is still in the temporary folder when [getCopiedAssetFilePathOnInstallTimeAsset] function is called and the file size is the same as the asset, file is reused.
  /// Therefore, if an asset is replaced by app update, and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
  /// If you want to avoid this case, you call delete function when your app update.
  /// However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
  @async
  bool deleteCopiedAssetFileOnInstallTimeAsset({
    required String assetPackName,
    required String relativeAssetPath,
  });

  @async
  bool deleteCopiedAssetFolderOnInstallTimeAsset({
    required String assetPackName,
  });

  @async
  bool deleteAllCopiedAssetFoldersOnInstallTimeAsset();

  @async
  String? getAssetFilePathOnDownloadAsset({
    required String assetPackName,
    required String relativeAssetPath,
  });
}

@FlutterApi()
abstract class PlayAssetDeliveryFlutterApi {
  /// https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackManager#showCellularDataConfirmation(android.app.Activity)
  void callbackConfirmationDialogResult(bool ok);
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
