import 'package:flutter_test/flutter_test.dart';
import 'package:online_assets/on_demand_resources.g.dart';
import 'package:online_assets/online_assets.dart';
import 'package:online_assets/play_asset_delivery.g.dart';

AndroidAssetPackStatePigeon _androidPigeon({
  String name = 'pack',
  AndroidAssetPackStatus status = AndroidAssetPackStatus.downloading,
  AndroidAssetPackErrorCode errorCode = AndroidAssetPackErrorCode.noError,
  int bytesDownloaded = 50,
  int totalBytesToDownload = 100,
  int transferProgressPercentage = 50,
}) {
  return AndroidAssetPackStatePigeon(
    name: name,
    status: status,
    errorCode: errorCode,
    bytesDownloaded: bytesDownloaded,
    totalBytesToDownload: totalBytesToDownload,
    transferProgressPercentage: transferProgressPercentage,
  );
}

IOSOnDemandResourcePigeon _iosPigeon({
  String tag = 'pack',
  IOSNSErrorPigeon? error,
  bool isCancelled = false,
  bool isPaused = false,
  double fractionCompleted = 0,
  bool isFinished = false,
}) {
  return IOSOnDemandResourcePigeon(
    tag: tag,
    error: error,
    condition: false,
    loadingPriority: 0.5,
    progress: IOSProgressPigeon(
      isCancelled: isCancelled,
      isPaused: isPaused,
      fractionCompleted: fractionCompleted,
      isFinished: isFinished,
    ),
  );
}

