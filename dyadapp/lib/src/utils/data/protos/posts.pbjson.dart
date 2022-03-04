///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use postDescriptor instead')
const Post$json = const {
  '1': 'Post',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'content', '3': 3, '4': 1, '5': 11, '6': '.Content', '10': 'content'},
    const {'1': 'last_updated', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastUpdated'},
    const {'1': 'created', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `Post`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postDescriptor = $convert.base64Decode('CgRQb3N0Eg4KAmlkGAEgASgFUgJpZBIWCgZhdXRob3IYAiABKAlSBmF1dGhvchIiCgdjb250ZW50GAMgASgLMgguQ29udGVudFIHY29udGVudBI9CgxsYXN0X3VwZGF0ZWQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtsYXN0VXBkYXRlZBI0CgdjcmVhdGVkGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZBIUCgV0aXRsZRgGIAEoCVIFdGl0bGU=');
@$core.Deprecated('Use postQueryDescriptor instead')
const PostQuery$json = const {
  '1': 'PostQuery',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'last_updated', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastUpdated'},
    const {'1': 'created', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'count', '3': 5, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `PostQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postQueryDescriptor = $convert.base64Decode('CglQb3N0UXVlcnkSDgoCaWQYASABKAVSAmlkEhYKBmF1dGhvchgCIAEoCVIGYXV0aG9yEj0KDGxhc3RfdXBkYXRlZBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVkEjQKB2NyZWF0ZWQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdjcmVhdGVkEhQKBWNvdW50GAUgASgFUgVjb3VudA==');
@$core.Deprecated('Use postUploadAckDescriptor instead')
const PostUploadAck$json = const {
  '1': 'PostUploadAck',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'saved_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'savedTime'},
  ],
};

/// Descriptor for `PostUploadAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postUploadAckDescriptor = $convert.base64Decode('Cg1Qb3N0VXBsb2FkQWNrEg4KAmlkGAEgASgFUgJpZBI5CgpzYXZlZF90aW1lGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc2F2ZWRUaW1l');
@$core.Deprecated('Use feedDescriptor instead')
const Feed$json = const {
  '1': 'Feed',
  '2': const [
    const {'1': 'authors', '3': 4, '4': 3, '5': 9, '10': 'authors'},
    const {'1': 'posts', '3': 2, '4': 3, '5': 11, '6': '.Post', '10': 'posts'},
    const {'1': 'last_updated', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastUpdated'},
  ],
  '9': const [
    const {'1': 1, '2': 2},
  ],
};

/// Descriptor for `Feed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedDescriptor = $convert.base64Decode('CgRGZWVkEhgKB2F1dGhvcnMYBCADKAlSB2F1dGhvcnMSGwoFcG9zdHMYAiADKAsyBS5Qb3N0UgVwb3N0cxI9CgxsYXN0X3VwZGF0ZWQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtsYXN0VXBkYXRlZEoECAEQAg==');
