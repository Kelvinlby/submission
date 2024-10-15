import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;


typedef NativeUint8Function = ffi.Uint8 Function();
typedef NativeUint64Function = ffi.Uint64 Function();

typedef DartIntFunction = int Function();


class GpuMonitor {
  static final ffi.DynamicLibrary _lib = ffi.DynamicLibrary.open('/mnt/Data/Code/Flutter/submission/lib/interfaces/libGpuMonitor.so');
  int _platformCode = 0;

  // CPU
  final DartIntFunction _platform = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getPlatform').asFunction<DartIntFunction>();
  final DartIntFunction _totalRam = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getTotalRam').asFunction<DartIntFunction>();
  final DartIntFunction _freeRam = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getFreeRam').asFunction<DartIntFunction>();
  final DartIntFunction _ramUsage = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getRamUsage').asFunction<DartIntFunction>();

  // Nvidia GPU
  final DartIntFunction _nvidiaTotalVram = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaTotalVram').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaFreeVram = _lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaFreeVram').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaVramUsage = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaVramUsage').asFunction<DartIntFunction>();
  final DartIntFunction _nvidiaGpuUsage = _lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaGpuUsage').asFunction<DartIntFunction>();

  // AMD GPU
  /* Waiting for ECHO-HELLO-WORLD */
  
  GpuMonitor() {
    _platformCode = _platform();
  }

  double test() {
    return 1.23;
  }
}
