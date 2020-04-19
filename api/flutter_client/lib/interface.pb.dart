///
//  Generated code. Do not modify.
//  source: interface.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CreateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'roomName')
    ..hasRequiredFields = false
  ;

  CreateRequest._() : super();
  factory CreateRequest() => create();
  factory CreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CreateRequest clone() => CreateRequest()..mergeFromMessage(this);
  CreateRequest copyWith(void Function(CreateRequest) updates) => super.copyWith((message) => updates(message as CreateRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateRequest create() => CreateRequest._();
  CreateRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRequest> createRepeated() => $pb.PbList<CreateRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRequest>(create);
  static CreateRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomName => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomName() => clearField(1);
}

class CreateReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateReply', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOM<Status>(1, 'status', subBuilder: Status.create)
    ..aOS(2, 'roomKey')
    ..aOS(3, 'hostId')
    ..hasRequiredFields = false
  ;

  CreateReply._() : super();
  factory CreateReply() => create();
  factory CreateReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CreateReply clone() => CreateReply()..mergeFromMessage(this);
  CreateReply copyWith(void Function(CreateReply) updates) => super.copyWith((message) => updates(message as CreateReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateReply create() => CreateReply._();
  CreateReply createEmptyInstance() => create();
  static $pb.PbList<CreateReply> createRepeated() => $pb.PbList<CreateReply>();
  @$core.pragma('dart2js:noInline')
  static CreateReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateReply>(create);
  static CreateReply _defaultInstance;

  @$pb.TagNumber(1)
  Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get roomKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get hostId => $_getSZ(2);
  @$pb.TagNumber(3)
  set hostId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHostId() => $_has(2);
  @$pb.TagNumber(3)
  void clearHostId() => clearField(3);
}

class KeyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('KeyRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'roomKey')
    ..hasRequiredFields = false
  ;

  KeyRequest._() : super();
  factory KeyRequest() => create();
  factory KeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  KeyRequest clone() => KeyRequest()..mergeFromMessage(this);
  KeyRequest copyWith(void Function(KeyRequest) updates) => super.copyWith((message) => updates(message as KeyRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeyRequest create() => KeyRequest._();
  KeyRequest createEmptyInstance() => create();
  static $pb.PbList<KeyRequest> createRepeated() => $pb.PbList<KeyRequest>();
  @$core.pragma('dart2js:noInline')
  static KeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KeyRequest>(create);
  static KeyRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomKey() => clearField(1);
}

class JoinReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('JoinReply', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOM<Status>(1, 'status', subBuilder: Status.create)
    ..aOS(2, 'roomName')
    ..aOS(3, 'guestId')
    ..hasRequiredFields = false
  ;

  JoinReply._() : super();
  factory JoinReply() => create();
  factory JoinReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  JoinReply clone() => JoinReply()..mergeFromMessage(this);
  JoinReply copyWith(void Function(JoinReply) updates) => super.copyWith((message) => updates(message as JoinReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinReply create() => JoinReply._();
  JoinReply createEmptyInstance() => create();
  static $pb.PbList<JoinReply> createRepeated() => $pb.PbList<JoinReply>();
  @$core.pragma('dart2js:noInline')
  static JoinReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinReply>(create);
  static JoinReply _defaultInstance;

  @$pb.TagNumber(1)
  Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get roomName => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomName() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get guestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set guestId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGuestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGuestId() => clearField(3);
}

class ServiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServiceRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'roomKey')
    ..aOM<ServiceMsg>(2, 'service', subBuilder: ServiceMsg.create)
    ..hasRequiredFields = false
  ;

  ServiceRequest._() : super();
  factory ServiceRequest() => create();
  factory ServiceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ServiceRequest clone() => ServiceRequest()..mergeFromMessage(this);
  ServiceRequest copyWith(void Function(ServiceRequest) updates) => super.copyWith((message) => updates(message as ServiceRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceRequest create() => ServiceRequest._();
  ServiceRequest createEmptyInstance() => create();
  static $pb.PbList<ServiceRequest> createRepeated() => $pb.PbList<ServiceRequest>();
  @$core.pragma('dart2js:noInline')
  static ServiceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceRequest>(create);
  static ServiceRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomKey() => clearField(1);

  @$pb.TagNumber(2)
  ServiceMsg get service => $_getN(1);
  @$pb.TagNumber(2)
  set service(ServiceMsg v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);
  @$pb.TagNumber(2)
  ServiceMsg ensureService() => $_ensure(1);
}

class Status extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Status', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..a<$core.int>(1, 'status', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Status._() : super();
  factory Status() => create();
  factory Status.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Status.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Status clone() => Status()..mergeFromMessage(this);
  Status copyWith(void Function(Status) updates) => super.copyWith((message) => updates(message as Status));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Status create() => Status._();
  Status createEmptyInstance() => create();
  static $pb.PbList<Status> createRepeated() => $pb.PbList<Status>();
  @$core.pragma('dart2js:noInline')
  static Status getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Status>(create);
  static Status _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class ServiceMsg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServiceMsg', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..hasRequiredFields = false
  ;

  ServiceMsg._() : super();
  factory ServiceMsg() => create();
  factory ServiceMsg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceMsg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ServiceMsg clone() => ServiceMsg()..mergeFromMessage(this);
  ServiceMsg copyWith(void Function(ServiceMsg) updates) => super.copyWith((message) => updates(message as ServiceMsg));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceMsg create() => ServiceMsg._();
  ServiceMsg createEmptyInstance() => create();
  static $pb.PbList<ServiceMsg> createRepeated() => $pb.PbList<ServiceMsg>();
  @$core.pragma('dart2js:noInline')
  static ServiceMsg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceMsg>(create);
  static ServiceMsg _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class SongMsg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SongMsg', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'songId')
    ..aOS(2, 'uri')
    ..aOS(3, 'name')
    ..aOS(4, 'artist')
    ..aOS(5, 'imageUri')
    ..a<$core.int>(6, 'duration', $pb.PbFieldType.O3)
    ..aOS(7, 'service')
    ..hasRequiredFields = false
  ;

  SongMsg._() : super();
  factory SongMsg() => create();
  factory SongMsg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SongMsg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SongMsg clone() => SongMsg()..mergeFromMessage(this);
  SongMsg copyWith(void Function(SongMsg) updates) => super.copyWith((message) => updates(message as SongMsg));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SongMsg create() => SongMsg._();
  SongMsg createEmptyInstance() => create();
  static $pb.PbList<SongMsg> createRepeated() => $pb.PbList<SongMsg>();
  @$core.pragma('dart2js:noInline')
  static SongMsg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SongMsg>(create);
  static SongMsg _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get songId => $_getSZ(0);
  @$pb.TagNumber(1)
  set songId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSongId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSongId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get artist => $_getSZ(3);
  @$pb.TagNumber(4)
  set artist($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasArtist() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtist() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get imageUri => $_getSZ(4);
  @$pb.TagNumber(5)
  set imageUri($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImageUri() => $_has(4);
  @$pb.TagNumber(5)
  void clearImageUri() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get duration => $_getIZ(5);
  @$pb.TagNumber(6)
  set duration($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDuration() => $_has(5);
  @$pb.TagNumber(6)
  void clearDuration() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get service => $_getSZ(6);
  @$pb.TagNumber(7)
  set service($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasService() => $_has(6);
  @$pb.TagNumber(7)
  void clearService() => clearField(7);
}

class SongRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SongRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOM<SongMsg>(1, 'song', subBuilder: SongMsg.create)
    ..aOS(2, 'roomKey')
    ..hasRequiredFields = false
  ;

  SongRequest._() : super();
  factory SongRequest() => create();
  factory SongRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SongRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SongRequest clone() => SongRequest()..mergeFromMessage(this);
  SongRequest copyWith(void Function(SongRequest) updates) => super.copyWith((message) => updates(message as SongRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SongRequest create() => SongRequest._();
  SongRequest createEmptyInstance() => create();
  static $pb.PbList<SongRequest> createRepeated() => $pb.PbList<SongRequest>();
  @$core.pragma('dart2js:noInline')
  static SongRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SongRequest>(create);
  static SongRequest _defaultInstance;

  @$pb.TagNumber(1)
  SongMsg get song => $_getN(0);
  @$pb.TagNumber(1)
  set song(SongMsg v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSong() => $_has(0);
  @$pb.TagNumber(1)
  void clearSong() => clearField(1);
  @$pb.TagNumber(1)
  SongMsg ensureSong() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get roomKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomKey() => clearField(2);
}

