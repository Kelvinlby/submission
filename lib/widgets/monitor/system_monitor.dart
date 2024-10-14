import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class MonitorCard extends StatefulWidget {
  const MonitorCard({super.key});

  @override
  State<MonitorCard> createState() => _MonitorCardState();
}


class _MonitorCardState extends State<MonitorCard> {
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
          // TODO update UI
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('RAM Monitor');
  }
}
