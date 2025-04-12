// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'online_assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnlineTotalPack implements DiagnosticableTreeMixin {

 Map<String, OnlinePack> get packMap; OnlineAssetStatus get totalStatus; double get progress;
/// Create a copy of OnlineTotalPack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineTotalPackCopyWith<OnlineTotalPack> get copyWith => _$OnlineTotalPackCopyWithImpl<OnlineTotalPack>(this as OnlineTotalPack, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlineTotalPack'))
    ..add(DiagnosticsProperty('packMap', packMap))..add(DiagnosticsProperty('totalStatus', totalStatus))..add(DiagnosticsProperty('progress', progress));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlineTotalPack&&const DeepCollectionEquality().equals(other.packMap, packMap)&&(identical(other.totalStatus, totalStatus) || other.totalStatus == totalStatus)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(packMap),totalStatus,progress);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlineTotalPack(packMap: $packMap, totalStatus: $totalStatus, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $OnlineTotalPackCopyWith<$Res>  {
  factory $OnlineTotalPackCopyWith(OnlineTotalPack value, $Res Function(OnlineTotalPack) _then) = _$OnlineTotalPackCopyWithImpl;
@useResult
$Res call({
 Map<String, OnlinePack> packMap, OnlineAssetStatus totalStatus, double progress
});




}
/// @nodoc
class _$OnlineTotalPackCopyWithImpl<$Res>
    implements $OnlineTotalPackCopyWith<$Res> {
  _$OnlineTotalPackCopyWithImpl(this._self, this._then);

  final OnlineTotalPack _self;
  final $Res Function(OnlineTotalPack) _then;

/// Create a copy of OnlineTotalPack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packMap = null,Object? totalStatus = null,Object? progress = null,}) {
  return _then(_self.copyWith(
packMap: null == packMap ? _self.packMap : packMap // ignore: cast_nullable_to_non_nullable
as Map<String, OnlinePack>,totalStatus: null == totalStatus ? _self.totalStatus : totalStatus // ignore: cast_nullable_to_non_nullable
as OnlineAssetStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _OnlineTotalPack extends OnlineTotalPack with DiagnosticableTreeMixin {
  const _OnlineTotalPack({required final  Map<String, OnlinePack> packMap, required this.totalStatus, required this.progress}): _packMap = packMap,super._();
  

 final  Map<String, OnlinePack> _packMap;
@override Map<String, OnlinePack> get packMap {
  if (_packMap is EqualUnmodifiableMapView) return _packMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_packMap);
}

@override final  OnlineAssetStatus totalStatus;
@override final  double progress;

/// Create a copy of OnlineTotalPack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlineTotalPackCopyWith<_OnlineTotalPack> get copyWith => __$OnlineTotalPackCopyWithImpl<_OnlineTotalPack>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlineTotalPack'))
    ..add(DiagnosticsProperty('packMap', packMap))..add(DiagnosticsProperty('totalStatus', totalStatus))..add(DiagnosticsProperty('progress', progress));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlineTotalPack&&const DeepCollectionEquality().equals(other._packMap, _packMap)&&(identical(other.totalStatus, totalStatus) || other.totalStatus == totalStatus)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_packMap),totalStatus,progress);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlineTotalPack(packMap: $packMap, totalStatus: $totalStatus, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$OnlineTotalPackCopyWith<$Res> implements $OnlineTotalPackCopyWith<$Res> {
  factory _$OnlineTotalPackCopyWith(_OnlineTotalPack value, $Res Function(_OnlineTotalPack) _then) = __$OnlineTotalPackCopyWithImpl;
@override @useResult
$Res call({
 Map<String, OnlinePack> packMap, OnlineAssetStatus totalStatus, double progress
});




}
/// @nodoc
class __$OnlineTotalPackCopyWithImpl<$Res>
    implements _$OnlineTotalPackCopyWith<$Res> {
  __$OnlineTotalPackCopyWithImpl(this._self, this._then);

  final _OnlineTotalPack _self;
  final $Res Function(_OnlineTotalPack) _then;

/// Create a copy of OnlineTotalPack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packMap = null,Object? totalStatus = null,Object? progress = null,}) {
  return _then(_OnlineTotalPack(
packMap: null == packMap ? _self._packMap : packMap // ignore: cast_nullable_to_non_nullable
as Map<String, OnlinePack>,totalStatus: null == totalStatus ? _self.totalStatus : totalStatus // ignore: cast_nullable_to_non_nullable
as OnlineAssetStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$OnlinePackHolder implements DiagnosticableTreeMixin {

 Map<String, OnlinePack> get packMap;
/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlinePackHolderCopyWith<OnlinePackHolder> get copyWith => _$OnlinePackHolderCopyWithImpl<OnlinePackHolder>(this as OnlinePackHolder, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePackHolder'))
    ..add(DiagnosticsProperty('packMap', packMap));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlinePackHolder&&const DeepCollectionEquality().equals(other.packMap, packMap));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(packMap));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePackHolder(packMap: $packMap)';
}


}

/// @nodoc
abstract mixin class $OnlinePackHolderCopyWith<$Res>  {
  factory $OnlinePackHolderCopyWith(OnlinePackHolder value, $Res Function(OnlinePackHolder) _then) = _$OnlinePackHolderCopyWithImpl;
@useResult
$Res call({
 Map<String, OnlinePack> packMap
});




}
/// @nodoc
class _$OnlinePackHolderCopyWithImpl<$Res>
    implements $OnlinePackHolderCopyWith<$Res> {
  _$OnlinePackHolderCopyWithImpl(this._self, this._then);

  final OnlinePackHolder _self;
  final $Res Function(OnlinePackHolder) _then;

/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packMap = null,}) {
  return _then(_self.copyWith(
packMap: null == packMap ? _self.packMap : packMap // ignore: cast_nullable_to_non_nullable
as Map<String, OnlinePack>,
  ));
}

}


/// @nodoc


class AndroidPackHolder with DiagnosticableTreeMixin implements OnlinePackHolder {
  const AndroidPackHolder({required final  Map<String, OnlinePack> packMap, required this.androidTotalBytes}): _packMap = packMap;
  

 final  Map<String, OnlinePack> _packMap;
@override Map<String, OnlinePack> get packMap {
  if (_packMap is EqualUnmodifiableMapView) return _packMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_packMap);
}

 final  int androidTotalBytes;

/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidPackHolderCopyWith<AndroidPackHolder> get copyWith => _$AndroidPackHolderCopyWithImpl<AndroidPackHolder>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePackHolder.android'))
    ..add(DiagnosticsProperty('packMap', packMap))..add(DiagnosticsProperty('androidTotalBytes', androidTotalBytes));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidPackHolder&&const DeepCollectionEquality().equals(other._packMap, _packMap)&&(identical(other.androidTotalBytes, androidTotalBytes) || other.androidTotalBytes == androidTotalBytes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_packMap),androidTotalBytes);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePackHolder.android(packMap: $packMap, androidTotalBytes: $androidTotalBytes)';
}


}

