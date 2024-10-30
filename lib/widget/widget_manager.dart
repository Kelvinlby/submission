import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:submission/widget/monitor/train_info_card.dart';
import 'package:submission/widget/monitor/job_info_card.dart';


class WidgetManager {
  static final List<TrainInfoCard> _trainInfoCards = [];
  static final List<JobInfoCard> _jobInfoCards = [];
  static final trainDataNotifier = ValueNotifier<List<TrainInfoCard>>([]);
  static final jobDataNotifier = ValueNotifier<List<JobInfoCard>>([]);

  static void generate(Map<String, dynamic> message) {
    switch(message['command']) {
      case 0:     // Log data
        int index = _trainInfoCards.indexWhere((spotDataList) => spotDataList.title == message['name']);

        if(index == -1) {    // Metric not added before
          _trainInfoCards.add(TrainInfoCard(title: message['name'], data: [FlSpot(1, message['value'])]));
        }
        else {    // Metric already added
          List<FlSpot> dataSpot = _trainInfoCards[index].data;
          dataSpot.add(FlSpot(dataSpot.last.x + 1, message['value']));
          _trainInfoCards[index] = TrainInfoCard(title: _trainInfoCards[index].title, data: dataSpot);
        }

        trainDataNotifier.value = List.from(_trainInfoCards);
        break;

      case 1:     // Log jobs
        int index = _jobInfoCards.indexWhere((jobList) => jobList.name == message['name']);

        if(index == -1) {    // Job not added before
          if(message['value'] == 1) {
            break;
          }
          else {
            _jobInfoCards.add(JobInfoCard(name: message['name'], percent: message['value'] == 'null' ? null : message['value']));
          }
        }
        else {    // Metric already added
          if(message['value'] == 1) {   // Job finished
            _jobInfoCards.removeAt(index);
          }
          else {
            _jobInfoCards[index] = JobInfoCard(name: message['name'], percent: message['percent']);
          }
        }
        jobDataNotifier.value = List.from(_jobInfoCards);
        break;
    }
  }

  static void reset() {
    _trainInfoCards.clear();
    _jobInfoCards.clear();
    trainDataNotifier.value = List.from(_trainInfoCards);
    jobDataNotifier.value = List.from(_jobInfoCards);
  }
}