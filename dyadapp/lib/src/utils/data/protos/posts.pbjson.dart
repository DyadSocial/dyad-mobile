///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use groupDescriptor instead')
const Group$json = const {
  '1': 'Group',
  '2': const [
    const {'1': 'gid', '3': 1, '4': 1, '5': 9, '10': 'gid'},
    const {'1': 'member_count', '3': 2, '4': 1, '5': 5, '10': 'memberCount'},
    const {'1': 'members', '3': 3, '4': 3, '5': 11, '6': '.User', '10': 'members'},
  ],
};

/// Descriptor for `Group`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupDescriptor = $convert.base64Decode('CgVHcm91cBIQCgNnaWQYASABKAlSA2dpZBIhCgxtZW1iZXJfY291bnQYAiABKAVSC21lbWJlckNvdW50Eh8KB21lbWJlcnMYAyADKAsyBS5Vc2VyUgdtZW1iZXJz');
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
    const {'1': 'group', '3': 6, '4': 1, '5': 11, '6': '.Group', '10': 'group'},
  ],
};

/// Descriptor for `PostQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postQueryDescriptor = $convert.base64Decode('CglQb3N0UXVlcnkSDgoCaWQYASABKAVSAmlkEhYKBmF1dGhvchgCIAEoCVIGYXV0aG9yEj0KDGxhc3RfdXBkYXRlZBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVkEjQKB2NyZWF0ZWQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdjcmVhdGVkEhwKBWdyb3VwGAYgASgLMgYuR3JvdXBSBWdyb3Vw');
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
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'hwid', '3': 2, '4': 1, '5': 9, '10': 'hwid'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRISCgRod2lkGAIgASgJUgRod2lk');