/// @nodoc
abstract mixin class $AndroidPackHolderCopyWith<$Res> implements $OnlinePackHolderCopyWith<$Res> {
  factory $AndroidPackHolderCopyWith(AndroidPackHolder value, $Res Function(AndroidPackHolder) _then) = _$AndroidPackHolderCopyWithImpl;
@override @useResult
$Res call({
 Map<String, OnlinePack> packMap, int androidTotalBytes
});




}
/// @nodoc
class _$AndroidPackHolderCopyWithImpl<$Res>
    implements $AndroidPackHolderCopyWith<$Res> {
  _$AndroidPackHolderCopyWithImpl(this._self, this._then);

  final AndroidPackHolder _self;
  final $Res Function(AndroidPackHolder) _then;

/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packMap = null,Object? androidTotalBytes = null,}) {
  return _then(AndroidPackHolder(
packMap: null == packMap ? _self._packMap : packMap // ignore: cast_nullable_to_non_nullable
as Map<String, OnlinePack>,androidTotalBytes: null == androidTotalBytes ? _self.androidTotalBytes : androidTotalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class IOSPackHolder with DiagnosticableTreeMixin implements OnlinePackHolder {
  const IOSPackHolder({required final  Map<String, OnlinePack> packMap}): _packMap = packMap;
  

 final  Map<String, OnlinePack> _packMap;
@override Map<String, OnlinePack> get packMap {
  if (_packMap is EqualUnmodifiableMapView) return _packMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_packMap);
}


/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IOSPackHolderCopyWith<IOSPackHolder> get copyWith => _$IOSPackHolderCopyWithImpl<IOSPackHolder>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePackHolder.iOS'))
    ..add(DiagnosticsProperty('packMap', packMap));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IOSPackHolder&&const DeepCollectionEquality().equals(other._packMap, _packMap));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_packMap));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePackHolder.iOS(packMap: $packMap)';
}


}

