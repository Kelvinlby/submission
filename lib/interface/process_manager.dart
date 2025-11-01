import 'dart:async';
import 'dart:io';
import 'dart:convert';
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
  IOSink? _logSink;
  File? _logFile;
  GpuMonitor monitor = GpuMonitor();

  Future<bool> start(String interpreterPath, String scriptPath, {Function? finish, Function? error, double xlaPercentage = 80.0}) async {
    Map<String, int> info = monitor.getGpuInfo();
    
    try {
      await stop();

      // Create log file before starting process
      await _createLogFile(scriptPath);

      _process = await Process.start(
        interpreterPath,
        ['-u', scriptPath],
        environment: arg.contains('-xla')
          ? getXlaEnvironmentVars(info, xlaPercentage)
          : {'PYTHONUNBUFFERED': '1'},
        workingDirectory: Directory(scriptPath).parent.path,
      );

      // Set up output handling with logging
      _stdoutSubscription = _process?.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) async {
            await _writeToLog('STDOUT', line);
          },
          onError: (error) async {
            await _writeToLog('STDOUT_ERROR', error.toString());
          });

      _stderrSubscription = _process?.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) async {
            await _writeToLog('STDERR', line);
            error?.call(line);
          },
          onError: (error) async {
            await _writeToLog('STDERR_ERROR', error.toString());
          });

      // Set up process exit handling
      _process?.exitCode.then((code) async {
        await _writeToLog('PROCESS', 'Exited with code: $code');
        finish?.call();
        _cleanup();
      }).catchError((error) async {
        await _writeToLog('PROCESS_ERROR', 'Process error: $error');
        _cleanup();
      });

      return true;
    }
    catch (e) {
      await _writeToLog('STARTUP_ERROR', 'Failed to start process: $e');
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
    
    // Close log file
    if (_logSink != null) {
      _logSink!.writeln('=== Training Log Ended at ${DateTime.now().toIso8601String()} ===');
      await _logSink!.close();
      _logSink = null;
      _logFile = null;
    }
  }

  bool get isRunning => _process != null;

  String get logFilePath => _logFile?.path ?? '';

  Future<void> _createLogFile(String scriptPath) async {
    final scriptDir = Directory(scriptPath).parent;
    final logDir = Directory('${scriptDir.path}/log');
    
    // Create log directory if it doesn't exist
    if (!await logDir.exists()) {
      await logDir.create();
    }
    
    // Generate log file name with timestamp
    final now = DateTime.now();
    final timestamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    final logFileName = '$timestamp.log';
    
    _logFile = File('${logDir.path}/$logFileName');
    _logSink = _logFile!.openWrite(mode: FileMode.append);
    
    // Write header to log file
    _logSink!.writeln('=== Training Log Started at ${now.toIso8601String()} ===');
    _logSink!.writeln('Script: $scriptPath');
    _logSink!.writeln('=== Output ===');
    await _logSink!.flush();
  }

  Future<void> _writeToLog(String source, String message) async {
    if (_logSink != null) {
      final timestamp = DateTime.now().toIso8601String();
      _logSink!.writeln('[$timestamp][$source] $message');
      await _logSink!.flush();
    }
  }
}