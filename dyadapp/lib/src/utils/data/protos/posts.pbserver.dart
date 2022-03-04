///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'posts.pb.dart' as $2;
import 'posts.pbjson.dart';

export 'posts.pb.dart';

abstract class PostsSyncServiceBase extends $pb.GeneratedService {
  $async.Future<$2.Post> refreshPosts($pb.ServerContext ctx, $2.PostQuery request);
  $async.Future<$2.Post> queryPosts($pb.ServerContext ctx, $2.PostQuery request);
  $async.Future<$2.PostUploadAck> uploadPosts($pb.ServerContext ctx, $2.Post request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'refreshPosts': return $2.PostQuery();
      case 'queryPosts': return $2.PostQuery();
      case 'uploadPosts': return $2.Post();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'refreshPosts': return this.refreshPosts(ctx, request as $2.PostQuery);
      case 'queryPosts': return this.queryPosts(ctx, request as $2.PostQuery);
      case 'uploadPosts': return this.uploadPosts(ctx, request as $2.Post);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PostsSyncServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => PostsSyncServiceBase$messageJson;
}