/// @nodoc
abstract mixin class $IOSPackHolderCopyWith<$Res> implements $OnlinePackHolderCopyWith<$Res> {
  factory $IOSPackHolderCopyWith(IOSPackHolder value, $Res Function(IOSPackHolder) _then) = _$IOSPackHolderCopyWithImpl;
@override @useResult
$Res call({
 Map<String, OnlinePack> packMap
});




}
/// @nodoc
class _$IOSPackHolderCopyWithImpl<$Res>
    implements $IOSPackHolderCopyWith<$Res> {
  _$IOSPackHolderCopyWithImpl(this._self, this._then);

  final IOSPackHolder _self;
  final $Res Function(IOSPackHolder) _then;

/// Create a copy of OnlinePackHolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packMap = null,}) {
  return _then(IOSPackHolder(
packMap: null == packMap ? _self._packMap : packMap // ignore: cast_nullable_to_non_nullable
as Map<String, OnlinePack>,
  ));
}


}

/// @nodoc
mixin _$OnlinePack implements DiagnosticableTreeMixin {

 String get name; OnlineAssetStatus get status; bool get hasError; double get progress;
/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlinePackCopyWith<OnlinePack> get copyWith => _$OnlinePackCopyWithImpl<OnlinePack>(this as OnlinePack, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePack'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('hasError', hasError))..add(DiagnosticsProperty('progress', progress));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlinePack&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,name,status,hasError,progress);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePack(name: $name, status: $status, hasError: $hasError, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $OnlinePackCopyWith<$Res>  {
  factory $OnlinePackCopyWith(OnlinePack value, $Res Function(OnlinePack) _then) = _$OnlinePackCopyWithImpl;
@useResult
$Res call({
 String name, OnlineAssetStatus status, bool hasError, double progress
});




}
/// @nodoc
class _$OnlinePackCopyWithImpl<$Res>
    implements $OnlinePackCopyWith<$Res> {
  _$OnlinePackCopyWithImpl(this._self, this._then);

  final OnlinePack _self;
  final $Res Function(OnlinePack) _then;

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? hasError = null,Object? progress = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OnlineAssetStatus,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class AndroidPack with DiagnosticableTreeMixin implements OnlinePack {
  const AndroidPack({required this.name, required this.status, required this.hasError, required this.progress, required this.androidBytesDownloaded, required this.androidErrorCode, required this.androidStatus, required this.androidTotalBytesToDownload, required this.androidTransferProgressPercentage});
  

@override final  String name;
@override final  OnlineAssetStatus status;
@override final  bool hasError;
@override final  double progress;
// Android-specific information
 final  int androidBytesDownloaded;
 final  AndroidAssetPackErrorCode androidErrorCode;
 final  AndroidAssetPackStatus androidStatus;
 final  int androidTotalBytesToDownload;
 final  int androidTransferProgressPercentage;

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidPackCopyWith<AndroidPack> get copyWith => _$AndroidPackCopyWithImpl<AndroidPack>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePack.android'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('hasError', hasError))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('androidBytesDownloaded', androidBytesDownloaded))..add(DiagnosticsProperty('androidErrorCode', androidErrorCode))..add(DiagnosticsProperty('androidStatus', androidStatus))..add(DiagnosticsProperty('androidTotalBytesToDownload', androidTotalBytesToDownload))..add(DiagnosticsProperty('androidTransferProgressPercentage', androidTransferProgressPercentage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidPack&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.androidBytesDownloaded, androidBytesDownloaded) || other.androidBytesDownloaded == androidBytesDownloaded)&&(identical(other.androidErrorCode, androidErrorCode) || other.androidErrorCode == androidErrorCode)&&(identical(other.androidStatus, androidStatus) || other.androidStatus == androidStatus)&&(identical(other.androidTotalBytesToDownload, androidTotalBytesToDownload) || other.androidTotalBytesToDownload == androidTotalBytesToDownload)&&(identical(other.androidTransferProgressPercentage, androidTransferProgressPercentage) || other.androidTransferProgressPercentage == androidTransferProgressPercentage));
}


@override
int get hashCode => Object.hash(runtimeType,name,status,hasError,progress,androidBytesDownloaded,androidErrorCode,androidStatus,androidTotalBytesToDownload,androidTransferProgressPercentage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePack.android(name: $name, status: $status, hasError: $hasError, progress: $progress, androidBytesDownloaded: $androidBytesDownloaded, androidErrorCode: $androidErrorCode, androidStatus: $androidStatus, androidTotalBytesToDownload: $androidTotalBytesToDownload, androidTransferProgressPercentage: $androidTransferProgressPercentage)';
}


}

/// @nodoc
abstract mixin class $AndroidPackCopyWith<$Res> implements $OnlinePackCopyWith<$Res> {
  factory $AndroidPackCopyWith(AndroidPack value, $Res Function(AndroidPack) _then) = _$AndroidPackCopyWithImpl;
@override @useResult
$Res call({
 String name, OnlineAssetStatus status, bool hasError, double progress, int androidBytesDownloaded, AndroidAssetPackErrorCode androidErrorCode, AndroidAssetPackStatus androidStatus, int androidTotalBytesToDownload, int androidTransferProgressPercentage
});




}
/// @nodoc
class _$AndroidPackCopyWithImpl<$Res>
    implements $AndroidPackCopyWith<$Res> {
  _$AndroidPackCopyWithImpl(this._self, this._then);

  final AndroidPack _self;
  final $Res Function(AndroidPack) _then;

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? hasError = null,Object? progress = null,Object? androidBytesDownloaded = null,Object? androidErrorCode = null,Object? androidStatus = null,Object? androidTotalBytesToDownload = null,Object? androidTransferProgressPercentage = null,}) {
  return _then(AndroidPack(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OnlineAssetStatus,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,androidBytesDownloaded: null == androidBytesDownloaded ? _self.androidBytesDownloaded : androidBytesDownloaded // ignore: cast_nullable_to_non_nullable
as int,androidErrorCode: null == androidErrorCode ? _self.androidErrorCode : androidErrorCode // ignore: cast_nullable_to_non_nullable
as AndroidAssetPackErrorCode,androidStatus: null == androidStatus ? _self.androidStatus : androidStatus // ignore: cast_nullable_to_non_nullable
as AndroidAssetPackStatus,androidTotalBytesToDownload: null == androidTotalBytesToDownload ? _self.androidTotalBytesToDownload : androidTotalBytesToDownload // ignore: cast_nullable_to_non_nullable
as int,androidTransferProgressPercentage: null == androidTransferProgressPercentage ? _self.androidTransferProgressPercentage : androidTransferProgressPercentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class IOSPack with DiagnosticableTreeMixin implements OnlinePack {
  const IOSPack({required this.name, required this.status, required this.hasError, required this.progress, required this.iOSError, required this.iOSProgress, required this.iOSCondition, required this.iOSLoadingPriority});
  

@override final  String name;
@override final  OnlineAssetStatus status;
@override final  bool hasError;
@override final  double progress;
// iOS-specific information
 final  IOSNSError? iOSError;
 final  IOSProgress iOSProgress;
 final  bool iOSCondition;
 final  double iOSLoadingPriority;

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IOSPackCopyWith<IOSPack> get copyWith => _$IOSPackCopyWithImpl<IOSPack>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlinePack.iOS'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('hasError', hasError))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('iOSError', iOSError))..add(DiagnosticsProperty('iOSProgress', iOSProgress))..add(DiagnosticsProperty('iOSCondition', iOSCondition))..add(DiagnosticsProperty('iOSLoadingPriority', iOSLoadingPriority));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IOSPack&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.iOSError, iOSError) || other.iOSError == iOSError)&&(identical(other.iOSProgress, iOSProgress) || other.iOSProgress == iOSProgress)&&(identical(other.iOSCondition, iOSCondition) || other.iOSCondition == iOSCondition)&&(identical(other.iOSLoadingPriority, iOSLoadingPriority) || other.iOSLoadingPriority == iOSLoadingPriority));
}


@override
int get hashCode => Object.hash(runtimeType,name,status,hasError,progress,iOSError,iOSProgress,iOSCondition,iOSLoadingPriority);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlinePack.iOS(name: $name, status: $status, hasError: $hasError, progress: $progress, iOSError: $iOSError, iOSProgress: $iOSProgress, iOSCondition: $iOSCondition, iOSLoadingPriority: $iOSLoadingPriority)';
}


}

/// @nodoc
abstract mixin class $IOSPackCopyWith<$Res> implements $OnlinePackCopyWith<$Res> {
  factory $IOSPackCopyWith(IOSPack value, $Res Function(IOSPack) _then) = _$IOSPackCopyWithImpl;
@override @useResult
$Res call({
 String name, OnlineAssetStatus status, bool hasError, double progress, IOSNSError? iOSError, IOSProgress iOSProgress, bool iOSCondition, double iOSLoadingPriority
});


$IOSNSErrorCopyWith<$Res>? get iOSError;$IOSProgressCopyWith<$Res> get iOSProgress;

}
/// @nodoc
class _$IOSPackCopyWithImpl<$Res>
    implements $IOSPackCopyWith<$Res> {
  _$IOSPackCopyWithImpl(this._self, this._then);

  final IOSPack _self;
  final $Res Function(IOSPack) _then;

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? hasError = null,Object? progress = null,Object? iOSError = freezed,Object? iOSProgress = null,Object? iOSCondition = null,Object? iOSLoadingPriority = null,}) {
  return _then(IOSPack(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OnlineAssetStatus,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,iOSError: freezed == iOSError ? _self.iOSError : iOSError // ignore: cast_nullable_to_non_nullable
as IOSNSError?,iOSProgress: null == iOSProgress ? _self.iOSProgress : iOSProgress // ignore: cast_nullable_to_non_nullable
as IOSProgress,iOSCondition: null == iOSCondition ? _self.iOSCondition : iOSCondition // ignore: cast_nullable_to_non_nullable
as bool,iOSLoadingPriority: null == iOSLoadingPriority ? _self.iOSLoadingPriority : iOSLoadingPriority // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IOSNSErrorCopyWith<$Res>? get iOSError {
    if (_self.iOSError == null) {
    return null;
  }

  return $IOSNSErrorCopyWith<$Res>(_self.iOSError!, (value) {
    return _then(_self.copyWith(iOSError: value));
  });
}/// Create a copy of OnlinePack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IOSProgressCopyWith<$Res> get iOSProgress {
  
  return $IOSProgressCopyWith<$Res>(_self.iOSProgress, (value) {
    return _then(_self.copyWith(iOSProgress: value));
  });
}
}

