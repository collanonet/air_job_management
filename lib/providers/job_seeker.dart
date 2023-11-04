import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class JobSeekerProvider with ChangeNotifier {
  List<MyUser> myUserList = [];

  List<String> statusList = [JapaneseText.allData, JapaneseText.duringCorrespondence, JapaneseText.noContact, JapaneseText.contact];

  String? selectedStatus;

  List<String> newArrivalList = [JapaneseText.allData, JapaneseText.newArrival, JapaneseText.interview];
  String? selectedNewArrival;

  List<String> jobSeekerDetailTab = [JapaneseText.basicInformation, JapaneseText.chat, JapaneseText.newArrival, JapaneseText.interview];

  bool isLoading = false;

  List<JobApply> jobList = [];

  getAllUser() async {
    myUserList = await UserApiServices().getAllUser();
    notifyListeners();
  }

  filterJobSeeker() async {
    myUserList = await UserApiServices().getAllUser();
    List<MyUser> filter = [];
    if (selectedStatus != null && selectedStatus != JapaneseText.allData) {
      for (var user in myUserList) {
        if (selectedStatus != null && selectedStatus == user.workingStatus) {
          filter.add(user);
        }
      }
    } else {
      filter = myUserList;
    }
    List<MyUser> filterAfterStatus = [];
    if (selectedNewArrival != null && selectedNewArrival != JapaneseText.allData) {
      for (var user in filter) {
        if (selectedNewArrival != null && selectedNewArrival == user.workingStatus) {
          filterAfterStatus.add(user);
        }
      }
    } else {
      filterAfterStatus = filter;
    }
    myUserList = filterAfterStatus;
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
    filterJobSeeker();
  }

  onChangeNewArrival(String? val) {
    selectedNewArrival = val;
    notifyListeners();
    filterJobSeeker();
  }
}
