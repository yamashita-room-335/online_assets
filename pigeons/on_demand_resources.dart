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
abstract class OnDemandResourcesEventChannelMethods {
  IOSOnDemandResourcePigeon streamOnDemandResource();
}

@HostApi()
abstract class OnDemandResourcesHostApiMethods {
  IOSOnDemandResourcesPigeon requestNSBundleResourceRequests({
    required List<String> tags,
  });

  @async
  IOSOnDemandResourcesPigeon beginAccessingResources({
    required List<String> tags,
  });

  /// It is not possible to obtain the file path of the asset file itself.
  /// Therefore, the path of the copied file as a temporary file is obtained.
  ///
  /// The reason for including the tag namespace in the path is so that there is no problem if the filename is same with other asset packs.
  String? getCopiedAssetFilePath({
    required String tag,
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
