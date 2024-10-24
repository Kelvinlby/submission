import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:submission/widget/monitor/train_info_card.dart';
import 'package:submission/interface/grpc/server_manager.dart';


class TrainInfoPlate extends StatefulWidget {
  const TrainInfoPlate({super.key});

  @override
  State<TrainInfoPlate> createState() => _TrainInfoPlateState();
}


class _TrainInfoPlateState extends State<TrainInfoPlate> {
  bool _statusTracker = false;
  Widget? _widgetCache;
  Timer? _timer;
  final List<TrainInfoCard> _cards = [];

  void _widgetGenerator(List<Map<String, dynamic>>? message) {
    message?.forEach((data) {
      switch(data['command']) {
        case 0: // Log data
          int index = _cards.indexWhere((spotDataList) => spotDataList.title == data['name']);
          if( index == -1) {    // Metric not added before
            _cards.add(TrainInfoCard(title: data['name'], data: [FlSpot(1, data['value'])]));
          }
          else {    // Metric already added
            List<FlSpot> dataSpot = _cards[index].data;
            dataSpot.add(FlSpot(dataSpot.last.x + 1, data['value']));
            _cards[index] = TrainInfoCard(title: _cards[index].title, data: dataSpot);
          }
          break;
      }
    });
  }

  Future<Widget> _getPlate() async {
    final maxColumnCount = 4;
    final minColumnCount = 4;

    return GridView.count(
      primary: false,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: _cards.length > maxColumnCount ? maxColumnCount : (_cards.length < minColumnCount ? minColumnCount : _cards.length),
      children: _cards,
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(ServerManager.getLaunchState()) {
        if(!_statusTracker) {   // Clear previous logs on launch
          _cards.clear();
        }

        setState(() {
          _widgetGenerator(ServerManager.listen());
        });
      }
      else {
        _statusTracker = false;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getPlate(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _widgetCache ?? SizedBox.shrink();
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
        _widgetCache = snapshot.data;
        return snapshot.data!;
      }
    },
  );
}
