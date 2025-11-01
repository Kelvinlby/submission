import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission/interface/process_manager.dart';


Map<String, Map<String, TextEditingController>> paramController = {};

// XLA Memory allocation percentage (0-100)
double xlaMemoryPercentage = 80.0;


// Helper function to parse string back to appropriate JSON type
dynamic _parseValue(String input) {
  if (input.isEmpty) {
    return '';
  }
  
  // Handle null
  if (input.toLowerCase() == 'null') {
    return null;
  }
  
  // Handle boolean
  if (input.toLowerCase() == 'true') {
    return true;
  }
  if (input.toLowerCase() == 'false') {
    return false;
  }
  
  // Handle numbers
  if (RegExp(r'^-?\d+$').hasMatch(input)) {
    // Integer
    return int.tryParse(input) ?? input;
  }
  
  if (RegExp(r'^-?\d+\.\d+$').hasMatch(input)) {
    // Double
    return double.tryParse(input) ?? input;
  }
  
  // Try to parse as JSON (for complex objects/arrays)
  try {
    return jsonDecode(input);
  } catch (e) {
    // If it's not valid JSON, treat as string
    return input;
  }
}


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
    Map<String, Map<String, dynamic>> param = {};
    String jsonString;
    File configFile;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? interpreterPath = prefs.getString('Path to Interpreter');
    String? configPath = prefs.getString('Path to Config');
    String? trainerPath = prefs.getString('Path to Trainer');

    // Check if we have any parameter controllers
    if(paramController.isNotEmpty) {
      // Process all sections dynamically
      for(String sectionId in paramController.keys) {
        Map<String, TextEditingController>? sectionController = paramController[sectionId];
        Map<String, dynamic> sectionParam = {};
        
        if(sectionController != null) {
          for(String paramName in sectionController.keys) {
            TextEditingController? controller = sectionController[paramName];

            if(controller != null) {
              String input = controller.text.trim();
              dynamic value = _parseValue(input);
              sectionParam[paramName] = value;
            }
          }
          
          param[sectionId] = sectionParam;
        }
      }

      jsonString = jsonEncode(param);

      if(configPath != null) {
        configFile = File(configPath);
        configFile.writeAsString(jsonString);
      }

      if(interpreterPath != null && trainerPath != null) {
        processManager.start(interpreterPath, trainerPath, finish: _stop, error: _alert, xlaPercentage: xlaMemoryPercentage).then((bool result){});
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
