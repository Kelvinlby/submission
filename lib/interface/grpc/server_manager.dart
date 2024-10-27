import 'dart:io';
import 'dart:core';
import 'server_runner.dart';
import 'package:grpc/grpc.dart' as grpc;


class ServerManager {
  static bool _launched = false;
  static grpc.Server? _server;

  static Future<void> launch() async {
    _server = grpc.Server.create(services: [Listener()]);

    try {
      await _server?.serve(port: 50051);
      _launched = true;
    } catch (e) {
      if (e is SocketException && e.osError?.errorCode==97) {
        _launched = false;
        throw('Port 50051 already occupied!');
      } else {
        rethrow;
      }
    }
  }

  static Future<void> stop() async {
    await _server?.shutdown();
    _launched = false;
  }

  static bool getLaunchState() => _launched;
}
