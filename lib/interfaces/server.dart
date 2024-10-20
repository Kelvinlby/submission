import 'dart:io';
import 'dart:core';


class Server {
  static bool _launched = false;

  static void launch() async {
    // TODO launch gRPC server here
    print('Server Launched!');
    _launched = true;
  }

  static void stop() {
    // TODO stop gRPC server here
    print('Server Stopped!');
    _launched = false;
  }

  static bool getLaunchState() => _launched;

  static Future<String?> listen() async {
    if(!_launched) {
      return null;
    }

    print('Server Listening!');
    // TODO receive data
    sleep(Duration(seconds:1));

    return 'data';
  }
}
