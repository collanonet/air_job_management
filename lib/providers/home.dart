import 'package:air_job_management/1_company_page/applicant/applicant.dart';
import 'package:air_job_management/1_company_page/dashboard/dashboard.dart';
import 'package:air_job_management/1_company_page/job_posting/job_posting.dart';
import 'package:air_job_management/1_company_page/shift_calendar/shift_calendar.dart';
import 'package:air_job_management/1_company_page/woker_management/worker_management.dart';
import 'package:air_job_management/helper/route_handler.dart';
import 'package:air_job_management/pages/company/company.dart';
import 'package:air_job_management/pages/dashboard/dashboard.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker.dart';
import 'package:air_job_management/pages/setting/setting.dart';
import 'package:air_job_management/pages/shift/shift.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../1_company_page/company_profile/root_company_profile.dart';
import '../1_company_page/history/history.dart';
import '../1_company_page/usage_detail/usage_detail.dart';
import '../pages/job_posting/job_posting.dart';

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

  List<String> menuListForCompany = [
    JapaneseText.dashboardCompany,
    JapaneseText.recruitmentTemplate,
    JapaneseText.shiftFrame,
    JapaneseText.applicantCompany,
    JapaneseText.workerCompany,
    JapaneseText.workingTimeManagement,
    JapaneseText.usageDetail,
    JapaneseText.companyInformationManagement
  ];
  List<IconData> menuIconListForCompany = const [
    Icons.dashboard,
    Icons.folder_rounded,
    Icons.calendar_month_rounded,
    Icons.person,
    Icons.person_pin_rounded,
    Icons.history_rounded,
    FontAwesome.calculator,
    FontAwesome.building
  ];

  List<Widget> menuPageList = const [DashboardPage(), JobSeekerPage(), CompanyPage(), JobPage(), ShiftPage(), SettingPage()];
  List<Widget> menuPageListForCompany = const [
    DashboardPageForCompany(),
    JobPostingForCompanyPage(),
    ShiftCalendarPage(),
    ApplicantListPage(),
    WorkerManagementPage(),
    HistoryPage(),
    UsageDetailPage(),
    RootCompanyPage()
  ];
  String selectedItem = JapaneseText.analysis;
  String selectedItemForCompany = JapaneseText.analysis;

  onInit() {
    selectedItem = JapaneseText.analysis;
    selectedItemForCompany = JapaneseText.dashboardCompany;
  }

  onChangeSelectItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  onChangeSelectItemForCompany(String item) {
    selectedItemForCompany = item;
    notifyListeners();
  }

  checkRoute(HomeProvider provider) {
    return RouteHandler.check(provider);
  }

  checkRouteForCompany(HomeProvider provider) {
    return RouteHandler.checkForCompany(provider);
  }
}
