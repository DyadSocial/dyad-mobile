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
    const {'1': 'imageData', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'imageData'},
    const {'1': 'size', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'size'},
  ],
  '8': const [
    const {'1': 'MetadataOrBytes'},
  ],
  '9': const [
    const {'1': 2, '2': 3},
  ],
};

/// Descriptor for `ImageChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageChunkDescriptor = $convert.base64Decode('CgpJbWFnZUNodW5rEh4KCWltYWdlRGF0YRgBIAEoDEgAUglpbWFnZURhdGESFAoEc2l6ZRgDIAEoA0gAUgRzaXplQhEKD01ldGFkYXRhT3JCeXRlc0oECAIQAw==');
@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = const {
  '1': 'Metadata',
  '2': const [
    const {'1': 'size', '3': 1, '4': 1, '5': 3, '10': 'size'},
    const {'1': 'id', '3': 2, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    const {'1': 'created', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode('CghNZXRhZGF0YRISCgRzaXplGAEgASgDUgRzaXplEg4KAmlkGAIgASgFUgJpZBIWCgZhdXRob3IYAyABKAlSBmF1dGhvchI0CgdjcmVhdGVkGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZA==');
@$core.Deprecated('Use ackDescriptor instead')
const Ack$json = const {
  '1': 'Ack',
  '2': const [
    const {'1': 'imageSize', '3': 1, '4': 1, '5': 9, '10': 'imageSize'},
    const {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'ImageURL', '3': 3, '4': 1, '5': 9, '10': 'ImageURL'},
  ],
};

/// Descriptor for `Ack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackDescriptor = $convert.base64Decode('CgNBY2sSHAoJaW1hZ2VTaXplGAEgASgJUglpbWFnZVNpemUSGAoHc3VjY2VzcxgCIAEoCFIHc3VjY2VzcxIaCghJbWFnZVVSTBgDIAEoCVIISW1hZ2VVUkw=');
@$core.Deprecated('Use imageQueryDescriptor instead')
const ImageQuery$json = const {
  '1': 'ImageQuery',
  '2': const [
    const {'1': 'author', '3': 1, '4': 1, '5': 5, '10': 'author'},
    const {'1': 'id', '3': 2, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
  ],
};

/// Descriptor for `ImageQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageQueryDescriptor = $convert.base64Decode('CgpJbWFnZVF1ZXJ5EhYKBmF1dGhvchgBIAEoBVIGYXV0aG9yEg4KAmlkGAIgASgFUgJpZBI0CgdjcmVhdGVkGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZA==');
