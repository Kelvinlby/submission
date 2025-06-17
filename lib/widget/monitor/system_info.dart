import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/interface/gpu_monitor.dart';
import 'package:submission/widget/monitor/monitor_title.dart';


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
  final _limitCount = 135;
  late final List<FlSpot> ramPoints;
  late final List<FlSpot> vramPoints;
  late final List<FlSpot> gpuPoints;

  @override
  void initState() {
    super.initState();

    ramPoints = List.generate(
      _limitCount,
      (index) => FlSpot(index * 0.0000001, 0),
    );

    vramPoints = List.generate(
      _limitCount,
      (index) => FlSpot(index * 0.0000001, 0),
    );

    gpuPoints = List.generate(
      _limitCount,
      (index) => FlSpot(index * 0.0000001, 0),
    );

    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {  // Do not change the duration below 150, or the line will shake.
      while (ramPoints.length > _limitCount) {
        ramPoints.removeAt(0);
        vramPoints.removeAt(0);
        gpuPoints.removeAt(0);
      }

      _cpuInfo = _monitor.getCpuInfo();
      _gpuInfo = _monitor.getGpuInfo();

      setState(() {
        ramPoints.add(FlSpot(ramPoints.last.x + 0.0000001, (_cpuInfo['RamUsage'] ?? 0) / 100));
        vramPoints.add(FlSpot(vramPoints.last.x + 0.0000001, (_gpuInfo['VramUsage'] ?? 0) / 100));
        gpuPoints.add(FlSpot(gpuPoints.last.x + 0.0000001, (_gpuInfo['GpuUsage'] ?? 0) / 100));
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
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
                        total: '${((_cpuInfo['TotalRam'] ?? 0) / 1024).toStringAsFixed(1)}GB',
                      ),
                      const Divider(height: 0),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            titlesData: const FlTitlesData(show: false),
                            minY: 0,
                            maxY: 1,
                            minX: ramPoints.first.x,
                            maxX: ramPoints.last.x,
                            lineTouchData: const LineTouchData(enabled: false),
                            clipData: const FlClipData.all(),
                            gridData: const FlGridData(
                              show: true,
                              horizontalInterval: 0.25,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                isStrokeCapRound: true,
                                spots: ramPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.cyan.withAlpha(0), Colors.cyan],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.cyan.withAlpha(0), Colors.cyan.withAlpha(76)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: true,
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
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    children: [
                      NumberTitle(
                        title: 'VRAM',
                        used: '${((_gpuInfo['UsedVram'] ?? 0) / 1024).toStringAsFixed(3)}GB',
                        total: '${((_gpuInfo['TotalVram'] ?? 0) / 1024).toStringAsFixed(1)}GB',
                      ),
                      const Divider(height: 0),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            titlesData: const FlTitlesData(show: false),
                            minY: 0,
                            maxY: 1,
                            minX: vramPoints.first.x,
                            maxX: vramPoints.last.x,
                            lineTouchData: const LineTouchData(enabled: false),
                            clipData: const FlClipData.all(),
                            gridData: const FlGridData(
                              show: true,
                              horizontalInterval: 0.25,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: vramPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.orange.withAlpha(0), Colors.orange],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.orange.withAlpha(0), Colors.orange.withAlpha(76)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: true,
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
            const SizedBox(height: 8),
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
                      const Divider(height: 0),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            titlesData: const FlTitlesData(show: false),
                            minY: 0,
                            maxY: 1,
                            minX: gpuPoints.first.x,
                            maxX: gpuPoints.last.x,
                            lineTouchData: const LineTouchData(enabled: false),
                            clipData: const FlClipData.all(),
                            gridData: const FlGridData(
                              show: true,
                              horizontalInterval: 0.25,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: gpuPoints,
                                dotData: const FlDotData(show: false),
                                gradient: LinearGradient(
                                  colors: [Colors.pinkAccent.withAlpha(0), Colors.pinkAccent],
                                  stops: const [0.1, 1.0],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.pinkAccent.withAlpha(0), Colors.pinkAccent.withAlpha(76)],
                                    stops: const [0.1, 1.0],
                                  ),
                                ),
                                barWidth: 2,
                                isCurved: true,
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
            const SizedBox(height: 96),
          ],
        );
      }
    );
  }
}
