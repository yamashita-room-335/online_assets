import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'on_demand_resources.g.dart';
import 'play_asset_delivery.g.dart';

part 'online_assets.freezed.dart';

/// Unified holder class
@freezed
sealed class OnlinePackHolder with _$OnlinePackHolder {
  const factory OnlinePackHolder.android({
    required Map<String, OnlinePack> packMap,
    required int androidTotalBytes,
  }) = AndroidPackHolder;

  const factory OnlinePackHolder.iOS({
    required Map<String, OnlinePack> packMap,
  }) = IOSPackHolder;

  static AndroidPackHolder fromAndroid(AndroidAssetPackStatesPigeon pigeon) {
    return AndroidPackHolder(
      packMap: pigeon.packStates.map(
        (key, value) => MapEntry(key, OnlinePack.fromAndroid(value)),
      ),
      androidTotalBytes: pigeon.totalBytes,
    );
  }

  static IOSPackHolder fromIOS(IOSOnDemandResourcesPigeon pigeon) {
    return IOSPackHolder(
      packMap: pigeon.resourceMap.map(
        (key, value) => MapEntry(key, OnlinePack.fromIOS(value)),
      ),
    );
  }
}

/// Unified pack class
@freezed
sealed class OnlinePack with _$OnlinePack {
  const factory OnlinePack.android({
    required String name,
    required OnlineAssetStatus status,
    required bool hasError,
    required double progress,
    // Android-specific information
    required int androidBytesDownloaded,
    required AndroidAssetPackErrorCode androidErrorCode,
    required AndroidAssetPackStatus androidStatus,
    required int androidTotalBytesToDownload,
    required int androidTransferProgressPercentage,
  }) = AndroidPack;

  const factory OnlinePack.iOS({
    required String name,
    required OnlineAssetStatus status,
    required bool hasError,
    required double progress,
    // iOS-specific information
    required IOSNSError? iOSError,
    required IOSProgress iOSProgress,
    required bool iOSCondition,
    required double iOSLoadingPriority,
  }) = IOSPack;

  static AndroidPack fromAndroid(AndroidAssetPackStatePigeon pigeon) {
    return AndroidPack(
      name: pigeon.name,
      status: switch (pigeon.status) {
        AndroidAssetPackStatus.canceled => OnlineAssetStatus.canceled,
        AndroidAssetPackStatus.completed => OnlineAssetStatus.completed,
        AndroidAssetPackStatus.downloading => OnlineAssetStatus.downloading,
        AndroidAssetPackStatus.failed => OnlineAssetStatus.failed,
        AndroidAssetPackStatus.notInstalled => OnlineAssetStatus.notInstalled,
        AndroidAssetPackStatus.pending => OnlineAssetStatus.pending,
        AndroidAssetPackStatus.requiresUserConfirmation =>
          OnlineAssetStatus.requiresUserConfirmationOnAndroid,
        AndroidAssetPackStatus.transferring => OnlineAssetStatus.downloading,
        AndroidAssetPackStatus.unknown => OnlineAssetStatus.unknown,
        AndroidAssetPackStatus.waitingForWifi =>
          OnlineAssetStatus.waitingForWifiOnAndroid,
      },
      hasError: pigeon.errorCode != AndroidAssetPackErrorCode.noError,
      progress: pigeon.transferProgressPercentage / 100,
      androidBytesDownloaded: pigeon.bytesDownloaded,
      androidErrorCode: pigeon.errorCode,
      androidStatus: pigeon.status,
      androidTotalBytesToDownload: pigeon.totalBytesToDownload,
      androidTransferProgressPercentage: pigeon.transferProgressPercentage,
    );
  }

  static IOSPack fromIOS(IOSOnDemandResourcePigeon pigeon) {
    final OnlineAssetStatus status;
    if (pigeon.error != null) {
      status = OnlineAssetStatus.failed;
    } else if (pigeon.progress.isFinished) {
      status = OnlineAssetStatus.completed;
    } else if (pigeon.progress.isCancelled) {
      status = OnlineAssetStatus.canceled;
    } else if (pigeon.progress.isPaused) {
      status = OnlineAssetStatus.pending;
    } else if (pigeon.progress.fractionCompleted > 0) {
      status = OnlineAssetStatus.downloading;
    } else {
      status = OnlineAssetStatus.notInstalled;
    }

    return IOSPack(
      name: pigeon.tag,
      status: status,
      hasError: pigeon.error != null,
      progress: pigeon.progress.fractionCompleted,
      iOSError:
          pigeon.error != null ? IOSNSError.fromPigeon(pigeon.error!) : null,
      iOSProgress: IOSProgress.fromPigeon(pigeon.progress),
      iOSCondition: pigeon.condition,
      iOSLoadingPriority: pigeon.loadingPriority,
    );
  }
}

