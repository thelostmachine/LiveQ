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
    ..aOS(1, 'roomKey')
    ..aOS(2, 'hostId')
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
  $core.String get roomKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostId => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostId() => clearField(2);
}

class JoinRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('JoinRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'roomKey')
    ..hasRequiredFields = false
  ;

  JoinRequest._() : super();
  factory JoinRequest() => create();
  factory JoinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  JoinRequest clone() => JoinRequest()..mergeFromMessage(this);
  JoinRequest copyWith(void Function(JoinRequest) updates) => super.copyWith((message) => updates(message as JoinRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinRequest create() => JoinRequest._();
  JoinRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRequest> createRepeated() => $pb.PbList<JoinRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRequest>(create);
  static JoinRequest _defaultInstance;

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
    ..aOS(1, 'guestId')
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
  $core.String get guestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set guestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGuestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGuestId() => clearField(1);
}

class QueueRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('QueueRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'roomKey')
    ..hasRequiredFields = false
  ;

  QueueRequest._() : super();
  factory QueueRequest() => create();
  factory QueueRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueueRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  QueueRequest clone() => QueueRequest()..mergeFromMessage(this);
  QueueRequest copyWith(void Function(QueueRequest) updates) => super.copyWith((message) => updates(message as QueueRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueueRequest create() => QueueRequest._();
  QueueRequest createEmptyInstance() => create();
  static $pb.PbList<QueueRequest> createRepeated() => $pb.PbList<QueueRequest>();
  @$core.pragma('dart2js:noInline')
  static QueueRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueueRequest>(create);
  static QueueRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomKey() => clearField(1);
}

class QueueReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('QueueReply', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOS(1, 'songId')
    ..aOS(2, 'serviceId')
    ..hasRequiredFields = false
  ;

  QueueReply._() : super();
  factory QueueReply() => create();
  factory QueueReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueueReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  QueueReply clone() => QueueReply()..mergeFromMessage(this);
  QueueReply copyWith(void Function(QueueReply) updates) => super.copyWith((message) => updates(message as QueueReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueueReply create() => QueueReply._();
  QueueReply createEmptyInstance() => create();
  static $pb.PbList<QueueReply> createRepeated() => $pb.PbList<QueueReply>();
  @$core.pragma('dart2js:noInline')
  static QueueReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueueReply>(create);
  static QueueReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get songId => $_getSZ(0);
  @$pb.TagNumber(1)
  set songId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSongId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSongId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);
}

class SongRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SongRequest', package: const $pb.PackageName('liveq'), createEmptyInstance: create)
    ..aOM<QueueReply>(1, 'song', subBuilder: QueueReply.create)
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
  QueueReply get song => $_getN(0);
  @$pb.TagNumber(1)
  set song(QueueReply v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSong() => $_has(0);
  @$pb.TagNumber(1)
  void clearSong() => clearField(1);
  @$pb.TagNumber(1)
  QueueReply ensureSong() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get roomKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomKey() => clearField(2);
}

