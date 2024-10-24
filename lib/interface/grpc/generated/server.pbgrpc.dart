//
//  Generated code. Do not modify.
//  source: server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'server.pb.dart' as $0;

export 'server.pb.dart';

@$pb.GrpcServiceName('server.Listener')
class ListenerClient extends $grpc.Client {
  static final _$listenStream = $grpc.ClientMethod<$0.MessageData, $0.ReturnData>(
      '/server.Listener/ListenStream',
      ($0.MessageData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ReturnData.fromBuffer(value));

  ListenerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ReturnData> listenStream($async.Stream<$0.MessageData> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$listenStream, request, options: options).single;
  }
}

@$pb.GrpcServiceName('server.Listener')
abstract class ListenerServiceBase extends $grpc.Service {
  $core.String get $name => 'server.Listener';

  ListenerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MessageData, $0.ReturnData>(
        'ListenStream',
        listenStream,
        true,
        false,
        ($core.List<$core.int> value) => $0.MessageData.fromBuffer(value),
        ($0.ReturnData value) => value.writeToBuffer()));
  }

  $async.Future<$0.ReturnData> listenStream($grpc.ServiceCall call, $async.Stream<$0.MessageData> request);
}