/// Pack Status
enum OnlineAssetStatus {
  notInstalled,
  pending,
  downloading,
  completed,
  failed,
  canceled,
  unknown,
  // Android Only
  requiresUserConfirmationOnAndroid,
  waitingForWifiOnAndroid,
}

/// [IOSNSErrorPigeon]
@freezed
abstract class IOSNSError with _$IOSNSError {
  const factory IOSNSError({
    required int code,
    required String domain,
    required String localizedDescription,
  }) = _IOSNSError;

  factory IOSNSError.fromPigeon(IOSNSErrorPigeon pigeon) {
    return IOSNSError(
      code: pigeon.code,
      domain: pigeon.domain,
      localizedDescription: pigeon.localizedDescription,
    );
  }
}

/// [IOSProgressPigeon]
@freezed
abstract class IOSProgress with _$IOSProgress {
  const factory IOSProgress({
    required bool isCancelled,
    required bool isPaused,
    required double fractionCompleted,
    required bool isFinished,
  }) = _IOSProgress;

  factory IOSProgress.fromPigeon(IOSProgressPigeon pigeon) {
    return IOSProgress(
      isCancelled: pigeon.isCancelled,
      isPaused: pigeon.isPaused,
      fractionCompleted: pigeon.fractionCompleted,
      isFinished: pigeon.isFinished,
    );
  }
}

/// Pack-related settings
@freezed
abstract class OnlineAssetPackSettings with _$OnlineAssetPackSettings {
  const factory OnlineAssetPackSettings({
    required String packName,
    required AndroidAssetPackDeliveryMode androidAssetPackDeliveryMode,
    required IOSOnDemandResourceType iosOnDemandResourceType,
  }) = _OnlineAssetPackSettings;
}

/// https://developer.android.com/guide/playcore/asset-delivery#delivery-modes
enum AndroidAssetPackDeliveryMode { installTime, fastFollow, onDemand }

/// https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/Tagging.html
///
/// See "Prefetching Tags"
enum IOSOnDemandResourceType {
  // Assets for which the "On-Demand Resources Tag" was not set
  assetsWithoutTag,
  // This asset can be deleted, so the asset status should be checked.
  initialInstall,
  prefetch,
  onDemand,
}

/// Class for unified handling of Play Asset Delivery (Android) and On-Demand Resources (iOS)
///
/// Lazy generation singleton prevents unused Streams from being created.
class OnlineAssets {
  static OnlineAssets? _instance;

  static OnlineAssets get instance {
    _instance ??= OnlineAssets._();
    return _instance!;
  }

  OnlineAssets._() {
    if (Platform.isAndroid) {
      streamAssetPackState().listen((androidAssetPackState) {
        final androidPack = OnlinePack.fromAndroid(androidAssetPackState);
        switch (androidPack.androidErrorCode) {
          case AndroidAssetPackErrorCode.noError:
            log('AndroidPack: $androidPack');
            break;
          case AndroidAssetPackErrorCode.networkError ||
              AndroidAssetPackErrorCode.insufficientStorage:
            log('Asset Pack Error: $androidPack');
            break;
          default:
            log('Unexpected Asset Pack Error: $androidPack');
            break;
        }
        onlinePackSubject.add(androidPack);
      }, onError: (e) => log(e.toString()));
    } else if (Platform.isIOS) {
      streamOnDemandResource().listen((iosOnDemandResource) {
        final iOSPack = OnlinePack.fromIOS(iosOnDemandResource);
        log('iOSPack: $iOSPack');
        if (iOSPack.hasError) {
          log('Unknown Asset Pack Error: $iOSPack');
        }
        // https://developer.apple.com/documentation/foundation/1448136-nserror_codes
        switch (iOSPack.iOSError?.code) {
          case null:
            log('iOSPack: $iOSPack');
            break;
          case 3072 || // Cancellation
              5121 || // NSCloudSharingQuotaExceededError
              640 || // NSFileWriteOutOfSpaceError
              -1005 || // NSURLErrorNetworkConnectionLost
              -1009 // NSURLErrorNotConnectedToInternet
              :
            log('Asset Pack Error: $iOSPack');
            break;
          default:
            log('Unexpected Asset Pack Error: $iOSPack');
            break;
        }
        onlinePackSubject.add(iOSPack);
      }, onError: (e) => log(e.toString()));
    }
  }

  bool _isInitialized = false;

  // https://developer.android.com/guide/playcore/asset-delivery/integrate-java#required-confirmations
  bool confirmationDialogShownOnAndroid = false;

  final PlayAssetDeliveryHostApiMethods androidApi =
      PlayAssetDeliveryHostApiMethods();

  final OnDemandResourcesHostApiMethods iosApi =
      OnDemandResourcesHostApiMethods();

