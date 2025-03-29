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
  /// It is not possible to obtain the file path of the asset file itself.
  /// Therefore, the path of the file copied to temporary directory is obtained.
  ///
  /// If the file is still in the temporary folder when this function is called and the file size is the same as the asset, file is reused.
  /// Therefore, if an asset is replaced by app update, and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
  /// In this case, use the [deleteCopiedAssetFile] function.
  /// However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
  ///
  /// If [tag] == [null], access is made to standard iOS assets that is not On-Demand Resources.
  ///
  /// Note that using this function uses twice as much device storage due to the assets of the system and the copied files.
  /// The copied files and on-demand resource files will be deleted by system when storage space is running low due to temporary files, but will be copied or downloaded again on use.
  ///
  /// The reason for including the tag namespace in the asset name is so that there is no conflict if the name is same with other asset packs.
  @async
  String? getCopiedAssetFilePath({
    required String? tag,
    required String assetNameWithPackNameNamespace,
    required String ext,
  });

  /// Delete the copied asset file.
  ///
  /// If [tag] == [null], delete standard iOS assets copied file that is not On-Demand Resources.
  ///
  /// Returns true if the target file or folder was successfully deleted.
  /// Also returns true if the target file or folder does not yet exist.
  ///
  /// If the file is still in the temporary folder when [getCopiedAssetFilePath] function is called and the file size is the same as the asset, file is reused.
  /// Therefore, if an asset is replaced by app update, and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
  /// If you want to avoid this case, you call delete function when your app update.
  /// However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
  @async
  bool deleteCopiedAssetFile({
    required String assetNameWithPackNameNamespace,
    required String ext,
  });

  @async
  bool deleteCopiedAssetFolder({required String packName});

  @async
  bool deleteAllCopiedAssetFolders();
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
