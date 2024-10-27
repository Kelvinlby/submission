import 'dart:async';
import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/train_info_card.dart';
import 'package:submission/widget/widget_manager.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => TrainInfoPlateState();
}


class TrainInfoPlateState extends State<TrainInfoPlate> {
  Widget? _widgetCache;

  Future<Widget> _getPlate() async {
    final maxColumnCount = 4;
    final minColumnCount = 3;
    final List<TrainInfoCard> cards = WidgetManager.getCards();

    return GridView.count(
      primary: false,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: cards.length > maxColumnCount ? maxColumnCount : (cards.length < minColumnCount ? minColumnCount : cards.length),
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getPlate(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _widgetCache ?? SizedBox.shrink();
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
        _widgetCache = snapshot.data;
        return snapshot.data!;
      }
    },
  );
}