/// @nodoc
mixin _$IOSNSError implements DiagnosticableTreeMixin {

 int get code; String get domain; String get localizedDescription;
/// Create a copy of IOSNSError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IOSNSErrorCopyWith<IOSNSError> get copyWith => _$IOSNSErrorCopyWithImpl<IOSNSError>(this as IOSNSError, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'IOSNSError'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('domain', domain))..add(DiagnosticsProperty('localizedDescription', localizedDescription));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IOSNSError&&(identical(other.code, code) || other.code == code)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.localizedDescription, localizedDescription) || other.localizedDescription == localizedDescription));
}


@override
int get hashCode => Object.hash(runtimeType,code,domain,localizedDescription);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'IOSNSError(code: $code, domain: $domain, localizedDescription: $localizedDescription)';
}


}

/// @nodoc
abstract mixin class $IOSNSErrorCopyWith<$Res>  {
  factory $IOSNSErrorCopyWith(IOSNSError value, $Res Function(IOSNSError) _then) = _$IOSNSErrorCopyWithImpl;
@useResult
$Res call({
 int code, String domain, String localizedDescription
});




}
/// @nodoc
class _$IOSNSErrorCopyWithImpl<$Res>
    implements $IOSNSErrorCopyWith<$Res> {
  _$IOSNSErrorCopyWithImpl(this._self, this._then);

  final IOSNSError _self;
  final $Res Function(IOSNSError) _then;

/// Create a copy of IOSNSError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? domain = null,Object? localizedDescription = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,localizedDescription: null == localizedDescription ? _self.localizedDescription : localizedDescription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _IOSNSError with DiagnosticableTreeMixin implements IOSNSError {
  const _IOSNSError({required this.code, required this.domain, required this.localizedDescription});
  

@override final  int code;
@override final  String domain;
@override final  String localizedDescription;

/// Create a copy of IOSNSError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IOSNSErrorCopyWith<_IOSNSError> get copyWith => __$IOSNSErrorCopyWithImpl<_IOSNSError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'IOSNSError'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('domain', domain))..add(DiagnosticsProperty('localizedDescription', localizedDescription));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IOSNSError&&(identical(other.code, code) || other.code == code)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.localizedDescription, localizedDescription) || other.localizedDescription == localizedDescription));
}


