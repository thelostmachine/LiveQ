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
  static final _$joinRoom = $grpc.ClientMethod<$0.KeyRequest, $0.JoinReply>(
      '/liveq.LiveQ/JoinRoom',
      ($0.KeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.JoinReply.fromBuffer(value));
  static final _$addService = $grpc.ClientMethod<$0.ServiceRequest, $0.Status>(
      '/liveq.LiveQ/AddService',
      ($0.ServiceRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Status.fromBuffer(value));
  static final _$getServices = $grpc.ClientMethod<$0.KeyRequest, $0.ServiceMsg>(
      '/liveq.LiveQ/GetServices',
      ($0.KeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServiceMsg.fromBuffer(value));
  static final _$getQueue = $grpc.ClientMethod<$0.KeyRequest, $0.SongMsg>(
      '/liveq.LiveQ/GetQueue',
      ($0.KeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SongMsg.fromBuffer(value));
  static final _$addSong = $grpc.ClientMethod<$0.SongRequest, $0.Status>(
      '/liveq.LiveQ/AddSong',
      ($0.SongRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Status.fromBuffer(value));
  static final _$deleteSong = $grpc.ClientMethod<$0.SongRequest, $0.Status>(
      '/liveq.LiveQ/DeleteSong',
      ($0.SongRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Status.fromBuffer(value));

  LiveQClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.CreateReply> createRoom($0.CreateRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createRoom, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.JoinReply> joinRoom($0.KeyRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$joinRoom, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Status> addService($0.ServiceRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addService, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<$0.ServiceMsg> getServices($0.KeyRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getServices, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.SongMsg> getQueue($0.KeyRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getQueue, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseFuture<$0.Status> addSong($0.SongRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$addSong, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Status> deleteSong($0.SongRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$deleteSong, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
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
    $addMethod($grpc.ServiceMethod<$0.KeyRequest, $0.JoinReply>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KeyRequest.fromBuffer(value),
        ($0.JoinReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ServiceRequest, $0.Status>(
        'AddService',
        addService_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServiceRequest.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KeyRequest, $0.ServiceMsg>(
        'GetServices',
        getServices_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.KeyRequest.fromBuffer(value),
        ($0.ServiceMsg value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KeyRequest, $0.SongMsg>(
        'GetQueue',
        getQueue_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.KeyRequest.fromBuffer(value),
        ($0.SongMsg value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SongRequest, $0.Status>(
        'AddSong',
        addSong_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SongRequest.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SongRequest, $0.Status>(
        'DeleteSong',
        deleteSong_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SongRequest.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateReply> createRoom_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CreateRequest> request) async {
    return createRoom(call, await request);
  }

  $async.Future<$0.JoinReply> joinRoom_Pre(
      $grpc.ServiceCall call, $async.Future<$0.KeyRequest> request) async {
    return joinRoom(call, await request);
  }

  $async.Future<$0.Status> addService_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ServiceRequest> request) async {
    return addService(call, await request);
  }

  $async.Stream<$0.ServiceMsg> getServices_Pre(
      $grpc.ServiceCall call, $async.Future<$0.KeyRequest> request) async* {
    yield* getServices(call, await request);
  }

  $async.Stream<$0.SongMsg> getQueue_Pre(
      $grpc.ServiceCall call, $async.Future<$0.KeyRequest> request) async* {
    yield* getQueue(call, await request);
  }

  $async.Future<$0.Status> addSong_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SongRequest> request) async {
    return addSong(call, await request);
  }

  $async.Future<$0.Status> deleteSong_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SongRequest> request) async {
    return deleteSong(call, await request);
  }

  $async.Future<$0.CreateReply> createRoom(
      $grpc.ServiceCall call, $0.CreateRequest request);
  $async.Future<$0.JoinReply> joinRoom(
      $grpc.ServiceCall call, $0.KeyRequest request);
  $async.Future<$0.Status> addService(
      $grpc.ServiceCall call, $0.ServiceRequest request);
  $async.Stream<$0.ServiceMsg> getServices(
      $grpc.ServiceCall call, $0.KeyRequest request);
  $async.Stream<$0.SongMsg> getQueue(
      $grpc.ServiceCall call, $0.KeyRequest request);
  $async.Future<$0.Status> addSong(
      $grpc.ServiceCall call, $0.SongRequest request);
  $async.Future<$0.Status> deleteSong(
      $grpc.ServiceCall call, $0.SongRequest request);
}
