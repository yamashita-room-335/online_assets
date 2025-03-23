import 'package:pigeon/pigeon.dart';

// Since Pigeon does not support other imports, conversion is done in a separate class file.

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/on_demand_resources.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Runner/OnDemandResources.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@EventChannelApi()
abstract class OnDemandResourcesEventChannelApi {
  IOSOnDemandResourcePigeon streamOnDemandResource();
}

@HostApi()
abstract class OnDemandResourcesHostApi {
  @async
  IOSOnDemandResourcesPigeon requestResourcesProgress({
    required List<String> tags,
  });

  @async
  IOSOnDemandResourcesPigeon beginAccessingResources({
    required List<String> tags,
  });

  /// Get the path to the copy of the iOS Asset file.
  ///
  /// If [tag] == [null], access is made to standard iOS assets that is not On-Demand Resources.
  /// Standard iOS assets are used to perform the same behavior as Android's install-time asset pack.
  ///
  /// It is not possible to obtain the file path of the asset file itself.
  /// Therefore, the path of the copied file as a temporary file is obtained.
  /// Note that using this function uses twice as much device storage due to the assets of the system and the copied files.
  /// The temporary files will be deleted when storage space is running low due to temporary files, but will be re-downloaded on reuse.
  ///
  /// The reason for including the tag namespace in the path is so that there is no conflict if the filename is same with other asset packs.
  @async
  String? getCopiedAssetFilePath({
    required String? tag,
    required String relativeAssetPathWithTagNamespace,
    int extensionLevel = 1,
  });
}

/// Holder
class IOSOnDemandResourcesPigeon {
  IOSOnDemandResourcesPigeon({required this.resourceMap});

  /// Map from a On-Demand Resource Tag to its Resource
  Map<String, IOSOnDemandResourcePigeon> resourceMap;
}

/// https://developer.apple.com/documentation/foundation/nsbundleresourcerequest
class IOSOnDemandResourcePigeon {
  IOSOnDemandResourcePigeon({
    required this.tag,
    required this.error,
    required this.progress,
    required this.condition,
    required this.loadingPriority,
  });

  String tag;

  /// https://developer.apple.com/documentation/foundation/nsbundleresourcerequest/1614840-beginaccessingresources
  IOSNSErrorPigeon? error;

  /// https://developer.apple.com/documentation/foundation/nsbundleresourcerequest/1614834-conditionallybeginaccessingresou
  bool condition;

  /// https://developer.apple.com/documentation/foundation/nsbundleresourcerequest/1614841-loadingpriority
  double loadingPriority;

  /// https://developer.apple.com/documentation/foundation/nsbundleresourcerequest/1614838-progress
  IOSProgressPigeon progress;
}

/// https://developer.apple.com/documentation/foundation/nserror
class IOSNSErrorPigeon {
  IOSNSErrorPigeon({
    required this.code,
    required this.domain,
    required this.localizedDescription,
  });

  int code;
  String domain;
  String localizedDescription;
}

/// https://developer.apple.com/documentation/foundation/progress
class IOSProgressPigeon {
  IOSProgressPigeon({
    required this.isCancelled,
    required this.isPaused,
    required this.fractionCompleted,
    required this.isFinished,
  });

  bool isCancelled;
  bool isPaused;
  double fractionCompleted;
  bool isFinished;
}
