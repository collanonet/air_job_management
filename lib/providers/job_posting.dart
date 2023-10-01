import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class JobPostingProvider with ChangeNotifier {
  List<JobPosting> jobPostingList = [];

  List<String> statusList = [
    JapaneseText.allData,
    JapaneseText.duringCorrespondence,
    JapaneseText.noContact,
    JapaneseText.contact
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

  String imageUrl = "";

  bool isLoading = false;

  set setImage(String val) {
    imageUrl = val;
  }

  onChangeImageUrl(String val) {
    imageUrl = val;
    notifyListeners();
  }

  getAllJobPost() async {
    jobPostingList = await JobPostingApiService().getAllJobPost();
    notifyListeners();
  }

  onInit() {
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
    imageUrl = "";
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
