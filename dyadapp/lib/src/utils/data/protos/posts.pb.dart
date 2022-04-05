///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'content.pb.dart' as $1;
import 'google/protobuf/timestamp.pb.dart' as $2;

class Post extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Post', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'author')
    ..aOM<$1.Content>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content', subBuilder: $1.Content.create)
    ..aOM<$2.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastUpdated', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'created', subBuilder: $2.Timestamp.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'group')
    ..hasRequiredFields = false
  ;

  Post._() : super();
  factory Post({
    $core.int? id,
    $core.String? author,
    $1.Content? content,
    $2.Timestamp? lastUpdated,
    $2.Timestamp? created,
    $core.String? title,
    $core.String? group,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (author != null) {
      _result.author = author;
    }
    if (content != null) {
      _result.content = content;
    }
    if (lastUpdated != null) {
      _result.lastUpdated = lastUpdated;
    }
    if (created != null) {
      _result.created = created;
    }
    if (title != null) {
      _result.title = title;
    }
    if (group != null) {
      _result.group = group;
    }
    return _result;
  }
  factory Post.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Post.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Post clone() => Post()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Post copyWith(void Function(Post) updates) => super.copyWith((message) => updates(message as Post)) as Post; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Post create() => Post._();
  Post createEmptyInstance() => create();
  static $pb.PbList<Post> createRepeated() => $pb.PbList<Post>();
  @$core.pragma('dart2js:noInline')
  static Post getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Post>(create);
  static Post? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  $1.Content get content => $_getN(2);
  @$pb.TagNumber(3)
  set content($1.Content v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);
  @$pb.TagNumber(3)
  $1.Content ensureContent() => $_ensure(2);

  @$pb.TagNumber(4)
  $2.Timestamp get lastUpdated => $_getN(3);
  @$pb.TagNumber(4)
  set lastUpdated($2.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastUpdated() => clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureLastUpdated() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Timestamp get created => $_getN(4);
  @$pb.TagNumber(5)
  set created($2.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreated() => clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureCreated() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get group => $_getSZ(6);
  @$pb.TagNumber(7)
  set group($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => clearField(7);
}

class PostQuery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PostQuery', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'author')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gid')
    ..hasRequiredFields = false
  ;

  PostQuery._() : super();
  factory PostQuery({
    $core.int? id,
    $core.String? author,
    $core.String? gid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (author != null) {
      _result.author = author;
    }
    if (gid != null) {
      _result.gid = gid;
    }
    return _result;
  }
  factory PostQuery.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PostQuery.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PostQuery clone() => PostQuery()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PostQuery copyWith(void Function(PostQuery) updates) => super.copyWith((message) => updates(message as PostQuery)) as PostQuery; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PostQuery create() => PostQuery._();
  PostQuery createEmptyInstance() => create();
  static $pb.PbList<PostQuery> createRepeated() => $pb.PbList<PostQuery>();
  @$core.pragma('dart2js:noInline')
  static PostQuery getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostQuery>(create);
  static PostQuery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(6)
  $core.String get gid => $_getSZ(2);
  @$pb.TagNumber(6)
  set gid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(6)
  $core.bool hasGid() => $_has(2);
  @$pb.TagNumber(6)
  void clearGid() => clearField(6);
}

class PostUploadAck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PostUploadAck', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$2.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'savedTime', subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false
  ;

  PostUploadAck._() : super();
  factory PostUploadAck({
    $core.int? id,
    $2.Timestamp? savedTime,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (savedTime != null) {
      _result.savedTime = savedTime;
    }
    return _result;
  }
  factory PostUploadAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PostUploadAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PostUploadAck clone() => PostUploadAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PostUploadAck copyWith(void Function(PostUploadAck) updates) => super.copyWith((message) => updates(message as PostUploadAck)) as PostUploadAck; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PostUploadAck create() => PostUploadAck._();
  PostUploadAck createEmptyInstance() => create();
  static $pb.PbList<PostUploadAck> createRepeated() => $pb.PbList<PostUploadAck>();
  @$core.pragma('dart2js:noInline')
  static PostUploadAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostUploadAck>(create);
  static PostUploadAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get savedTime => $_getN(1);
  @$pb.TagNumber(2)
  set savedTime($2.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSavedTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearSavedTime() => clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureSavedTime() => $_ensure(1);
}

