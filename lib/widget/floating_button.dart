import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission/interface/process_manager.dart';
import 'package:submission/widget/widget_manager.dart';


Map<String, Map<String, TextEditingController>> paramController = {};


class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}


class _FloatingButtonState extends State<FloatingButton> {
  bool _launched = false;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final processManager = ProcessManager();

  void _stop() async {
    await processManager.stop();

    setState(() {
      _launched = false;
    });
  }

  void _launch() async {
    Map<String, TextEditingController>? modelController = paramController['model'];
    Map<String, TextEditingController>? trainerController = paramController['train'];
    Map<String, Map<String, dynamic>> param= {};
    Map<String, dynamic> modelParam = {};
    Map<String, dynamic> trainerParam = {};
    String jsonString;
    File configFile;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? interpreterPath = prefs.getString('Path to Interpreter');
    String? configPath = prefs.getString('Path to Config');
    String? trainerPath = prefs.getString('Path to Trainer');

    if(modelController != null && trainerController != null) {
      for(String param in modelController.keys) {
        TextEditingController? controller = modelController[param];

        if(controller != null) {
          String input = controller.text;
          Object value;

          if(input.contains(".")) {
            value = double.tryParse(input) ?? input;
          }
          else {
            value = int.tryParse(input) ?? input;
          }

          modelParam[param] = value;
        }
      }

      for(String param in trainerController.keys) {
        TextEditingController? controller = trainerController[param];

        if(controller != null) {
          String input = controller.text;
          Object value;

          if(input.contains(".")) {
            value = double.tryParse(input) ?? input;
          }
          else {
            value = int.tryParse(input) ?? input;
          }

          trainerParam[param] = value;
        }
      }

      param['model'] = modelParam;
      param['train'] = trainerParam;

      jsonString = jsonEncode(param);

      if(configPath != null) {
        configFile = File(configPath);
        configFile.writeAsString(jsonString);
      }

      if(interpreterPath != null && trainerPath != null) {
        WidgetManager.reset();
        processManager.start(interpreterPath, trainerPath, finish: _stop, error: _alert).then((bool result){});
      }

      setState(() {
        _elapsedSeconds = 0;
        _launched = true;
      });
    }
  }

  void _alert(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SelectableText(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              autofocus: true,
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatElapsedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int secondsRemaining = seconds % 60;
    int minutesRemaining = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutesRemaining.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_launched) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _launched
    ? FloatingActionButton.extended(
        onPressed: _stop,
        tooltip: 'Stop',
        label: Text(
          _formatElapsedTime(_elapsedSeconds),
          style: const TextStyle(fontFamily: 'JetBrains Mono Bold'),
        ),
        icon: const Icon(Icons.pause),
      )
    : FloatingActionButton(
        onPressed: _launch,
        tooltip: 'Launch',
        child: const Icon(Icons.play_arrow),
      );
}
