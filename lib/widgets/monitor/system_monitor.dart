import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/interfaces/system_info.dart';


class MonitorCard extends StatefulWidget {
  const MonitorCard({super.key});

  @override
  State<MonitorCard> createState() => _MonitorCardState();
}


class _MonitorCardState extends State<MonitorCard> {
  Timer? _timer;
  double _cpuUsage = 0.0;


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
          // TODO update UI
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
    return const Text('RAM Monitor');
  }
}
