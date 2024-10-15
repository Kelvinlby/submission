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
  double _ramUsage = 0.0;
  double _vramUsage = 0.0;
  double _gpuUsage = 0.0;


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
          // TODO get system info here
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
    return const Text('System Info Monitor');
  }
}
