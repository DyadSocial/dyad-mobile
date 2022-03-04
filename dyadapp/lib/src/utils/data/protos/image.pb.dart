///
//  Generated code. Do not modify.
//  source: image.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum ImageChunk_MetadataOrBytes {
  imageData, 
  auth, 
  notSet
}

class ImageChunk extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ImageChunk_MetadataOrBytes> _ImageChunk_MetadataOrBytesByTag = {
    1 : ImageChunk_MetadataOrBytes.imageData,
    2 : ImageChunk_MetadataOrBytes.auth,
    0 : ImageChunk_MetadataOrBytes.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ImageChunk', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageData', $pb.PbFieldType.OY, protoName: 'imageData')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'auth')
    ..hasRequiredFields = false
  ;

  ImageChunk._() : super();
  factory ImageChunk({
    $core.List<$core.int>? imageData,
    $core.String? auth,
  }) {
    final _result = create();
    if (imageData != null) {
      _result.imageData = imageData;
    }
    if (auth != null) {
      _result.auth = auth;
    }
    return _result;
  }
  factory ImageChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageChunk clone() => ImageChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageChunk copyWith(void Function(ImageChunk) updates) => super.copyWith((message) => updates(message as ImageChunk)) as ImageChunk; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ImageChunk create() => ImageChunk._();
  ImageChunk createEmptyInstance() => create();
  static $pb.PbList<ImageChunk> createRepeated() => $pb.PbList<ImageChunk>();
  @$core.pragma('dart2js:noInline')
  static ImageChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageChunk>(create);
  static ImageChunk? _defaultInstance;

  ImageChunk_MetadataOrBytes whichMetadataOrBytes() => _ImageChunk_MetadataOrBytesByTag[$_whichOneof(0)]!;
  void clearMetadataOrBytes() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<$core.int> get imageData => $_getN(0);
  @$pb.TagNumber(1)
  set imageData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasImageData() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get auth => $_getSZ(1);
  @$pb.TagNumber(2)
  set auth($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuth() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuth() => clearField(2);
}

class Ack extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Ack', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageSize', protoName: 'imageSize')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..hasRequiredFields = false
  ;

  Ack._() : super();
  factory Ack({
    $core.String? imageSize,
    $core.bool? success,
  }) {
    final _result = create();
    if (imageSize != null) {
      _result.imageSize = imageSize;
    }
    if (success != null) {
      _result.success = success;
    }
    return _result;
  }
  factory Ack.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Ack.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Ack clone() => Ack()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Ack copyWith(void Function(Ack) updates) => super.copyWith((message) => updates(message as Ack)) as Ack; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Ack create() => Ack._();
  Ack createEmptyInstance() => create();
  static $pb.PbList<Ack> createRepeated() => $pb.PbList<Ack>();
  @$core.pragma('dart2js:noInline')
  static Ack getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ack>(create);
  static Ack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imageSize => $_getSZ(0);
  @$pb.TagNumber(1)
  set imageSize($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasImageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageSize() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => clearField(2);
}

