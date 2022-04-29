///
//  Generated code. Do not modify.
//  source: count.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Count extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Count', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Count._() : super();
  factory Count({
    $core.int? count,
  }) {
    final _result = create();
    if (count != null) {
      _result.count = count;
    }
    return _result;
  }
  factory Count.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Count.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Count clone() => Count()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Count copyWith(void Function(Count) updates) => super.copyWith((message) => updates(message as Count)) as Count; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Count create() => Count._();
  Count createEmptyInstance() => create();
  static $pb.PbList<Count> createRepeated() => $pb.PbList<Count>();
  @$core.pragma('dart2js:noInline')
  static Count getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Count>(create);
  static Count? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);
}

class ActiveQuery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ActiveQuery', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requestor')
    ..hasRequiredFields = false
  ;

  ActiveQuery._() : super();
  factory ActiveQuery({
    $core.String? requestor,
  }) {
    final _result = create();
    if (requestor != null) {
      _result.requestor = requestor;
    }
    return _result;
  }
  factory ActiveQuery.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActiveQuery.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActiveQuery clone() => ActiveQuery()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActiveQuery copyWith(void Function(ActiveQuery) updates) => super.copyWith((message) => updates(message as ActiveQuery)) as ActiveQuery; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ActiveQuery create() => ActiveQuery._();
  ActiveQuery createEmptyInstance() => create();
  static $pb.PbList<ActiveQuery> createRepeated() => $pb.PbList<ActiveQuery>();
  @$core.pragma('dart2js:noInline')
  static ActiveQuery getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActiveQuery>(create);
  static ActiveQuery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestor => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestor($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestor() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestor() => clearField(1);
}