void main() {
  group('OnlinePack.fromAndroid', () {
    test('maps every AndroidAssetPackStatus to an OnlineAssetStatus', () {
      const expected = {
        AndroidAssetPackStatus.canceled: OnlineAssetStatus.canceled,
        AndroidAssetPackStatus.completed: OnlineAssetStatus.completed,
        AndroidAssetPackStatus.downloading: OnlineAssetStatus.downloading,
        AndroidAssetPackStatus.failed: OnlineAssetStatus.failed,
        AndroidAssetPackStatus.notInstalled: OnlineAssetStatus.notInstalled,
        AndroidAssetPackStatus.pending: OnlineAssetStatus.pending,
        AndroidAssetPackStatus.requiresUserConfirmation:
            OnlineAssetStatus.requiresUserConfirmationOnAndroid,
        AndroidAssetPackStatus.transferring: OnlineAssetStatus.downloading,
        AndroidAssetPackStatus.unknown: OnlineAssetStatus.unknown,
        AndroidAssetPackStatus.waitingForWifi:
            OnlineAssetStatus.waitingForWifiOnAndroid,
      };
      expect(expected.keys, containsAll(AndroidAssetPackStatus.values));

      for (final MapEntry(key: androidStatus, value: status)
          in expected.entries) {
        final pack = OnlinePack.fromAndroid(
          _androidPigeon(status: androidStatus),
        );
        expect(pack.status, status, reason: '$androidStatus');
        expect(pack.androidStatus, androidStatus);
      }
    });

    test('copies the pigeon fields and converts the percentage', () {
      final pack = OnlinePack.fromAndroid(
        _androidPigeon(
          name: 'on_demand_sample_pack',
          bytesDownloaded: 30,
          totalBytesToDownload: 120,
          transferProgressPercentage: 25,
        ),
      );

      expect(pack.name, 'on_demand_sample_pack');
      expect(pack.progress, 0.25);
      expect(pack.hasError, isFalse);
      expect(pack.androidBytesDownloaded, 30);
      expect(pack.androidTotalBytesToDownload, 120);
      expect(pack.androidTransferProgressPercentage, 25);
    });

    test('sets hasError when the error code is not noError', () {
      final pack = OnlinePack.fromAndroid(
        _androidPigeon(
          status: AndroidAssetPackStatus.failed,
          errorCode: AndroidAssetPackErrorCode.networkError,
        ),
      );

      expect(pack.hasError, isTrue);
      expect(pack.androidErrorCode, AndroidAssetPackErrorCode.networkError);
    });
  });

  group('OnlinePack.fromIOS', () {
    test('an error takes precedence over the progress state', () {
      final pack = OnlinePack.fromIOS(
        _iosPigeon(
          error: IOSNSErrorPigeon(
            code: -1009,
            domain: 'NSURLErrorDomain',
            localizedDescription: 'offline',
          ),
          isFinished: true,
          fractionCompleted: 1,
        ),
      );

      expect(pack.status, OnlineAssetStatus.failed);
      expect(pack.hasError, isTrue);
      expect(
        pack.iOSError,
        const IOSNSError(
          code: -1009,
          domain: 'NSURLErrorDomain',
          localizedDescription: 'offline',
        ),
      );
    });

    test('derives the status from the progress flags', () {
      expect(
        OnlinePack.fromIOS(
          _iosPigeon(isFinished: true, fractionCompleted: 1),
        ).status,
        OnlineAssetStatus.completed,
      );
      expect(
        OnlinePack.fromIOS(_iosPigeon(isCancelled: true)).status,
        OnlineAssetStatus.canceled,
      );
      expect(
        OnlinePack.fromIOS(_iosPigeon(isPaused: true)).status,
        OnlineAssetStatus.pending,
      );
      expect(
        OnlinePack.fromIOS(_iosPigeon(fractionCompleted: 0.4)).status,
        OnlineAssetStatus.downloading,
      );
      expect(
        OnlinePack.fromIOS(_iosPigeon()).status,
        OnlineAssetStatus.notInstalled,
      );
    });

    test('copies the pigeon fields', () {
      final pack = OnlinePack.fromIOS(
        _iosPigeon(tag: 'on_demand_sample_pack', fractionCompleted: 0.4),
      );

      expect(pack.name, 'on_demand_sample_pack');
      expect(pack.progress, 0.4);
      expect(pack.hasError, isFalse);
      expect(pack.iOSError, isNull);
      expect(pack.iOSCondition, isFalse);
      expect(pack.iOSLoadingPriority, 0.5);
      expect(
        pack.iOSProgress,
        const IOSProgress(
          isCancelled: false,
          isPaused: false,
          fractionCompleted: 0.4,
          isFinished: false,
        ),
      );
    });
  });

  group('OnlinePackHolder', () {
    test('fromAndroid converts every pack state', () {
      final holder = OnlinePackHolder.fromAndroid(
        AndroidAssetPackStatesPigeon(
          packStates: {
            'a': _androidPigeon(name: 'a'),
            'b': _androidPigeon(
              name: 'b',
              status: AndroidAssetPackStatus.completed,
            ),
          },
          totalBytes: 200,
        ),
      );

      expect(holder.androidTotalBytes, 200);
      expect(holder.packMap.keys, ['a', 'b']);
      expect(holder.packMap['b']!.status, OnlineAssetStatus.completed);
    });

    test('fromIOS converts every resource', () {
      final holder = OnlinePackHolder.fromIOS(
        IOSOnDemandResourcesPigeon(
          resourceMap: {
            'a': _iosPigeon(tag: 'a'),
            'b': _iosPigeon(tag: 'b', isFinished: true, fractionCompleted: 1),
          },
        ),
      );

      expect(holder.packMap.keys, ['a', 'b']);
      expect(holder.packMap['b']!.status, OnlineAssetStatus.completed);
    });
  });

  group('OnlineAssetStatus', () {
    test('priority levels are unique', () {
      final levels = OnlineAssetStatus.values.map((s) => s.priorityLevel);
      expect(levels.toSet(), hasLength(OnlineAssetStatus.values.length));
    });
  });

  // OnlineTotalPack.update branches on dart:io Platform, so on a test host
  // (macOS / Linux) only the iOS branch can run.
  group('OnlineTotalPack.update (iOS branch)', () {
    const empty = OnlineTotalPack(
      packMap: {},
      totalStatus: OnlineAssetStatus.notInstalled,
      progress: 0,
    );

    test('averages the progress and keeps the highest-priority status', () {
      final total = empty.update({
        'a': OnlinePack.fromIOS(
          _iosPigeon(tag: 'a', isFinished: true, fractionCompleted: 1),
        ),
        'b': OnlinePack.fromIOS(_iosPigeon(tag: 'b', fractionCompleted: 0.5)),
      });

      expect(total.progress, 0.75);
      expect(total.totalStatus, OnlineAssetStatus.downloading);
      expect(total.packMap.keys, ['a', 'b']);
    });

    test('replaces a pack with the same name instead of adding it', () {
      final first = empty.update({
        'a': OnlinePack.fromIOS(_iosPigeon(tag: 'a', fractionCompleted: 0.5)),
      });
      final second = first.update({
        'a': OnlinePack.fromIOS(
          _iosPigeon(tag: 'a', isFinished: true, fractionCompleted: 1),
        ),
      });

      expect(second.packMap, hasLength(1));
      expect(second.progress, 1.0);
      expect(second.totalStatus, OnlineAssetStatus.completed);
      expect(first.packMap['a']!.progress, 0.5, reason: 'immutable');
    });

    test('reports full progress when there are no packs', () {
      expect(empty.update({}).progress, 1.0);
    });
  });
}
