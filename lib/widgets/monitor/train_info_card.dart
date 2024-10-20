import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:submission/widgets/monitor/monitor_title.dart';


class TrainInfoCard extends StatefulWidget {
  const TrainInfoCard({super.key, required this.title, required this.data});
  final String title;
  final List<FlSpot> data;

  @override
  State<TrainInfoCard> createState() => _TrainInfoCardState();
}


class _TrainInfoCardState extends State<TrainInfoCard> {
  final List<Color> lineColors = [
    Colors.pinkAccent,
    Colors.orange,
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
  ];

  late Color color;

  @override
  void initState() {
    Random random = Random();
    color = lineColors[random.nextInt(lineColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 28,
                  right: 24,
                  bottom: 16,
                ),
                child: LineChart(
                  LineChartData(
                    titlesData: const FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                        dotData: const FlDotData(show: true),
                        color: color,
                        belowBarData: BarAreaData(show: false),
                        barWidth: 2,
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
