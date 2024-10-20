import 'dart:io';
import 'dart:core';
import 'package:submission/interfaces/transmitter.dart';


class Server {
  static bool _launched = false;

  static void launch() async {
    // TODO launch gRPC server here
    print('Server Launched!');
    _launched = true;

    _listen().then((code) {});
  }

  static void stop() {
    // TODO stop gRPC server here
    print('Server Stopped!');
    _launched = false;
  }

  static bool getLaunchState() {
    return _launched;
  }

  static Future<int> _listen() async {
    while(_launched) {
      print('Server Listening!');
      // TODO receive data
      sleep(Duration(seconds:1));
      Transmitter.addCommand('cmd');
    }
  }
}
