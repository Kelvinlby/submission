import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/train_info_card.dart';
import 'package:submission/widget/widget_manager.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => _TrainInfoPlateState();
}


class _TrainInfoPlateState extends State<TrainInfoPlate> {
  @override
  Widget build(BuildContext context) {
    final maxColumnCount = 4;
    final minColumnCount = 3;

    return ValueListenableBuilder<List<TrainInfoCard>>(
      valueListenable: WidgetManager.cardNotifier,
      builder: (context, value, child) {
        return GridView.count(
          primary: false,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: value.length > maxColumnCount ? maxColumnCount : (value.length < minColumnCount ? minColumnCount : value.length),
          children: value,
        );
      },
    );
  }
}
