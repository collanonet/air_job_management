import 'package:air_job_management/utils/my_route.dart';

import '../providers/home.dart';

class RouteHandler {
  // static List<String> menu = [
  //   MyRoute.attendance,
  //   MyRoute.lateAttendance,
  //   MyRoute.branch,
  //   MyRoute.output,
  //   MyRoute.qrCode,
  //   MyRoute.shiftTemplate,
  //   MyRoute.internationalStudentAlert,
  // ];

  static String check(HomeProvider provider) {
    if (provider.selectedItem == provider.menuList[0]) {
      return MyRoute.dashboard;
    } else if (provider.selectedItem == provider.menuList[1]) {
      return MyRoute.users;
    } else if (provider.selectedItem == provider.menuList[2]) {
      return MyRoute.schedule;
    } else if (provider.selectedItem == provider.menuList[3]) {
      return MyRoute.setting;
    } else {
      return MyRoute.login;
    }
  }
}
