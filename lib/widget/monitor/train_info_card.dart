import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/widget/monitor/monitor_title.dart';


class TrainInfoCard extends StatefulWidget {
  const TrainInfoCard({super.key, required this.title, required this.data});
  final String title;
  final List<FlSpot> data;

  @override
  State<TrainInfoCard> createState() => _TrainInfoCardState();
}


class _TrainInfoCardState extends State<TrainInfoCard> {
  final List<Color> _lineColors = [
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
  ];

  Color? _color;

  @override
  void initState() {
    if(_color == null) {
      Random random = Random();
      _color = _lineColors[random.nextInt(_lineColors.length)];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double minX = widget.data.map((spot) => spot.x).reduce(min);
    double maxX = widget.data.map((spot) => spot.x).reduce(max);
    double minY = widget.data.map((spot) => spot.y).reduce(min);
    double maxY = widget.data.map((spot) => spot.y).reduce(max);

    double xRange = maxX - minX;
    double yRange = maxY - minY;

    // Add padding (10% of the range on each side)
    double horizontalPadding = xRange == 0 ? minX : xRange * 0.1;
    double verticalPadding = yRange == 0? minY : yRange * 0.1;

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          children: [
            ValueTitle(
              title: widget.title,
              value: widget.data.last.y.toStringAsFixed(3),
            ),
            const Divider(height: 0),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    minX: minX - horizontalPadding,
                    maxX: maxX + horizontalPadding,
                    minY: minY - verticalPadding,
                    maxY: maxY + verticalPadding,
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value < minX || value > maxX) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1),
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono'
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 32,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Only show titles for actual data points range
                            if (value < minY - 0.0001 || value > maxY + 0.0001) {
                              return const SizedBox.shrink();
                            }

                            return value.truncateToDouble() != value
                              ? Text(
                                  value.toStringAsFixed(1),
                                  style: TextStyle(fontFamily: 'JetBrains Mono'),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(fontFamily: 'JetBrains Mono'),
                                    ),
                                    const Text(
                                      '.0',
                                      style: TextStyle(
                                        fontFamily: 'JetBrains Mono',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: const LineTouchData(enabled: true),
                    clipData: const FlClipData.all(),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: true,
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: widget.data,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: _color ?? _lineColors.first,
                              strokeWidth: 3,
                              strokeColor: (_color ?? _lineColors.first).withOpacity(0.35),
                            );
                          }
                        ),
                        color: _color ?? _lineColors.first,
                        belowBarData: BarAreaData(show: false),
                        barWidth: 4,
                        isCurved: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
