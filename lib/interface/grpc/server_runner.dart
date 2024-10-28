import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart' as grpc;
import './generated/server.pbgrpc.dart';
import 'package:submission/widget/widget_manager.dart';


class Listener extends ListenerServiceBase {
  @override
  Future<ReturnData> listenStream(grpc.ServiceCall call, Stream<MessageData> request) async {
    try {
      await for (var message in request) {
        WidgetManager.generate(
          {
            'command': message.command,
            'name': message.name,
            'value': message.value,
          }
        );
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
    return ReturnData()..ret = 1;
  }
}
