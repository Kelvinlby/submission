//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use messageDataDescriptor instead')
const MessageData$json = {
  '1': 'MessageData',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 5, '10': 'command'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 3, '4': 1, '5': 2, '10': 'value'},
  ],
};

/// Descriptor for `MessageData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDataDescriptor = $convert.base64Decode(
    'CgtNZXNzYWdlRGF0YRIYCgdjb21tYW5kGAEgASgFUgdjb21tYW5kEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSFAoFdmFsdWUYAyABKAJSBXZhbHVl');

@$core.Deprecated('Use returnDataDescriptor instead')
const ReturnData$json = {
  '1': 'ReturnData',
  '2': [
    {'1': 'ret', '3': 1, '4': 1, '5': 13, '10': 'ret'},
  ],
};

/// Descriptor for `ReturnData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnDataDescriptor = $convert.base64Decode(
    'CgpSZXR1cm5EYXRhEhAKA3JldBgBIAEoDVIDcmV0');

