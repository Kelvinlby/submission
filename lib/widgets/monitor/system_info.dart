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

  // Line chart config
  double xValue = 0;
  double step = 0.05;
  final limitCount = 100;
  final ramPoints = <FlSpot>[];
  final vramPoints = <FlSpot>[];
  final gpuPoints = <FlSpot>[];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (ramPoints.length > limitCount) {
        ramPoints.removeAt(0);
        vramPoints.removeAt(0);
        gpuPoints.removeAt(0);
      }

      setState(() {
        cpuInfo = monitor.getCpuInfo();
        gpuInfo = monitor.getGpuInfo();

        ramPoints.add(FlSpot(xValue, cpuInfo['RamUsage']! / 100));
        vramPoints.add(FlSpot(xValue, gpuInfo['VramUsage']! / 100));
        gpuPoints.add(FlSpot(xValue, gpuInfo['GpuUsage']! / 100));
      });

      xValue += step;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  LineChartBarData _ramLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(show: false,),
      gradient: LinearGradient(
        colors: [Color(0xFF2196F3).withOpacity(0), Color(0xFF2196F3)],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 512,
      height: 256,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 1,
          minX: ramPoints.first.x,
          maxX: ramPoints.last.x,
          lineTouchData: const LineTouchData(enabled: false),
          clipData: const FlClipData.all(),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _ramLine(ramPoints),
          ],
          titlesData: const FlTitlesData(
            show: false,
          ),
        )
      )
    );
  }
}
