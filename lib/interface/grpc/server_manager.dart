import 'dart:io';
import 'dart:core';
import 'server_runner.dart';
import 'package:grpc/grpc.dart' as grpc;


class ServerManager {
  static bool _launched = false;
  static final grpc.Server _server = grpc.Server.create(services: [Record()]);
  static final Record _record = Record as Record;

  static Future<void> launch() async {
    try {
      await _server.serve(port: 50051);
      print('Server Launched!');
      _launched = true;
    } catch (e) {
      if (e is SocketException && e.osError?.errorCode==97) {
        _launched = false;
        throw('Port 50051 already occupied!');
      } else {
        throw(e);
      }
    }
  }

  static Future<void> stop() async {
    await _server.shutdown();
    print('Server Stopped!');
    _launched = false;
  }

  static bool getLaunchState() => _launched;

  static Future<List<dynamic>?> listen() async {
    if(!_launched) {
      return null;
    }

    print('Server Listening!');
    final data = _record.getMessageAndClear();
    sleep(Duration(seconds:1));

    return data;
  }
}
