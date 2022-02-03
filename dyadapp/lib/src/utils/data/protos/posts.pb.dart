///
//  Generated code. Do not modify.
//  source: posts.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'content.pb.dart' as $0;
import 'google/protobuf/timestamp.pb.dart' as $1;

class Post extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Post', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'author')
    ..aOM<$0.Content>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content', subBuilder: $0.Content.create)
    ..aOM<$1.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastUpdated', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'created', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Post._() : super();
  factory Post({
    $core.int? id,
    $core.String? author,
    $0.Content? content,
    $1.Timestamp? lastUpdated,
    $1.Timestamp? created,
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
  $0.Content get content => $_getN(2);
  @$pb.TagNumber(3)
  set content($0.Content v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);
  @$pb.TagNumber(3)
  $0.Content ensureContent() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Timestamp get lastUpdated => $_getN(3);
  @$pb.TagNumber(4)
  set lastUpdated($1.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastUpdated() => clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureLastUpdated() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Timestamp get created => $_getN(4);
  @$pb.TagNumber(5)
  set created($1.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreated() => clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureCreated() => $_ensure(4);
}

class Feed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Feed', createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipients')
    ..pc<Post>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'posts', $pb.PbFieldType.PM, subBuilder: Post.create)
    ..aOM<$1.Timestamp>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastUpdated', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Feed._() : super();
  factory Feed({
    $core.Iterable<$core.String>? recipients,
    $core.Iterable<Post>? posts,
    $1.Timestamp? lastUpdated,
  }) {
    final _result = create();
    if (recipients != null) {
      _result.recipients.addAll(recipients);
    }
    if (posts != null) {
      _result.posts.addAll(posts);
    }
    if (lastUpdated != null) {
      _result.lastUpdated = lastUpdated;
    }
    return _result;
  }
  factory Feed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Feed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Feed clone() => Feed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Feed copyWith(void Function(Feed) updates) => super.copyWith((message) => updates(message as Feed)) as Feed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Feed create() => Feed._();
  Feed createEmptyInstance() => create();
  static $pb.PbList<Feed> createRepeated() => $pb.PbList<Feed>();
  @$core.pragma('dart2js:noInline')
  static Feed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Feed>(create);
  static Feed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get recipients => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<Post> get posts => $_getList(1);

  @$pb.TagNumber(3)
  $1.Timestamp get lastUpdated => $_getN(2);
  @$pb.TagNumber(3)
  set lastUpdated($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLastUpdated() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastUpdated() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureLastUpdated() => $_ensure(2);
}

