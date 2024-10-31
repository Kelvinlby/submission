import 'dart:async';
import 'dart:io';

import 'package:submission/interface/gpu_monitor.dart';
import 'package:submission/main.dart';


typedef ProcessCompletionCallback = void Function();
bool xlaPreAllocatingStatus = true;


class ProcessManager {
  Process? _process;
  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _stderrSubscription;
  ProcessCompletionCallback? _onNaturalCompletion;
  GpuMonitor monitor = GpuMonitor();

  Future<bool> start(String interpreterPath, String scriptPath, {ProcessCompletionCallback? callback}) async {
    Map<String, int> info = monitor.getGpuInfo();
    
    try {
      await stop();
      _onNaturalCompletion = callback;

      // Start the process with proper environment setup
      _process = await Process.start(
        interpreterPath,
        ['-u', scriptPath],
        environment: arg.contains('-xla')
          ? xlaPreAllocatingStatus
              ? {
                  'PYTHONUNBUFFERED': '1',  // Disable Python output buffering
                  'XLA_PYTHON_CLIENT_MEM_FRACTION': '.${98 - (info['VramUsage'] ?? 5)}' // XLA pre-allocation config
                }
              : {
                  'PYTHONUNBUFFERED': '1',  // Disable Python output buffering
                  'XLA_PYTHON_CLIENT_MEM_FRACTION': '.${98 - (info['VramUsage'] ?? 5)}', // XLA pre-allocation config
                  'XLA_PYTHON_CLIENT_ALLOCATOR': 'platform'
                }
          : {
              'PYTHONUNBUFFERED': '1',  // Disable Python output buffering
            },
        workingDirectory: Directory(scriptPath).parent.path,
      );

      // Set up output handling
      _stdoutSubscription = _process?.stdout.listen((data) {
          // print('Python stderr: ${String.fromCharCodes(data)}');
        },
        onError: (error) {} // print('stdout error: $error'),
      );

      _stderrSubscription = _process?.stderr.listen((data) {
          // print('Python stderr: ${String.fromCharCodes(data)}');
        },
        onError: (error) {} // print('stderr error: $error'),
      );

      // Set up process exit handling
      _process?.exitCode.then((code) {
        _onNaturalCompletion?.call();
        // print('Process exited with code: $code');
        _cleanup();
      }).catchError((error) {
        // print('Process error: $error');
        _cleanup();
      });

      return true;
    }
    catch (e) {
      // print('Failed to start process: $e');
      await _cleanup();
      return false;
    }
  }

  Future<void> stop() async {
    await _cleanup();
  }

  Future<void> _cleanup() async {
    await _stdoutSubscription?.cancel();
    await _stderrSubscription?.cancel();
    _process?.kill();
    _process = null;
  }

  bool get isRunning => _process != null;
}