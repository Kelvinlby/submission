import 'dart:ffi' as ffi;


typedef NativeUint8Function = ffi.Uint8 Function();
typedef NativeUint64Function = ffi.Uint64 Function();

typedef DartIntFunction = int Function();


class GpuMonitor {
  static final ffi.DynamicLibrary _lib = ffi.DynamicLibrary.open('/mnt/Data/Code/Flutter/submission/lib/interfaces/libGpuMonitor.so');
  int _platformCode = 0;

  // CPU
  final DartIntFunction _platform = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getPlatform').asFunction<DartIntFunction>();
  final DartIntFunction _totalRam = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getTotalRam').asFunction<DartIntFunction>();
  final DartIntFunction _freeRam  = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getFreeRam').asFunction<DartIntFunction>();
  final DartIntFunction _ramUsage = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getRamUsage').asFunction<DartIntFunction>();

  // Nvidia GPU
  final DartIntFunction _nvidiaTotalVram = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaTotalVram').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaUsedVram  = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaUsedVram').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaVramUsage = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaVramUsage').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaGpuUsage  = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaGpuUsage').asFunction<DartIntFunction>();

  // AMD GPU
  
  GpuMonitor() {
    _platformCode = _platform();
  }

  Map<String, int> getCpuInfo() => {'TotalRam': _totalRam(), 'UsedRam': _totalRam() - _freeRam(), 'RamUsage': _ramUsage()};

  Map<String, int> getGpuInfo() {
    Map<String, int> info = {
      'GpuUsage': 0,
      'TotalVram': 0,
      'UsedVram': 0,
      'VramUsage': 0
    };

    if(_platformCode == 1) {    // Nvidia GPU
      info = {
        'GpuUsage': _nvidiaGpuUsage(),
        'TotalVram': _nvidiaTotalVram(),
        'UsedVram': _nvidiaUsedVram(),
        'VramUsage': _nvidiaVramUsage()
      };
    }
    else if(_platformCode == 2) {   // AMD GPU
      info = {
        'GpuUsage': 0,
        'TotalVram': 0,
        'UsedVram': 0,
        'VramUsage': 0
      };
    }

    return info;
  }
}
