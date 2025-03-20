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

  String? getAbsoluteAssetPath({
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
