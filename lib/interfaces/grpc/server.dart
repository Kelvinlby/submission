import 'dart:io';
import 'dart:core';


class Server {
  static bool _launched = false;

  static Future<void> launch() async {
    // TODO launch server
    print('Server Launched!');
    _launched = true;
  }

  static Future<void> stop() async {
    // TODO stop server
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
