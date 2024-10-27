import 'package:fl_chart/fl_chart.dart';
import 'package:submission/widget/monitor/train_info_card.dart';


class WidgetManager {
  static final List<TrainInfoCard> _cards = [];
  static bool _cardsReady = true;
  static Function? _cardSetState;
  
  static void registerStateSetter(String name, Function setState) {
    switch(name) {
      case 'card':
        _cardSetState = setState;
        break;
    }
  }

  static void generate(Map<String, dynamic> message) {
    if(_cardSetState == null) {
      return;
    }
    
    Map<String, dynamic> test =
    {
      'command': 0,
      'name': 'Loss',
      'value': 0.97,
    };

    switch(test['command']) {
      case 0: // Log data
        _cardsReady = false;

        int index = _cards.indexWhere((spotDataList) => spotDataList.title == test['name']);
        if(index == -1) {    // Metric not added before
          _cards.add(TrainInfoCard(title: test['name'], data: [FlSpot(1, test['value'])]));
        }
        else {    // Metric already added
          List<FlSpot> dataSpot = _cards[index].data;
          dataSpot.add(FlSpot(dataSpot.last.x + 1, test['value']));
          _cards[index] = TrainInfoCard(title: _cards[index].title, data: dataSpot);
        }

        _cardsReady = true;
        _cardSetState!.call();
        break;
    }
  }

  static List<TrainInfoCard> getCards() {
    while(!_cardsReady) {
      Future.delayed(Duration(milliseconds: 5));
    }
    
    return _cards;
  }

  static void reset() {
    _cards.clear();
  }
}