  /// Settings for each Pack
  ///
  /// The settings are used to determine whether the pack is install-time or download on Android.
  final Map<String, OnlineAssetPackSettings> packSettingsMap = {};

  /// Subject that receives Platform's EventChannelApi
  ///
  /// Since each AssetPack is notified through the same Subject, it is sorted by packSubjectMap.
  final PublishSubject<OnlinePack> onlinePackSubject =
      PublishSubject<OnlinePack>();

  /// Subject for each Pack
  ///
  /// Holds the Subject with the AssetName registered by registerStream() as the key.
  /// BehaviorSubject is used to enable the last state to be retrieved.
  /// Since the install-time asset pack cannot obtain the pack status in Android.
  final Map<String, BehaviorSubject<OnlinePack>> onlinePackSubjectMap = {};

  /// Initialize
  ///
  /// [assetPackSettingsList] are the asset pack settings.
  /// The settings are used to determine whether the pack is install-time or download on Android.
  Future<void> init({
    required List<OnlineAssetPackSettings> assetPackSettingsList,
  }) async {
    if (_isInitialized) {
      throw Exception("Already initialized.");
    }
    if (!(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('Platform not supported');
    }

    try {
      for (final settings in assetPackSettingsList) {
        packSettingsMap[settings.packName] = settings;

        // Generate only the Subject of the online assets.
        if (Platform.isAndroid) {
          if (settings.androidAssetPackDeliveryMode !=
              AndroidAssetPackDeliveryMode.installTime) {
            onlinePackSubjectMap[settings.packName] =
                BehaviorSubject<OnlinePack>();
          }
        } else {
          if (settings.iosOnDemandResourceType !=
              IOSOnDemandResourceType.assetsWithoutTag) {
            onlinePackSubjectMap[settings.packName] =
                BehaviorSubject<OnlinePack>();
          }
        }
      }

      onlinePackSubject.listen((pack) {
        if (onlinePackSubjectMap.containsKey(pack.name)) {
          onlinePackSubjectMap[pack.name]!.add(pack);
        } else {
          // An unexpected asset pack name is being downloaded.
          log('Unknown pack name: ${pack.name}');
        }
      }, onError: (e) => log(e.toString()));

      final OnlinePackHolder packHolder;
      if (Platform.isAndroid) {
        packHolder = OnlinePackHolder.fromAndroid(
          await androidApi.requestPackStates(
            packNames: onlinePackSubjectMap.keys.toList(),
          ),
        );
      } else {
        packHolder = OnlinePackHolder.fromIOS(
          await iosApi.requestNSBundleResourceRequests(
            tags: onlinePackSubjectMap.keys.toList(),
          ),
        );
      }

      log('OnlinePackHolder: $packHolder');

      for (final pack in packHolder.packMap.values) {
        if (onlinePackSubjectMap.containsKey(pack.name)) {
          final packSubject = onlinePackSubjectMap[pack.name]!;
          // Since it seems to be possible to retrieve all the values with listen(),
          // we only add when there is no value, in case we miss a value.
          if (!packSubject.hasValue) {
            packSubject.add(pack);
          }
        } else {
          // An unexpected asset pack name is being downloaded.
          log('Unknown pack name: ${pack.name}');
        }
      }

      _isInitialized = true;
    } catch (e) {
      log(e.toString());
    }
  }

  /// Start fetch assets
  Future<void> fetch(List<String> packNames) async {
    for (final packName in packNames) {
      if (!onlinePackSubjectMap.containsKey(packName)) {
        if (packSettingsMap.containsKey(packName)) {
          log(
            '[$packName] pack set ${Platform.isAndroid ? 'androidAssetPackDeliveryMode: .installTime' : 'iosOnDemandResourceType: .assetsWithoutTag'}. There is no need to call fetch because it already exists in device.',
          );
          packNames.remove(packName);
        } else {
          throw Exception(
            "Please register [$packName] settings in OnlineAssets.instance.init().",
          );
        }
      }
    }

    try {
      final OnlinePackHolder packHolder;
      if (Platform.isAndroid) {
        packHolder = OnlinePackHolder.fromAndroid(
          await androidApi.requestFetch(packNames: packNames),
        );
      } else {
        packHolder = OnlinePackHolder.fromIOS(
          await iosApi.beginAccessingResources(tags: packNames),
        );
      }

      for (final pack in packHolder.packMap.values) {
        if (onlinePackSubjectMap.containsKey(pack.name)) {
          final packSubject = onlinePackSubjectMap[pack.name]!;
          // Since it seems to be possible to retrieve all the values with listen(),
          // we only add when there is no value, in case we miss a value.
          if (!packSubject.hasValue) {
            packSubject.add(pack);
          }
        } else {
          // An unexpected asset pack name is being downloaded.
          log('Unknown pack name: ${pack.name}');
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> showConfirmationDialog() async {
    if (Platform.isAndroid) {
      if (confirmationDialogShownOnAndroid) {
        return false;
      }
      confirmationDialogShownOnAndroid = true;
      return await androidApi.showConfirmationDialog();
    }
    return false;
  }

  /// Obtain the file of the target asset
  ///
  /// If it is not obtained, null is returned, so the caller must wait for the download to complete in the Stream.
  Future<File?> getFile({
    required String packName,
    required String relativePath,
  }) async {
    final packSettings = packSettingsMap[packName];
    if (packSettings == null) {
      throw Exception(
        "Please register [$packName] settings in OnlineAssets.instance.init().",
      );
    }

    try {
      final String? path;
      if (Platform.isAndroid) {
        if (packSettings.androidAssetPackDeliveryMode ==
            AndroidAssetPackDeliveryMode.installTime) {
          path = await androidApi.getCopiedAssetFilePathOnInstallTimeAsset(
            assetPackName: packName,
            relativeAssetPath: relativePath,
          );
        } else {
          path = await androidApi.getAssetFilePathOnDownloadAsset(
            assetPackName: packName,
            relativeAssetPath: relativePath,
          );
        }
      } else {
        if (packSettings.iosOnDemandResourceType ==
            IOSOnDemandResourceType.assetsWithoutTag) {
          path = await iosApi.getCopiedAssetFilePath(
            tag: null,
            relativeAssetPathWithTagNamespace:
                '$packName${Platform.pathSeparator}$relativePath',
          );
        } else {
          path = await iosApi.getCopiedAssetFilePath(
            tag: packName,
            relativeAssetPathWithTagNamespace:
                '$packName${Platform.pathSeparator}$relativePath',
          );
        }
      }

      if (path == null) {
        log(
          "Failed to get file path. assetName: $packName, relativePath: $relativePath",
        );
        return null;
      }

      return File(path);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// Delete the copied asset file on Android Install-Time asset and iOS asset.
  ///
  /// Returns true if the target file or folder was successfully deleted.
  /// Also returns true if the target file or folder does not yet exist.
  ///
  /// If only [packName] is specified, the target pack folder is deleted.
  /// Call this function if you are replacing assets and the file size is the same as the file before the replacement and want to be sure to update the files.
  Future<bool?> deleteCopiedAssetFile({
    String? packName,
    String? relativeAssetPath,
  }) async {
    try {
      if (Platform.isAndroid) {
        return await androidApi.deleteCopiedAssetFileOnInstallTimeAsset(
          assetPackName: packName,
          relativeAssetPath: relativeAssetPath,
        );
      } else {
        // Todo Implement iOS
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

  /// Stream files and information on target assets
  ///
  /// Starts the download and returns a Stream including the file after the download is complete.
  ///
  /// If [fetchOnNotDownloading] is [true], [fetch] is called when the status is "Not Installed", "Canceled", "Failed".
  /// If you want to use a different logic to manage whether fetch is performed or not, set it to [false].
  Stream<(File?, OnlinePack)> streamFile({
    required String packName,
    required String relativePath,
    bool fetchOnNotDownloading = true,
  }) async* {
    try {
      if (Platform.isAndroid) {
        if (packSettingsMap[packName]!.androidAssetPackDeliveryMode ==
            AndroidAssetPackDeliveryMode.installTime) {
          // If the asset is an install-time asset, it is already exist.
          final file = await getFile(
            packName: packName,
            relativePath: relativePath,
          );
          yield (file, onlinePackSubjectMap[packName]!.value);
          return;
        }
      } else {
        if (packSettingsMap[packName]!.iosOnDemandResourceType ==
            IOSOnDemandResourceType.assetsWithoutTag) {
          // If the asset is an standard asset, it is already exist.
          final file = await getFile(
            packName: packName,
            relativePath: relativePath,
          );
          yield (file, onlinePackSubjectMap[packName]!.value);
          return;
        }
      }

      final packSubject = onlinePackSubjectMap[packName];
      if (packSubject == null) {
        throw Exception("Please register [$packName] stream.");
      }

      if (fetchOnNotDownloading) {
        switch (packSubject.valueOrNull?.status) {
          case OnlineAssetStatus.notInstalled ||
              OnlineAssetStatus.canceled ||
              OnlineAssetStatus.failed:
            fetch([packName]);
            break;
          default:
            break;
        }
      }

      // Return null until the download is complete, and return the file if the download is complete.
      await for (final resource in packSubject) {
        if (resource.status == OnlineAssetStatus.completed) {
          final file = await getFile(
            packName: packName,
            relativePath: relativePath,
          );
          yield (file, resource);
          // Do not return in consideration of deletion
        } else {
          yield (null, resource);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
