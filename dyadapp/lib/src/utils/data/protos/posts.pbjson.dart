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
    const {'1': 'group', '3': 7, '4': 1, '5': 9, '10': 'group'},
    const {'1': 'comments', '3': 8, '4': 3, '5': 11, '6': '.CommentThread', '10': 'comments'},
    const {'1': 'event_time', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 0, '10': 'eventTime', '17': true},
  ],
  '8': const [
    const {'1': '_event_time'},
  ],
};

/// Descriptor for `Post`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postDescriptor = $convert.base64Decode('CgRQb3N0Eg4KAmlkGAEgASgFUgJpZBIWCgZhdXRob3IYAiABKAlSBmF1dGhvchIiCgdjb250ZW50GAMgASgLMgguQ29udGVudFIHY29udGVudBI9CgxsYXN0X3VwZGF0ZWQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtsYXN0VXBkYXRlZBI0CgdjcmVhdGVkGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZBIUCgV0aXRsZRgGIAEoCVIFdGl0bGUSFAoFZ3JvdXAYByABKAlSBWdyb3VwEioKCGNvbW1lbnRzGAggAygLMg4uQ29tbWVudFRocmVhZFIIY29tbWVudHMSPgoKZXZlbnRfdGltZRgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBIAFIJZXZlbnRUaW1liAEBQg0KC19ldmVudF90aW1l');
@$core.Deprecated('Use commentDescriptor instead')
const Comment$json = const {
  '1': 'Comment',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'last_updated', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastUpdated'},
    const {'1': 'created', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'parent_id', '3': 6, '4': 1, '5': 5, '10': 'parentId'},
  ],
};

/// Descriptor for `Comment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentDescriptor = $convert.base64Decode('CgdDb21tZW50Eg4KAmlkGAEgASgFUgJpZBIWCgZhdXRob3IYAiABKAlSBmF1dGhvchISCgR0ZXh0GAMgASgJUgR0ZXh0Ej0KDGxhc3RfdXBkYXRlZBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVkEjQKB2NyZWF0ZWQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdjcmVhdGVkEhsKCXBhcmVudF9pZBgGIAEoBVIIcGFyZW50SWQ=');
@$core.Deprecated('Use commentThreadDescriptor instead')
const CommentThread$json = const {
  '1': 'CommentThread',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'last_updated', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastUpdated'},
    const {'1': 'created', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'parent_id', '3': 6, '4': 1, '5': 5, '10': 'parentId'},
    const {'1': 'replies', '3': 7, '4': 3, '5': 11, '6': '.Comment', '10': 'replies'},
  ],
};

/// Descriptor for `CommentThread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentThreadDescriptor = $convert.base64Decode('Cg1Db21tZW50VGhyZWFkEg4KAmlkGAEgASgFUgJpZBIWCgZhdXRob3IYAiABKAlSBmF1dGhvchISCgR0ZXh0GAMgASgJUgR0ZXh0Ej0KDGxhc3RfdXBkYXRlZBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVkEjQKB2NyZWF0ZWQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdjcmVhdGVkEhsKCXBhcmVudF9pZBgGIAEoBVIIcGFyZW50SWQSIgoHcmVwbGllcxgHIAMoCzIILkNvbW1lbnRSB3JlcGxpZXM=');
@$core.Deprecated('Use postQueryDescriptor instead')
const PostQuery$json = const {
  '1': 'PostQuery',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'gid', '3': 6, '4': 1, '5': 9, '10': 'gid'},
  ],
};

/// Descriptor for `PostQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postQueryDescriptor = $convert.base64Decode('CglQb3N0UXVlcnkSDgoCaWQYASABKAVSAmlkEhYKBmF1dGhvchgCIAEoCVIGYXV0aG9yEhAKA2dpZBgGIAEoCVIDZ2lk');
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
