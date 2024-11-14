import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/job_info_card.dart';
import 'package:submission/widget/widget_manager.dart';


class JobInfoPlate extends StatefulWidget {
  const JobInfoPlate({super.key});

  @override
  State<JobInfoPlate> createState() => _JobInfoPlateState();
}


class _JobInfoPlateState extends State<JobInfoPlate> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<List<JobInfoCard>>(
    valueListenable: WidgetManager.jobDataNotifier,
    builder: (context, value, child) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: value.length,
        itemBuilder: (context, index) => value[index],
      );
    },
  );
}