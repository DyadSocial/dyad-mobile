///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'posts.pb.dart' as $0;
export 'posts.pb.dart';

class GroupSyncClient extends $grpc.Client {
  static final _$addUserToGroup = $grpc.ClientMethod<$0.User, $0.Group>(
      '/GroupSync/addUserToGroup',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Group.fromBuffer(value));
  static final _$delUserFromGroup = $grpc.ClientMethod<$0.User, $0.Group>(
      '/GroupSync/delUserFromGroup',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Group.fromBuffer(value));

  GroupSyncClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Group> addUserToGroup($0.User request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addUserToGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.Group> delUserFromGroup($0.User request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$delUserFromGroup, request, options: options);
  }
}

abstract class GroupSyncServiceBase extends $grpc.Service {
  $core.String get $name => 'GroupSync';

  GroupSyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.User, $0.Group>(
        'addUserToGroup',
        addUserToGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Group value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Group>(
        'delUserFromGroup',
        delUserFromGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Group value) => value.writeToBuffer()));
  }

  $async.Future<$0.Group> addUserToGroup_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return addUserToGroup(call, await request);
  }

  $async.Future<$0.Group> delUserFromGroup_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return delUserFromGroup(call, await request);
  }

  $async.Future<$0.Group> addUserToGroup(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Group> delUserFromGroup(
      $grpc.ServiceCall call, $0.User request);
}

class PostsSyncClient extends $grpc.Client {
  static final _$refreshPosts = $grpc.ClientMethod<$0.PostQuery, $0.Post>(
      '/PostsSync/refreshPosts',
      ($0.PostQuery value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Post.fromBuffer(value));
  static final _$queryPosts = $grpc.ClientMethod<$0.PostQuery, $0.Post>(
      '/PostsSync/queryPosts',
      ($0.PostQuery value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Post.fromBuffer(value));
  static final _$uploadPosts = $grpc.ClientMethod<$0.Post, $0.PostUploadAck>(
      '/PostsSync/uploadPosts',
      ($0.Post value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PostUploadAck.fromBuffer(value));

  PostsSyncClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.Post> refreshPosts($0.PostQuery request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$refreshPosts, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.Post> queryPosts($0.PostQuery request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$queryPosts, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.PostUploadAck> uploadPosts(
      $async.Stream<$0.Post> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadPosts, request, options: options);
  }
}

abstract class PostsSyncServiceBase extends $grpc.Service {
  $core.String get $name => 'PostsSync';

  PostsSyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PostQuery, $0.Post>(
        'refreshPosts',
        refreshPosts_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PostQuery.fromBuffer(value),
        ($0.Post value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PostQuery, $0.Post>(
        'queryPosts',
        queryPosts_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PostQuery.fromBuffer(value),
        ($0.Post value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Post, $0.PostUploadAck>(
        'uploadPosts',
        uploadPosts,
        true,
        true,
        ($core.List<$core.int> value) => $0.Post.fromBuffer(value),
        ($0.PostUploadAck value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Post> refreshPosts_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PostQuery> request) async* {
    yield* refreshPosts(call, await request);
  }

  $async.Stream<$0.Post> queryPosts_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PostQuery> request) async* {
    yield* queryPosts(call, await request);
  }

  $async.Stream<$0.Post> refreshPosts(
      $grpc.ServiceCall call, $0.PostQuery request);
  $async.Stream<$0.Post> queryPosts(
      $grpc.ServiceCall call, $0.PostQuery request);
  $async.Stream<$0.PostUploadAck> uploadPosts(
      $grpc.ServiceCall call, $async.Stream<$0.Post> request);
}
