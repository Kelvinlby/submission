import 'package:flutter/material.dart';
import 'package:submission/widgets/monitor/system_info.dart';
import 'package:submission/widgets/monitor/train_info.dart';


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
            SizedBox(
              height: constraints.maxHeight * 0.35,
              child: const TrainInfoCard(),
            ),
          ],
        );
      }
    );
  }
}
