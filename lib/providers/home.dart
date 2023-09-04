import 'package:air_job_management/helper/route_handler.dart';
import 'package:air_job_management/pages/company/company.dart';
import 'package:air_job_management/pages/dashboard/dashboard.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker.dart';
import 'package:air_job_management/pages/setting/setting.dart';
import 'package:air_job_management/pages/shift/shift.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';

import '../pages/job/job.dart';

class HomeProvider with ChangeNotifier {
  List<String> menuList = [
    JapaneseText.analysis,
    JapaneseText.jobSeeker,
    JapaneseText.recruitingCompany,
    JapaneseText.job,
    JapaneseText.shift,
    JapaneseText.setting
  ];
  List<IconData> menuIconList = const [
    Icons.dashboard_sharp,
    Icons.person_rounded,
    Icons.maps_home_work_outlined,
    Icons.work_rounded,
    Icons.calendar_month_rounded,
    Icons.settings_rounded
  ];
  List<Widget> menuPageList = const [
    DashboardPage(),
    JobSeekerPage(),
    CompanyPage(),
    JobPage(),
    ShiftPage(),
    SettingPage()
  ];
  String selectedItem = JapaneseText.analysis;

  onInit() {
    selectedItem = JapaneseText.analysis;
  }

  onChangeSelectItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  checkRoute(HomeProvider provider) {
    return RouteHandler.check(provider);
  }
}
