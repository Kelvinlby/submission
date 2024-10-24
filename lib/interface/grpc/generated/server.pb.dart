//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MessageData extends $pb.GeneratedMessage {
  factory MessageData({
    $core.int? command,
    $core.String? name,
    $core.double? value,
  }) {
    final $result = create();
    if (command != null) {
      $result.command = command;
    }
    if (name != null) {
      $result.name = name;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  MessageData._() : super();
  factory MessageData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageData', package: const $pb.PackageName(_omitMessageNames ? '' : 'server'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'command', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageData clone() => MessageData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageData copyWith(void Function(MessageData) updates) => super.copyWith((message) => updates(message as MessageData)) as MessageData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageData create() => MessageData._();
  MessageData createEmptyInstance() => create();
  static $pb.PbList<MessageData> createRepeated() => $pb.PbList<MessageData>();
  @$core.pragma('dart2js:noInline')
  static MessageData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageData>(create);
  static MessageData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get command => $_getIZ(0);
  @$pb.TagNumber(1)
  set command($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => clearField(3);
}

class ReturnData extends $pb.GeneratedMessage {
  factory ReturnData({
    $core.int? ret,
  }) {
    final $result = create();
    if (ret != null) {
      $result.ret = ret;
    }
    return $result;
  }
  ReturnData._() : super();
  factory ReturnData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReturnData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReturnData', package: const $pb.PackageName(_omitMessageNames ? '' : 'server'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'ret', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReturnData clone() => ReturnData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReturnData copyWith(void Function(ReturnData) updates) => super.copyWith((message) => updates(message as ReturnData)) as ReturnData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReturnData create() => ReturnData._();
  ReturnData createEmptyInstance() => create();
  static $pb.PbList<ReturnData> createRepeated() => $pb.PbList<ReturnData>();
  @$core.pragma('dart2js:noInline')
  static ReturnData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReturnData>(create);
  static ReturnData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get ret => $_getIZ(0);
  @$pb.TagNumber(1)
  set ret($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRet() => $_has(0);
  @$pb.TagNumber(1)
  void clearRet() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
