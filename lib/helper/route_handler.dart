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
      return MyRoute.jobSeeker;
    } else if (provider.selectedItem == provider.menuList[2]) {
      return MyRoute.company;
    } else if (provider.selectedItem == provider.menuList[3]) {
      return MyRoute.job;
    } else if (provider.selectedItem == provider.menuList[4]) {
      return MyRoute.shift;
    } else if (provider.selectedItem == provider.menuList[5]) {
      return MyRoute.setting;
    } else {
      return MyRoute.login;
    }
  }

  static String checkForCompany(HomeProvider provider) {
    if (provider.selectedItemForCompany == provider.menuListForCompany[0]) {
      return MyRoute.companyDashboard;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[1]) {
      return MyRoute.companyJobPosting;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[2]) {
      return MyRoute.companyShift;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[3]) {
      return MyRoute.companyApplicant;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[4]) {
      return MyRoute.companyWorker;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[5]) {
      return MyRoute.companyTimeManagement;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[6]) {
      return MyRoute.companyUsageDetail;
    } else if (provider.selectedItemForCompany == provider.menuListForCompany[7]) {
      return MyRoute.companyInformationManagement;
    } else if (provider.selectedItemForCompany == provider.menuListForCompanyMainBranch[0]) {
      return MyRoute.companyInformationManagement;
    } else if (provider.selectedItemForCompany == provider.menuListForCompanyMainBranch[1]) {
      return MyRoute.companyAllBranch;
    } else if (provider.selectedItemForCompany == provider.menuListForCompanyMainBranch[2]) {
      return MyRoute.companyUsageDetail;
    } else if (provider.selectedItemForCompany == provider.menuListForCompanyMainBranch[3]) {
      return MyRoute.companyWorker;
    } else {
      return MyRoute.login;
    }
  }
}
