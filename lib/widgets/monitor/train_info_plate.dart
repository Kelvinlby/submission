import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:submission/widgets/monitor/train_info_card.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => _TrainInfoPlateState();
}


class _TrainInfoPlateState extends State<TrainInfoPlate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getPlate(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Column(
            children: [
              Icon(
                Icons.data_thresholding_outlined,
                size: 192,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                weight: 200,
              ),
              Text(
                'No Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  fontWeight: FontWeight.w700,
                  fontSize: 96,
                ),
              ),
            ],
          ),
        );
      }
      else if (snapshot.hasError) {
        return Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 192,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                weight: 200,
              ),
              Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
      else {
        return snapshot.data!;
      }
    },
  );

  Future<Widget> _getPlate() async {
    final int maxColumnCount = 4;

    List<Widget> cards = [
      TrainInfoCard(
        title: 'title',
        data: [FlSpot(1, 1), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 4)],
      ),
      TrainInfoCard(
        title: 'title',
        data: [FlSpot(1, 1), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 4)],
      ),
      TrainInfoCard(
        title: 'title',
        data: [FlSpot(1, 1), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 4)],
      ),
      TrainInfoCard(
        title: 'title',
        data: [FlSpot(1, 1), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 3), FlSpot(5, 4)],
      )
    ];

    return GridView.count(
      primary: false,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: cards.length > maxColumnCount ? maxColumnCount : (cards.isEmpty ? 1 : cards.length),
      children: cards,
    );
  }
}
