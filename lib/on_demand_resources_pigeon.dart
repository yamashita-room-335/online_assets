import 'package:pigeon/pigeon.dart';

// Since Pigeon does not support other imports, conversion is done in a separate class file.

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/on_demand_resources_pigeon.pigeon.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Runner/OnDemandResourcesPigeon.pigeon.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@EventChannelApi()
abstract class OnDemandResourcesEventChannelMethods {
  IOSOnDemandResourcePigeon streamOnDemandResource();
}

@HostApi()
abstract class OnDemandResourcesHostApiMethods {
  IOSOnDemandResourcesPigeon requestNSBundleResourceRequests(List<String> tags);

  @async
  IOSOnDemandResourcesPigeon beginAccessingResources(List<String> tags);

  String? getAbsoluteAssetPath(
    String tag,
    String relativeAssetPath, {
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
