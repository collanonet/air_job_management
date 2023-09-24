import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> companyList = [];

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

  bool isLoading = false;

  getAllCompany() async {
    companyList = await CompanyApiServices().getAllCompany();
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
