///
//  Generated code. Do not modify.
//  source: count.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'count.pb.dart' as $0;
export 'count.pb.dart';

class ActiveUsersClient extends $grpc.Client {
  static final _$getRecentlyActive =
      $grpc.ClientMethod<$0.ActiveQuery, $0.Count>(
          '/ActiveUsers/getRecentlyActive',
          ($0.ActiveQuery value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Count.fromBuffer(value));

  ActiveUsersClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.Count> getRecentlyActive($0.ActiveQuery request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getRecentlyActive, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class ActiveUsersServiceBase extends $grpc.Service {
  $core.String get $name => 'ActiveUsers';

  ActiveUsersServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ActiveQuery, $0.Count>(
        'getRecentlyActive',
        getRecentlyActive_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.ActiveQuery.fromBuffer(value),
        ($0.Count value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Count> getRecentlyActive_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ActiveQuery> request) async* {
    yield* getRecentlyActive(call, await request);
  }

  $async.Stream<$0.Count> getRecentlyActive(
      $grpc.ServiceCall call, $0.ActiveQuery request);
}