@override
int get hashCode => Object.hash(runtimeType,code,domain,localizedDescription);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'IOSNSError(code: $code, domain: $domain, localizedDescription: $localizedDescription)';
}


}

/// @nodoc
abstract mixin class _$IOSNSErrorCopyWith<$Res> implements $IOSNSErrorCopyWith<$Res> {
  factory _$IOSNSErrorCopyWith(_IOSNSError value, $Res Function(_IOSNSError) _then) = __$IOSNSErrorCopyWithImpl;
@override @useResult
$Res call({
 int code, String domain, String localizedDescription
});




}
/// @nodoc
class __$IOSNSErrorCopyWithImpl<$Res>
    implements _$IOSNSErrorCopyWith<$Res> {
  __$IOSNSErrorCopyWithImpl(this._self, this._then);

  final _IOSNSError _self;
  final $Res Function(_IOSNSError) _then;

/// Create a copy of IOSNSError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? domain = null,Object? localizedDescription = null,}) {
  return _then(_IOSNSError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,localizedDescription: null == localizedDescription ? _self.localizedDescription : localizedDescription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$IOSProgress implements DiagnosticableTreeMixin {

 bool get isCancelled; bool get isPaused; double get fractionCompleted; bool get isFinished;
/// Create a copy of IOSProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IOSProgressCopyWith<IOSProgress> get copyWith => _$IOSProgressCopyWithImpl<IOSProgress>(this as IOSProgress, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'IOSProgress'))
    ..add(DiagnosticsProperty('isCancelled', isCancelled))..add(DiagnosticsProperty('isPaused', isPaused))..add(DiagnosticsProperty('fractionCompleted', fractionCompleted))..add(DiagnosticsProperty('isFinished', isFinished));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IOSProgress&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.fractionCompleted, fractionCompleted) || other.fractionCompleted == fractionCompleted)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}


