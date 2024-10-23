import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/system_info.dart';
import 'package:submission/widget/monitor/train_info_plate.dart';


class Monitor extends StatelessWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.25,
              child: const SystemInfoCard(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TrainInfoPlate(),
            ),
          ],
        );
      }
    );
  }
}
