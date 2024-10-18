import 'package:flutter/material.dart';


class TrainInfoCard extends StatefulWidget {
  const TrainInfoCard({super.key});

  @override
  State<TrainInfoCard> createState() => _TrainInfoCardState();
}


class _TrainInfoCardState extends State<TrainInfoCard> {
  @override
  void initState() {
    super.initState();
    // init here
  }

  @override
  void dispose() {
    // dispose here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      width: 256,
      color: Colors.blueGrey,
      child: Center(child: Text('Train Info Card - Place Holder')),
    );
  }
}
