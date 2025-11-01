# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Submission is a Flutter desktop application that provides an ML dashboard for managing and monitoring machine learning training processes across any framework. It features a two-panel layout with configuration controls on the left and system monitoring on the right.

## Key Commands

### Development
- `flutter run` - Run the application in development mode
- `flutter run -d linux` - Run specifically on Linux 
- `flutter run -d macos` - Run specifically on macOS
- `flutter run -d windows` - Run specifically on Windows
- `flutter analyze` - Run static analysis and linting
- `flutter test` - Run widget tests

### Building
- `flutter build linux` - Build Linux executable
- `flutter build macos` - Build macOS app bundle
- `flutter build windows` - Build Windows executable

### Dependencies
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies

## Architecture

### Core Components

**Main Application Structure:**
- `lib/main.dart` - Entry point with `MyApp` and `HomePage` widgets
- `lib/panel.dart` - Left configuration panel with file pickers for interpreter, config, and trainer paths
- `lib/monitor.dart` - Right monitoring panel wrapper
- `lib/widget/floating_button.dart` - Floating action button for additional controls

**Key Features:**
1. **Configuration Panel** (`lib/panel.dart`):
   - File picker for Python interpreter path with Conda environment detection
   - JSON config file selection for ML model and training parameters
   - Python trainer script selection
   - Dynamic config cards for model and training parameter visualization

2. **System Monitoring** (`lib/widget/monitor/system_info.dart`):
   - Real-time CPU and GPU monitoring
   - Memory usage tracking for both system RAM and GPU VRAM

3. **Native System Integration:**
   - `lib/interface/gpu_monitor.dart` - FFI interface to `/usr/local/lib/submission/libGpuMonitor.so` for hardware monitoring
   - `lib/interface/process_manager.dart` - Python process execution with XLA preallocation control

### Data Flow

1. User selects interpreter, config JSON, and trainer Python file via Panel
2. Configuration parameters are stored in SharedPreferences
3. Config JSON is parsed to display model and training parameters in expandable cards
4. Process manager launches Python training with environment variables for XLA optimization
5. GPU monitor provides real-time hardware stats via native library

### Special Features

- **XLA Integration**: Launch with `-xla` flag to enable TensorFlow XLA preallocation control
- **Conda Detection**: Automatically detects and displays Conda environment names from interpreter paths
- **Cross-platform**: Supports Linux, macOS, and Windows with platform-specific build configurations

### Dependencies

Key packages:
- `file_picker` - File selection dialogs
- `shared_preferences` - Persistent configuration storage  
- `fl_chart` - Charting and data visualization
- `grpc`/`protobuf` - Communication with Python ML processes
- Native FFI for hardware monitoring integration

### Platform-specific Notes

- Linux build requires native GPU monitoring library at `/usr/local/lib/submission/libGpuMonitor.so`
- Supports both NVIDIA and AMD GPU monitoring
- Uses CMake for native library integration on Linux and Windows