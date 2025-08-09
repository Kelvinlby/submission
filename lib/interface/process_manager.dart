import 'dart:async';
import 'dart:io';
import 'package:submission/interface/gpu_monitor.dart';
import 'package:submission/main.dart';


// Helper function to generate XLA environment variables
Map<String, String> getXlaEnvironmentVars(Map<String, int> gpuInfo, double xlaMemoryPercentage) {
  Map<String, String> env = {'PYTHONUNBUFFERED': '1'};
  
  if (xlaMemoryPercentage == 0.0) {
    // 0% - Use platform allocator (on-demand allocation)
    env['XLA_PYTHON_CLIENT_ALLOCATOR'] = 'platform';
  } else if (xlaMemoryPercentage < 98.0) {
    // <98% - Use specified percentage
    String percentage = '.${xlaMemoryPercentage.round().toString().padLeft(2, '0')}';
    env['XLA_PYTHON_CLIENT_MEM_FRACTION'] = percentage;
  } else {
    // >=98% - Use dynamic calculation based on current VRAM usage
    int dynamicPercentage = 98 - (gpuInfo['VramUsage'] ?? 5);
    String percentage = '.${dynamicPercentage.toString().padLeft(2, '0')}';
    env['XLA_PYTHON_CLIENT_MEM_FRACTION'] = percentage;
  }
  
  return env;
}


class ProcessManager {
  Process? _process;
  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _stderrSubscription;
  GpuMonitor monitor = GpuMonitor();

  Future<bool> start(String interpreterPath, String scriptPath, {Function? finish, Function? error, double xlaPercentage = 80.0}) async {
    Map<String, int> info = monitor.getGpuInfo();
    
    try {
      await stop();

      _process = await Process.start(
        interpreterPath,
        ['-u', scriptPath],
        environment: arg.contains('-xla')
          ? getXlaEnvironmentVars(info, xlaPercentage)
          : {'PYTHONUNBUFFERED': '1'},
        workingDirectory: Directory(scriptPath).parent.path,
      );

      // Set up output handling
      _stdoutSubscription = _process?.stdout.listen((data) {
          // print('Python stdout: ${String.fromCharCodes(data)}');
        },
        onError: (error) {} // print('stdout error: $error'),
      );

      _stderrSubscription = _process?.stderr.listen((data) {
          error?.call(String.fromCharCodes(data));
        },
        onError: (error) {} // print('stderr error: $error'),
      );

      // Set up process exit handling
      _process?.exitCode.then((code) {
        finish?.call();
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