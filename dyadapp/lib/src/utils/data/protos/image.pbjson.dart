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
    const {'1': 'auth', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'auth'},
  ],
  '8': const [
    const {'1': 'MetadataOrBytes'},
  ],
};

/// Descriptor for `ImageChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageChunkDescriptor = $convert.base64Decode('CgpJbWFnZUNodW5rEh4KCWltYWdlRGF0YRgBIAEoDEgAUglpbWFnZURhdGESFAoEYXV0aBgCIAEoCUgAUgRhdXRoQhEKD01ldGFkYXRhT3JCeXRlcw==');
@$core.Deprecated('Use ackDescriptor instead')
const Ack$json = const {
  '1': 'Ack',
  '2': const [
    const {'1': 'imageSize', '3': 1, '4': 1, '5': 9, '10': 'imageSize'},
    const {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `Ack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackDescriptor = $convert.base64Decode('CgNBY2sSHAoJaW1hZ2VTaXplGAEgASgJUglpbWFnZVNpemUSGAoHc3VjY2VzcxgCIAEoCFIHc3VjY2Vzcw==');