@override
int get hashCode => Object.hash(runtimeType,isCancelled,isPaused,fractionCompleted,isFinished);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'IOSProgress(isCancelled: $isCancelled, isPaused: $isPaused, fractionCompleted: $fractionCompleted, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class $IOSProgressCopyWith<$Res>  {
  factory $IOSProgressCopyWith(IOSProgress value, $Res Function(IOSProgress) _then) = _$IOSProgressCopyWithImpl;
@useResult
$Res call({
 bool isCancelled, bool isPaused, double fractionCompleted, bool isFinished
});




}
/// @nodoc
class _$IOSProgressCopyWithImpl<$Res>
    implements $IOSProgressCopyWith<$Res> {
  _$IOSProgressCopyWithImpl(this._self, this._then);

  final IOSProgress _self;
  final $Res Function(IOSProgress) _then;

/// Create a copy of IOSProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCancelled = null,Object? isPaused = null,Object? fractionCompleted = null,Object? isFinished = null,}) {
  return _then(_self.copyWith(
isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,fractionCompleted: null == fractionCompleted ? _self.fractionCompleted : fractionCompleted // ignore: cast_nullable_to_non_nullable
as double,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _IOSProgress with DiagnosticableTreeMixin implements IOSProgress {
  const _IOSProgress({required this.isCancelled, required this.isPaused, required this.fractionCompleted, required this.isFinished});
  

@override final  bool isCancelled;
@override final  bool isPaused;
@override final  double fractionCompleted;
@override final  bool isFinished;

/// Create a copy of IOSProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IOSProgressCopyWith<_IOSProgress> get copyWith => __$IOSProgressCopyWithImpl<_IOSProgress>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'IOSProgress'))
    ..add(DiagnosticsProperty('isCancelled', isCancelled))..add(DiagnosticsProperty('isPaused', isPaused))..add(DiagnosticsProperty('fractionCompleted', fractionCompleted))..add(DiagnosticsProperty('isFinished', isFinished));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IOSProgress&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.fractionCompleted, fractionCompleted) || other.fractionCompleted == fractionCompleted)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}


@override
int get hashCode => Object.hash(runtimeType,isCancelled,isPaused,fractionCompleted,isFinished);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'IOSProgress(isCancelled: $isCancelled, isPaused: $isPaused, fractionCompleted: $fractionCompleted, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class _$IOSProgressCopyWith<$Res> implements $IOSProgressCopyWith<$Res> {
  factory _$IOSProgressCopyWith(_IOSProgress value, $Res Function(_IOSProgress) _then) = __$IOSProgressCopyWithImpl;
@override @useResult
$Res call({
 bool isCancelled, bool isPaused, double fractionCompleted, bool isFinished
});




}
/// @nodoc
class __$IOSProgressCopyWithImpl<$Res>
    implements _$IOSProgressCopyWith<$Res> {
  __$IOSProgressCopyWithImpl(this._self, this._then);

  final _IOSProgress _self;
  final $Res Function(_IOSProgress) _then;

/// Create a copy of IOSProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCancelled = null,Object? isPaused = null,Object? fractionCompleted = null,Object? isFinished = null,}) {
  return _then(_IOSProgress(
isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,fractionCompleted: null == fractionCompleted ? _self.fractionCompleted : fractionCompleted // ignore: cast_nullable_to_non_nullable
as double,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$OnlineAssetPackSettings implements DiagnosticableTreeMixin {

/// Asset Pack Name
 String get packName;
/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineAssetPackSettingsCopyWith<OnlineAssetPackSettings> get copyWith => _$OnlineAssetPackSettingsCopyWithImpl<OnlineAssetPackSettings>(this as OnlineAssetPackSettings, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlineAssetPackSettings'))
    ..add(DiagnosticsProperty('packName', packName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlineAssetPackSettings&&(identical(other.packName, packName) || other.packName == packName));
}


@override
int get hashCode => Object.hash(runtimeType,packName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlineAssetPackSettings(packName: $packName)';
}


}

/// @nodoc
abstract mixin class $OnlineAssetPackSettingsCopyWith<$Res>  {
  factory $OnlineAssetPackSettingsCopyWith(OnlineAssetPackSettings value, $Res Function(OnlineAssetPackSettings) _then) = _$OnlineAssetPackSettingsCopyWithImpl;
@useResult
$Res call({
 String packName
});




}
/// @nodoc
class _$OnlineAssetPackSettingsCopyWithImpl<$Res>
    implements $OnlineAssetPackSettingsCopyWith<$Res> {
  _$OnlineAssetPackSettingsCopyWithImpl(this._self, this._then);

  final OnlineAssetPackSettings _self;
  final $Res Function(OnlineAssetPackSettings) _then;

/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packName = null,}) {
  return _then(_self.copyWith(
packName: null == packName ? _self.packName : packName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class AndroidPackSettings with DiagnosticableTreeMixin implements OnlineAssetPackSettings {
  const AndroidPackSettings({required this.packName, required this.deliveryMode});
  

/// Asset Pack Name
@override final  String packName;
 final  AndroidAssetPackDeliveryMode deliveryMode;

/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidPackSettingsCopyWith<AndroidPackSettings> get copyWith => _$AndroidPackSettingsCopyWithImpl<AndroidPackSettings>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlineAssetPackSettings.android'))
    ..add(DiagnosticsProperty('packName', packName))..add(DiagnosticsProperty('deliveryMode', deliveryMode));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidPackSettings&&(identical(other.packName, packName) || other.packName == packName)&&(identical(other.deliveryMode, deliveryMode) || other.deliveryMode == deliveryMode));
}


@override
int get hashCode => Object.hash(runtimeType,packName,deliveryMode);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlineAssetPackSettings.android(packName: $packName, deliveryMode: $deliveryMode)';
}


}

/// @nodoc
abstract mixin class $AndroidPackSettingsCopyWith<$Res> implements $OnlineAssetPackSettingsCopyWith<$Res> {
  factory $AndroidPackSettingsCopyWith(AndroidPackSettings value, $Res Function(AndroidPackSettings) _then) = _$AndroidPackSettingsCopyWithImpl;
@override @useResult
$Res call({
 String packName, AndroidAssetPackDeliveryMode deliveryMode
});




}
/// @nodoc
class _$AndroidPackSettingsCopyWithImpl<$Res>
    implements $AndroidPackSettingsCopyWith<$Res> {
  _$AndroidPackSettingsCopyWithImpl(this._self, this._then);

  final AndroidPackSettings _self;
  final $Res Function(AndroidPackSettings) _then;

/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packName = null,Object? deliveryMode = null,}) {
  return _then(AndroidPackSettings(
packName: null == packName ? _self.packName : packName // ignore: cast_nullable_to_non_nullable
as String,deliveryMode: null == deliveryMode ? _self.deliveryMode : deliveryMode // ignore: cast_nullable_to_non_nullable
as AndroidAssetPackDeliveryMode,
  ));
}


}

/// @nodoc


class IOSPackSettings with DiagnosticableTreeMixin implements OnlineAssetPackSettings {
  const IOSPackSettings({required this.packName, required this.odrType});
  

/// On-Demand Resource Tag
///
/// If you use IOSOnDemandResourceType.assetsWithoutTag, set empty string for normal iOS assets (not On-Demand Resources)
@override final  String packName;
 final  IOSOnDemandResourceType odrType;

/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IOSPackSettingsCopyWith<IOSPackSettings> get copyWith => _$IOSPackSettingsCopyWithImpl<IOSPackSettings>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OnlineAssetPackSettings'))
    ..add(DiagnosticsProperty('packName', packName))..add(DiagnosticsProperty('odrType', odrType));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IOSPackSettings&&(identical(other.packName, packName) || other.packName == packName)&&(identical(other.odrType, odrType) || other.odrType == odrType));
}


