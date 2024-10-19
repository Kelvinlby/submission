import 'package:flutter/material.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => _TrainInfoPlateState();
}


class _TrainInfoPlateState extends State<TrainInfoPlate> {
  List<Widget> _cards = [
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
      child: const Text("He'd have you all unravel at the"),
    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[200],
      child: const Text('Heed not the rabble'),
    ),
  ];

  int _setCrossAxisCount() {
    if(_cards.length >= 4) {
      return 4;
    }
    else {
      return _cards.length;
    }
  }

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
    return GridView.count(
      primary: false,
      // padding: const EdgeInsets.all(20),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: _setCrossAxisCount(),
      children: _cards,
    );
  }
}