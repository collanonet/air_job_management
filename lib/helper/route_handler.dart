import 'package:air_job_management/utils/my_route.dart';

class RouteHandler {
  static List<String> menu = [
    MyRoute.attendance,
    MyRoute.lateAttendance,
    MyRoute.branch,
    MyRoute.output,
    MyRoute.qrCode,
    MyRoute.shiftTemplate,
    MyRoute.internationalStudentAlert,
  ];

  static List<String> scheduleList = [
    MyRoute.dailySchedule,
    MyRoute.monthlySchedule,
  ];

  static List<String> applicationApprovalRequestList = [
    MyRoute.overtimeRequest,
    MyRoute.holidayWork,
    MyRoute.stampCorrection,
    MyRoute.scheduleWork,
    MyRoute.annualPaidOff,
    MyRoute.substitutePaidOff,
    MyRoute.compensationDayOff,
    MyRoute.congratsAndCondolence,
    MyRoute.dayOff,
  ];
  static List<String> staffSettingList = [
    MyRoute.staff,
    MyRoute.workingRule,
    MyRoute.holidaySetting,
  ];

  static List<String> holidayVacationSettingList = [
    MyRoute.paidOffSetting,
    MyRoute.substituteHolidaySetting,
    MyRoute.compensatoryHolidaySetting,
    MyRoute.specialHolidayMaster,
    MyRoute.specialHolidaySetting,
    MyRoute.halfDayOffSetting,
  ];

  static List<String> attendanceHistory = [
    MyRoute.attendanceHistory,
    MyRoute.monthlyAttendanceHistory,
    MyRoute.closingProcess,
  ];
}
