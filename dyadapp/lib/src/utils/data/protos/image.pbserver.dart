///
//  Generated code. Do not modify.
//  source: image.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'image.pb.dart' as $1;
import 'image.pbjson.dart';

export 'image.pb.dart';

abstract class ImagesServiceBase extends $pb.GeneratedService {
  $async.Future<$1.Ack> uploadImage($pb.ServerContext ctx, $1.ImageChunk request);
  $async.Future<$1.ImageChunk> pullImage($pb.ServerContext ctx, $1.ImageQuery request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'UploadImage': return $1.ImageChunk();
      case 'PullImage': return $1.ImageQuery();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'UploadImage': return this.uploadImage(ctx, request as $1.ImageChunk);
      case 'PullImage': return this.pullImage(ctx, request as $1.ImageQuery);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ImagesServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ImagesServiceBase$messageJson;
}

