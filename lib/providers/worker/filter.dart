import 'package:flutter/cupertino.dart';

class WorkerFilter with ChangeNotifier {
  List<String> rangeTime = [
    '午前中',
    '12時−14時',
    '14時−16時',
    '16時−18時',
    '18時−20時',
    '20時−22時',
    '深夜',
    '早朝'
  ];
  List<String> selectedRangeTime = [];

  List<String> treatmentList = [
    '未経験歓迎',
    'まかないあり',
    '服装自由',
    '髪型/ヘアカラー自由',
    '交通費支給',
    'バイク/車通勤可',
    '自転車通勤可',
  ];
  List<String> selectedTreatment = [];

  List<String> rewardList = ['3,000円〜', '5,000円〜', '8,000円〜', '10,000円〜'];

  String? selectedReward;

  List<String> occupationList = [
    'すべて',
    '軽作業',
    '配達・運転',
    '販売',
    '飲食',
    'オフィスワーク',
    'イベント・キャンペーン',
    '専門職',
    '接客',
    'エンタメ',
  ];

  List<String> selectedOccupation = [];

  onChangeReward(String? reward) {
    selectedReward = reward;
    notifyListeners();
  }

  onChangeOccupation(List<String> list) {
    selectedOccupation = list;
    notifyListeners();
  }

  onChangeTreatment(List<String> list) {
    selectedTreatment = list;
    notifyListeners();
  }

  onChangeRangeTime(List<String> list) {
    selectedRangeTime = list;
    notifyListeners();
  }
}
