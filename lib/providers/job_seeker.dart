import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class JobSeekerProvider with ChangeNotifier {
  List<MyUser> myUserList = [];

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

  List<String> jobSeekerDetailTab = [
    JapaneseText.basicInformation,
    JapaneseText.chat,
    JapaneseText.newArrival,
    JapaneseText.interview
  ];

  bool isLoading = false;

  getAllUser() async {
    myUserList = await UserApiServices().getAllUser();
    notifyListeners();
  }

  onInit() {
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
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
