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
        AndroidAssetPackStatus.notInstalled => OnlineAssetStatus.unknown,
        AndroidAssetPackStatus.pending => OnlineAssetStatus.pending,
        AndroidAssetPackStatus.requiresUserConfirmation =>
          OnlineAssetStatus.requiresUserConfirmation,
        AndroidAssetPackStatus.transferring => OnlineAssetStatus.unknown,
        AndroidAssetPackStatus.unknown => OnlineAssetStatus.unknown,
        AndroidAssetPackStatus.waitingForWifi => OnlineAssetStatus.unknown,
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
      status = OnlineAssetStatus.pending;
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
  pending,
  //Todo Display of a confirmation dialog box when pressed.
  requiresUserConfirmation,
  downloading,
  completed,
  failed,
  canceled,
  unknown,
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
    required bool isInstallTimeAssetPackOnAndroid,
  }) = _OnlineAssetPackSettings;
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
        platformSubject.add(androidPack);
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
        platformSubject.add(iOSPack);
      }, onError: (e) => log(e.toString()));
    }
  }

  bool _isInitialized = false;

  final PlayAssetDeliveryHostApiMethods androidApi =
      PlayAssetDeliveryHostApiMethods();

  final OnDemandResourcesHostApiMethods iosApi =
      OnDemandResourcesHostApiMethods();

  /// Settings for each Pack
  ///
  /// The settings are used to determine whether the pack is install-time or download on Android.
  final Map<String, OnlineAssetPackSettings> packSettingsMap = {};

  /// Subject that receives Android's EventChannelApi
  ///
  /// Since each AssetPack is notified through the same Subject, it is sorted by packSubjectMap.
  final PublishSubject<OnlinePack> platformSubject =
      PublishSubject<OnlinePack>();

  /// Subject for each Pack
  ///
  /// Holds the Subject with the AssetName registered by registerStream() as the key.
  /// BehaviorSubject is used to enable the last state to be retrieved.
  /// Since the install-time asset pack cannot obtain the pack status in Android.
  final Map<String, BehaviorSubject<OnlinePack>> packSubjectMap = {};

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
      final requestPackNames = <String>[];
      for (final settings in assetPackSettingsList) {
        packSettingsMap[settings.packName] = settings;

        // Generate only the Subject of the target tag.
        if (Platform.isAndroid && settings.isInstallTimeAssetPackOnAndroid) {
          // Create completed asset subject because install-time asset status cannot be obtained on Android.
          packSubjectMap[settings.packName] =
              BehaviorSubject<OnlinePack>()..add(
                OnlinePack.android(
                  name: settings.packName,
                  status: OnlineAssetStatus.completed,
                  hasError: false,
                  progress: 1,
                  androidBytesDownloaded: 0,
                  androidErrorCode: AndroidAssetPackErrorCode.noError,
                  androidStatus: AndroidAssetPackStatus.completed,
                  androidTotalBytesToDownload: 0,
                  androidTransferProgressPercentage: 100,
                ),
              );
        } else {
          requestPackNames.add(settings.packName);
          packSubjectMap[settings.packName] = BehaviorSubject<OnlinePack>();
        }
      }

      platformSubject.listen((pack) {
        if (packSubjectMap.containsKey(pack.name)) {
          packSubjectMap[pack.name]!.add(pack);
        } else {
          // An unexpected asset pack name is being downloaded.
          log('Unknown pack name: ${pack.name}');
        }
      }, onError: (e) => log(e.toString()));

      final OnlinePackHolder packHolder;
      if (Platform.isAndroid) {
        packHolder = OnlinePackHolder.fromAndroid(
          await androidApi.requestPackStates(packNames: requestPackNames),
        );
      } else {
        packHolder = OnlinePackHolder.fromIOS(
          await iosApi.requestNSBundleResourceRequests(tags: requestPackNames),
        );
      }

      log('OnlinePackHolder: $packHolder');

      for (final pack in packHolder.packMap.values) {
        if (packSubjectMap.containsKey(pack.name)) {
          final packSubject = packSubjectMap[pack.name]!;
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
  Future<void> fetch(List<String> assetNames) async {
    try {
      if (Platform.isAndroid) {
        assetNames.removeWhere(
          (assetName) =>
              packSettingsMap[assetName]!.isInstallTimeAssetPackOnAndroid,
        );
      }

      final OnlinePackHolder packHolder;
      if (Platform.isAndroid) {
        packHolder = OnlinePackHolder.fromAndroid(
          await androidApi.requestFetch(packNames: assetNames),
        );
      } else {
        packHolder = OnlinePackHolder.fromIOS(
          await iosApi.beginAccessingResources(tags: assetNames),
        );
      }

      for (final pack in packHolder.packMap.values) {
        if (packSubjectMap.containsKey(pack.name)) {
          final packSubject = packSubjectMap[pack.name]!;
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

  /// Obtain the file of the target asset
  ///
  /// If it is not obtained, null is returned, so the caller must wait for the download to complete in the Stream.
  Future<File?> getFile({
    required String assetName,
    required String relativePath,
  }) async {
    try {
      final String? path;
      if (Platform.isAndroid) {
        if (packSettingsMap[assetName]!.isInstallTimeAssetPackOnAndroid) {
          path = await androidApi.getCopiedAssetFilePathOnInstallTimeAsset(
            assetPackName: assetName,
            relativeAssetPath: relativePath,
          );
        } else {
          path = await androidApi.getAssetFilePathOnDownloadAsset(
            assetPackName: assetName,
            relativeAssetPath: relativePath,
          );
        }
      } else {
        path = await iosApi.getCopiedAssetFilePath(
          tag: assetName,
          relativeAssetPathWithTagNamespace:
              '$assetName${Platform.pathSeparator}$relativePath',
        );
      }

      if (path == null) {
        log(
          "Failed to get file path. assetName: $assetName, relativePath: $relativePath",
        );
        return null;
      }

      return File(path);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// Stream files and information on target assets
  ///
  /// Starts the download and returns a Stream including the file after the download is complete.
  Stream<(File?, OnlinePack)> streamFile({
    required String assetName,
    required String relativePath,
  }) async* {
    try {
      if (Platform.isAndroid &&
          packSettingsMap[assetName]?.isInstallTimeAssetPackOnAndroid == true) {
        // If the asset is an install-time asset, it is already downloaded.
        final file = await getFile(
          assetName: assetName,
          relativePath: relativePath,
        );
        yield (file, packSubjectMap[assetName]!.value);
        return;
      }

      // Called once without await to prevent download from not starting
      fetch([assetName]);

      final packSubject = packSubjectMap[assetName];
      if (packSubject == null) {
        throw Exception("Please register [$assetName] stream.");
      }

      // Return null until the download is complete, and return the file if the download is complete.
      await for (final resource in packSubject) {
        if (resource.status == OnlineAssetStatus.completed) {
          final file = await getFile(
            assetName: assetName,
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
