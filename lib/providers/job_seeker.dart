import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class JobSeekerProvider with ChangeNotifier {
  List<String> statusList = [
    JapaneseText.allData,
    JapaneseText.duringCorrespondence,
    JapaneseText.newArrival,
    JapaneseText.interview
  ];
  String? selectedStatus;

  List<String> newArrivalList = [
    JapaneseText.allData,
    JapaneseText.newArrival,
    JapaneseText.interview
  ];
  String? selectedNewArrival;

  onInit() {
    selectedStatus = null;
    selectedNewArrival = null;
  }

  onChangeStatus(String? val) {
    selectedStatus = val;
    notifyListeners();
  }

  onChangeNewArrival(String? val) {
    selectedNewArrival = val;
    notifyListeners();
  }
}
