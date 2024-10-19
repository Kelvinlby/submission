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
  Map<String, int> _cpuInfo = {'TotalRam': 0, 'UsedRam': 0, 'RamUsage': 0};
  Map<String, int> _gpuInfo = {'GpuUsage': 0, 'TotalVram': 0, 'UsedVram': 0, 'VramUsage': 0};
  final GpuMonitor _monitor = GpuMonitor();

  // Line chart config
  double _xValue = 0;
  final _step = 0.1;
  final _limitCount = 100;
  final ramPoints = <FlSpot>[];
  final vramPoints = <FlSpot>[];
  final gpuPoints = <FlSpot>[];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      while (ramPoints.length > _limitCount) {
        ramPoints.removeAt(0);
        vramPoints.removeAt(0);
        gpuPoints.removeAt(0);
      }

      setState(() {
        _cpuInfo = _monitor.getCpuInfo();
        _gpuInfo = _monitor.getGpuInfo();

        ramPoints.add(FlSpot(_xValue, (_cpuInfo['RamUsage'] ?? 0) / 100));
        vramPoints.add(FlSpot(_xValue, (_gpuInfo['VramUsage'] ?? 0) / 100));
        gpuPoints.add(FlSpot(_xValue, (_gpuInfo['GpuUsage'] ?? 0) / 100));
      });

      _xValue += _step;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    children: [
                      NumberTitle(
                        title: 'RAM',
                        used: '${((_cpuInfo['UsedRam'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                        total: '${((_cpuInfo['TotalRam'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                      ),
                      Divider(height: 0),
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
                              LineChartBarData(
                                isStrokeCapRound: true,
                                spots: ramPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.cyan.withOpacity(0), Colors.cyan],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.cyan.withOpacity(0), Colors.cyan.withOpacity(0.3)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: false,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    children: [
                      NumberTitle(
                        title: 'VRAM',
                        used: '${((_gpuInfo['UsedVram'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                        total: '${((_gpuInfo['TotalVram'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                      ),
                      Divider(height: 0),
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
                              LineChartBarData(
                                spots: vramPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.orange.withOpacity(0), Colors.orange],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.orange.withOpacity(0), Colors.orange.withOpacity(0.3)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: false,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    children: [
                      PercentTitle(
                        title: 'GPU',
                        percent: _gpuInfo['GpuUsage'].toString(),
                      ),
                      Divider(height: 0),
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
                              LineChartBarData(
                                spots: gpuPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.pinkAccent.withOpacity(0), Colors.pinkAccent],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.pinkAccent.withOpacity(0), Colors.pinkAccent.withOpacity(0.3)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: false,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
