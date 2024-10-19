import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/interfaces/gpu_monitor.dart';
import 'package:submission/widgets/monitor/monitor_title.dart';


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
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      while (ramPoints.length > limitCount) {
        ramPoints.removeAt(0);
        vramPoints.removeAt(0);
        gpuPoints.removeAt(0);
      }

      setState(() {
        cpuInfo = monitor.getCpuInfo();
        gpuInfo = monitor.getGpuInfo();

        ramPoints.add(FlSpot(xValue, 0.05));// cpuInfo['RamUsage']! / 100));
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
      dotData: const FlDotData(show: false),
      gradient: LinearGradient(
        colors: [Colors.cyan.withOpacity(0), Colors.cyan],
        stops: const [0.1, 1.0],
      ),
      barWidth: 2,
      isCurved: false,
    );
  }

  LineChartBarData _vramLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(show: false),
      gradient: LinearGradient(
        colors: [Colors.orange.withOpacity(0), Colors.orange],
        stops: const [0.1, 1.0],
      ),
      barWidth: 2,
      isCurved: false,
    );
  }

  LineChartBarData _gpuLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(show: false),
      gradient: LinearGradient(
        colors: [Colors.pinkAccent.withOpacity(0), Colors.pinkAccent],
        stops: const [0.1, 1.0],
      ),
      barWidth: 2,
      isCurved: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    NumberTitle(
                      title: 'RAM',
                      used: '${((cpuInfo['UsedRam'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                      total: '${((cpuInfo['TotalRam'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                    ),
                    Divider(),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(show: false),
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    NumberTitle(
                      title: 'VRAM',
                      used: '${((gpuInfo['UsedVram'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                      total: '${((gpuInfo['TotalVram'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                    ),
                    Divider(),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(show: false),
                          minY: 0,
                          maxY: 1,
                          minX: vramPoints.first.x,
                          maxX: vramPoints.last.x,
                          lineTouchData: const LineTouchData(enabled: false),
                          clipData: const FlClipData.all(),
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            _vramLine(vramPoints),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    PercentTitle(
                      title: 'GPU',
                      percent: gpuInfo['GpuUsage'].toString(),
                    ),
                    Divider(),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(show: false),
                          minY: 0,
                          maxY: 1,
                          minX: gpuPoints.first.x,
                          maxX: gpuPoints.last.x,
                          lineTouchData: const LineTouchData(enabled: false),
                          clipData: const FlClipData.all(),
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            _gpuLine(gpuPoints),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
