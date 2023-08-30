import 'package:air_job_management/helper/route_handler.dart';
import 'package:air_job_management/pages/dashboard/dashboard.dart';
import 'package:air_job_management/pages/schedule/schedule.dart';
import 'package:air_job_management/pages/setting/setting.dart';
import 'package:air_job_management/pages/users/users.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  List<String> menuList = [JapaneseText.dashboard, JapaneseText.users, JapaneseText.schedule, JapaneseText.setting];
  List<IconData> menuIconList = const [Icons.dashboard_sharp, Icons.person_rounded, Icons.calendar_month_rounded, Icons.settings_rounded];
  List<Widget> menuPageList = const [DashboardPage(), UserPage(), SchedulePage(), SettingPage()];
  String selectedItem = JapaneseText.dashboard;

  onInit() {
    selectedItem = JapaneseText.dashboard;
  }

  onChangeSelectItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  checkRoute(HomeProvider provider) {
    return RouteHandler.check(provider);
  }
}
