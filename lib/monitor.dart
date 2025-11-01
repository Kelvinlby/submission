import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/system_info.dart';


class Monitor extends StatelessWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: const SystemInfoCard(),
            ),
          ],
        );
      }
    );
  }
}
