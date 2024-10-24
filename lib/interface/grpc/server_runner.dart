import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart' as grpc;
import './generated/server.pbgrpc.dart';


class Listener extends ListenerServiceBase {
  int callCount = 0;
  final List<Map<String, dynamic>> _messageBuff = [];
  bool _isReady = false;

  @override
  Future<ReturnData> listenStream(grpc.ServiceCall call, Stream<MessageData> request) async {
    if (_isReady) {
      try {
        await for (var message in request) {
          _isReady = false;
          _messageBuff.add(
            {
              'command': message.command,
              'name': message.name,
              'value': message.value,
            }
          );
          sleep(Duration(milliseconds: 10));
          _isReady = true;
        }
      }
      catch (error) {
        rethrow;
      }
      finally {
        if (call.isCanceled) {
          throw('listen data: call canceled');
        }
      }
    }
    else {
      throw('Loading data...');
    }
    return ReturnData()..ret = 1;
  }

  List<Map<String, dynamic>>? messageGetAndClear() {
    if (_isReady) {
      _isReady = false;

      final List<Map<String, dynamic>> buff = _messageBuff;
      _messageBuff.clear();

      sleep(Duration(milliseconds: 10));

      _isReady = true;
      return buff;
    }
    else {
      return null;
    }
  }

}
