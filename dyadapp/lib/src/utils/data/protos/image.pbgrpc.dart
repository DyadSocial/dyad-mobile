///
//  Generated code. Do not modify.
//  source: image.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'image.pb.dart' as $0;
export 'image.pb.dart';

class ImagesClient extends $grpc.Client {
  static final _$uploadImage = $grpc.ClientMethod<$0.ImageChunk, $0.Ack>(
      '/Images/UploadImage',
      ($0.ImageChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Ack.fromBuffer(value));

  ImagesClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Ack> uploadImage($async.Stream<$0.ImageChunk> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadImage, request, options: options)
        .single;
  }
}

abstract class ImagesServiceBase extends $grpc.Service {
  $core.String get $name => 'Images';

  ImagesServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ImageChunk, $0.Ack>(
        'UploadImage',
        uploadImage,
        true,
        false,
        ($core.List<$core.int> value) => $0.ImageChunk.fromBuffer(value),
        ($0.Ack value) => value.writeToBuffer()));
  }

  $async.Future<$0.Ack> uploadImage(
      $grpc.ServiceCall call, $async.Stream<$0.ImageChunk> request);
}
