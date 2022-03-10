///
//  Generated code. Do not modify.
//  source: image.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use imageChunkDescriptor instead')
const ImageChunk$json = const {
  '1': 'ImageChunk',
  '2': const [
    const {'1': 'imagedata', '3': 1, '4': 1, '5': 9, '10': 'imagedata'},
    const {'1': 'imagesize', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'imagesize', '17': true},
    const {'1': 'username', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'username', '17': true},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'id', '17': true},
  ],
  '8': const [
    const {'1': '_imagesize'},
    const {'1': '_username'},
    const {'1': '_id'},
  ],
};

/// Descriptor for `ImageChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageChunkDescriptor = $convert.base64Decode('CgpJbWFnZUNodW5rEhwKCWltYWdlZGF0YRgBIAEoCVIJaW1hZ2VkYXRhEiEKCWltYWdlc2l6ZRgCIAEoBUgAUglpbWFnZXNpemWIAQESHwoIdXNlcm5hbWUYAyABKAlIAVIIdXNlcm5hbWWIAQESEwoCaWQYBCABKAlIAlICaWSIAQFCDAoKX2ltYWdlc2l6ZUILCglfdXNlcm5hbWVCBQoDX2lk');
@$core.Deprecated('Use ackDescriptor instead')
const Ack$json = const {
  '1': 'Ack',
  '2': const [
    const {'1': 'imagesize', '3': 1, '4': 1, '5': 9, '10': 'imagesize'},
    const {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'imageurl', '3': 3, '4': 1, '5': 9, '10': 'imageurl'},
  ],
};

/// Descriptor for `Ack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackDescriptor = $convert.base64Decode('CgNBY2sSHAoJaW1hZ2VzaXplGAEgASgJUglpbWFnZXNpemUSGAoHc3VjY2VzcxgCIAEoCFIHc3VjY2VzcxIaCghpbWFnZXVybBgDIAEoCVIIaW1hZ2V1cmw=');
@$core.Deprecated('Use imageQueryDescriptor instead')
const ImageQuery$json = const {
  '1': 'ImageQuery',
  '2': const [
    const {'1': 'author', '3': 1, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
  ],
};

/// Descriptor for `ImageQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageQueryDescriptor = $convert.base64Decode('CgpJbWFnZVF1ZXJ5EhYKBmF1dGhvchgBIAEoCVIGYXV0aG9yEg4KAmlkGAIgASgJUgJpZBI0CgdjcmVhdGVkGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZA==');
