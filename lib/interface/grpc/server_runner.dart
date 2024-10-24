import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart' as grpc;
import './generated/commuincation.pbgrpc.dart';


class Record extends RecordServiceBase {
  int callCount = 0;
  List<Map<String, dynamic>> messageBuff = [];
  bool _isReady = false;

  @override
  Future<ReturnData> listenData(grpc.ServiceCall call, Stream<MessageData> request) async {
    if (_isReady) {
      try {
        await for (var message in request) {
          _isReady = false;
          messageBuff.add(
            {
              'command': message.command,
              'name': message.name,
              'value': message.value,
            }
          );
          sleep(Duration(milliseconds: 10));
          _isReady = true;
        }
      } catch (error) {
        rethrow;
      } finally {
        if (call.isCanceled) {
          throw('listen data: call canceled');
        }
      }
    }
    else {
      throw('Loading data...');
    }
    return ReturnData()
      ..p = 1;
  }

  List<Map<String, dynamic>>? getMessageAndClear() {
    if (_isReady) {
      _isReady = false;

      final List<Map<String, dynamic>> buff = messageBuff;
      messageBuff.clear();

      sleep(Duration(milliseconds: 10));

      _isReady = true;
      return buff;
    }
    else {
      return null;
    }
  }

}
