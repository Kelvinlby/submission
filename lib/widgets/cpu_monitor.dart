import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';


class CpuMonitor extends StatefulWidget {
  const CpuMonitor({super.key});

  @override
  State<CpuMonitor> createState() => _CpuMonitorState();
}


class _CpuMonitorState extends State<CpuMonitor> {
  @override
  Widget build(BuildContext context) {
    return const Text('CPU Monitor');
  }
}
