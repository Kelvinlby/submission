import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:submission/widget/monitor/train_info_card.dart';


class WidgetManager {
  static final List<TrainInfoCard> _cards = [];
  static final cardNotifier = ValueNotifier<List<TrainInfoCard>>([]);

  static void generate(Map<String, dynamic> message) {
    switch(message['command']) {
      case 0: // Log data
        int index = _cards.indexWhere((spotDataList) => spotDataList.title == message['name']);
        if(index == -1) {    // Metric not added before
          _cards.add(TrainInfoCard(title: message['name'], data: [FlSpot(1, message['value'])]));
        }
        else {    // Metric already added
          List<FlSpot> dataSpot = _cards[index].data;
          dataSpot.add(FlSpot(dataSpot.last.x + 1, message['value']));
          _cards[index] = TrainInfoCard(title: _cards[index].title, data: dataSpot);
        }

        cardNotifier.value = List.from(_cards);
        break;
    }
  }

  static void reset() {
    _cards.clear();
    cardNotifier.value = List.from(_cards);
    print("Widget Cleared");
  }
}