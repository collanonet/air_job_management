import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

class JobSeekerDetailProvider with ChangeNotifier {
  List<MyUser> myUserList = [];

  List<String> tabMenu = [
    JapaneseText.basicInformation,
    JapaneseText.chat,
    JapaneseText.applicationHistory,
  ];

  String? selectMenu;

  bool isLoading = false;

  getAllUser() async {
    myUserList = await UserApiServices().getAllUser();
    notifyListeners();
  }

  onInit() {
    selectMenu ??= JapaneseText.basicInformation;
    isLoading = true;
  }

  onChangeMenu(String val) {
    selectMenu = val;
    notifyListeners();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
}
