import 'package:flutter/material.dart';
import 'package:submission/widgets/monitor/system_info.dart';


class Monitor extends StatelessWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SystemInfoCard(),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Place holder'),
          ],
        ),
      ],
    );
  }
}