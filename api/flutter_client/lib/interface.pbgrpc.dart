///
//  Generated code. Do not modify.
//  source: interface.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'interface.pb.dart' as $0;
export 'interface.pb.dart';

class LiveQClient extends $grpc.Client {
  static final _$createRoom =
      $grpc.ClientMethod<$0.CreateRequest, $0.CreateReply>(
          '/liveq.LiveQ/CreateRoom',
          ($0.CreateRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.CreateReply.fromBuffer(value));
  static final _$joinRoom = $grpc.ClientMethod<$0.JoinRequest, $0.JoinReply>(
      '/liveq.LiveQ/JoinRoom',
      ($0.JoinRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.JoinReply.fromBuffer(value));
  static final _$updateQueue =
      $grpc.ClientMethod<$0.QueueRequest, $0.QueueReply>(
          '/liveq.LiveQ/UpdateQueue',
          ($0.QueueRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.QueueReply.fromBuffer(value));
  static final _$addSong = $grpc.ClientMethod<$0.SongRequest, $0.QueueReply>(
      '/liveq.LiveQ/AddSong',
      ($0.SongRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.QueueReply.fromBuffer(value));
  static final _$deleteSong = $grpc.ClientMethod<$0.SongRequest, $0.QueueReply>(
      '/liveq.LiveQ/DeleteSong',
      ($0.SongRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.QueueReply.fromBuffer(value));

  LiveQClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.CreateReply> createRoom($0.CreateRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createRoom, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.JoinReply> joinRoom($0.JoinRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$joinRoom, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<$0.QueueReply> updateQueue($0.QueueRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateQueue, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.QueueReply> addSong($0.SongRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$addSong, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.QueueReply> deleteSong($0.SongRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteSong, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class LiveQServiceBase extends $grpc.Service {
  $core.String get $name => 'liveq.LiveQ';

  LiveQServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateRequest, $0.CreateReply>(
        'CreateRoom',
        createRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRequest.fromBuffer(value),
        ($0.CreateReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRequest, $0.JoinReply>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRequest.fromBuffer(value),
        ($0.JoinReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueueRequest, $0.QueueReply>(
        'UpdateQueue',
        updateQueue_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.QueueRequest.fromBuffer(value),
        ($0.QueueReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SongRequest, $0.QueueReply>(
        'AddSong',
        addSong_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SongRequest.fromBuffer(value),
        ($0.QueueReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SongRequest, $0.QueueReply>(
        'DeleteSong',
        deleteSong_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SongRequest.fromBuffer(value),
        ($0.QueueReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateReply> createRoom_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CreateRequest> request) async {
    return createRoom(call, await request);
  }

  $async.Future<$0.JoinReply> joinRoom_Pre(
      $grpc.ServiceCall call, $async.Future<$0.JoinRequest> request) async {
    return joinRoom(call, await request);
  }

  $async.Stream<$0.QueueReply> updateQueue_Pre(
      $grpc.ServiceCall call, $async.Future<$0.QueueRequest> request) async* {
    yield* updateQueue(call, await request);
  }

  $async.Stream<$0.QueueReply> addSong_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SongRequest> request) async* {
    yield* addSong(call, await request);
  }

  $async.Stream<$0.QueueReply> deleteSong_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SongRequest> request) async* {
    yield* deleteSong(call, await request);
  }

  $async.Future<$0.CreateReply> createRoom(
      $grpc.ServiceCall call, $0.CreateRequest request);
  $async.Future<$0.JoinReply> joinRoom(
      $grpc.ServiceCall call, $0.JoinRequest request);
  $async.Stream<$0.QueueReply> updateQueue(
      $grpc.ServiceCall call, $0.QueueRequest request);
  $async.Stream<$0.QueueReply> addSong(
      $grpc.ServiceCall call, $0.SongRequest request);
  $async.Stream<$0.QueueReply> deleteSong(
      $grpc.ServiceCall call, $0.SongRequest request);
}
