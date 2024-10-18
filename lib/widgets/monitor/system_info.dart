import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/interfaces/gpu_monitor.dart';


class SystemInfoCard extends StatefulWidget {
  const SystemInfoCard({super.key});

  @override
  State<SystemInfoCard> createState() => _SystemInfoCardState();
}


class _SystemInfoCardState extends State<SystemInfoCard> {
  Timer? _timer;
  int sss = 0;
  Map<String, int> cpuInfo = {'TotalRam': 0, 'UsedRam': 0, 'RamUsage': 0};
  Map<String, int> gpuInfo = {'GpuUsage': 0, 'TotalVram': 0, 'UsedVram': 0, 'VramUsage': 0};
  GpuMonitor monitor = GpuMonitor();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        cpuInfo = monitor.getCpuInfo();
        gpuInfo = monitor.getGpuInfo();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${gpuInfo["VramUsage"]}');
    // TODO build chart UI
  }
}
