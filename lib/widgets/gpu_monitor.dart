import 'package:flutter/material.dart';


class GpuMonitor extends StatefulWidget {
  const GpuMonitor({super.key});

  @override
  State<GpuMonitor> createState() => _GpuMonitorState();
}


class _GpuMonitorState extends State<GpuMonitor> {
  @override
  Widget build(BuildContext context) {
    return const Text('GPU Monitor');
  }
}
