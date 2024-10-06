import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';


double getRamUsage() => 1 - (SysInfo.getFreeVirtualMemory() + SysInfo.getFreePhysicalMemory()) / (SysInfo.getTotalVirtualMemory() + SysInfo.getTotalPhysicalMemory());


class RamMonitor extends StatefulWidget {
  const RamMonitor({super.key});

  @override
  State<RamMonitor> createState() => _RamMonitorState();
}


class _RamMonitorState extends State<RamMonitor> {
  @override
  Widget build(BuildContext context) {
    return const Text('CPU Monitor');
  }
}
