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
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(),
    );
  }
}
