import 'dart:async';
import 'package:flutter/material.dart';
import 'package:submission/interfaces/transmitter.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => _TrainInfoPlateState();
}


class _TrainInfoPlateState extends State<TrainInfoPlate> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
  }

  Future<Widget> _getPlate() async {
    Transmitter.getSetState(setState);
    List<Widget> cards = Transmitter.getWidgets();

    return GridView.count(
      primary: false,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: cards.length > 4 ? 4: cards.isEmpty ? 1 : cards.length,
      children: cards,
    );
  }
}
