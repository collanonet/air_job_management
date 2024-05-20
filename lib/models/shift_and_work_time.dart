import 'package:air_job_management/models/user.dart';

class ShiftAndWorkTimeByUser {
  String? userName;
  List<ShiftAndWorkTimeByUserByDate> list;
  ShiftAndWorkTimeByUser({required this.userName, required this.list});
}

class ShiftAndWorkTimeByUserByDate {
  DateTime date;
  ShiftAndWorkTime? shiftAndWorkTime;

  ShiftAndWorkTimeByUserByDate({required this.date, this.shiftAndWorkTime});
}

class ShiftAndWorkTime {
  String? userName;
  String? workingTime;
  String? startWorkTime;
  String? endWorkTime;
  String? scheduleStartWorkTime;
  String? scheduleEndWorkTime;
  MyUser? myUser;
  bool? paidHoliday;

  ShiftAndWorkTime(
      {this.userName = "",
      this.myUser,
      this.workingTime,
      this.startWorkTime = "",
      this.endWorkTime = "",
      this.scheduleStartWorkTime = "",
      this.scheduleEndWorkTime = "",
      this.paidHoliday = false});
}