@override
int get hashCode => Object.hash(runtimeType,packName,odrType);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OnlineAssetPackSettings(packName: $packName, odrType: $odrType)';
}


}

/// @nodoc
abstract mixin class $IOSPackSettingsCopyWith<$Res> implements $OnlineAssetPackSettingsCopyWith<$Res> {
  factory $IOSPackSettingsCopyWith(IOSPackSettings value, $Res Function(IOSPackSettings) _then) = _$IOSPackSettingsCopyWithImpl;
@override @useResult
$Res call({
 String packName, IOSOnDemandResourceType odrType
});




}
/// @nodoc
class _$IOSPackSettingsCopyWithImpl<$Res>
    implements $IOSPackSettingsCopyWith<$Res> {
  _$IOSPackSettingsCopyWithImpl(this._self, this._then);

  final IOSPackSettings _self;
  final $Res Function(IOSPackSettings) _then;

/// Create a copy of OnlineAssetPackSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packName = null,Object? odrType = null,}) {
  return _then(IOSPackSettings(
packName: null == packName ? _self.packName : packName // ignore: cast_nullable_to_non_nullable
as String,odrType: null == odrType ? _self.odrType : odrType // ignore: cast_nullable_to_non_nullable
as IOSOnDemandResourceType,
  ));
}


}

// dart format on
