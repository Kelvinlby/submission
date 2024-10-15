import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;


typedef NativeUint8Function = ffi.Uint8 Function();
typedef NativeUint64Function = ffi.Uint64 Function();

typedef DartIntFunction = int Function();


class GpuMonitor {
  static final ffi.DynamicLibrary lib = ffi.DynamicLibrary.open('/mnt/Data/Code/Flutter/submission/lib/interfaces/libGpuMonitor.so');

  // CPU
  DartIntFunction platform = lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getPlatform').asFunction<DartIntFunction>();
  DartIntFunction totalRam = lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getTotalRam').asFunction<DartIntFunction>();
  DartIntFunction freeRam = lib.lookup<ffi.NativeFunction<NativeUint64Function>>('getFreeRam').asFunction<DartIntFunction>();
  DartIntFunction ramUsage = lib.lookup<ffi.NativeFunction<NativeUint8Function>>('getRamUsage').asFunction<DartIntFunction>();

  // Nvidia GPU
  DartIntFunction nvidiaTotalVram = lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaTotalVram').asFunction<DartIntFunction>();
  DartIntFunction nvidiaFreeVram = lib.lookup<ffi.NativeFunction<NativeUint64Function>>('nvidiaFreeVram').asFunction<DartIntFunction>();
  DartIntFunction nvidiaVramUsage = lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaVramUsage').asFunction<DartIntFunction>();
  DartIntFunction nvidiaGpuUsage = lib.lookup<ffi.NativeFunction<NativeUint8Function>>('nvidiaGpuUsage').asFunction<DartIntFunction>();

  // AMD GPU
  /* Waiting for ECHO-HELLO-WORLD */

  static double getGun() {
    return 2.5;
  }
}
