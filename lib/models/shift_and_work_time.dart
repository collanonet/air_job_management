import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/models/worker_model/shift.dart';

class ShiftAndWorkTimeByUser {
  String? userName;
  MyUser? myUser;
  int publicHoliday;
  int paidLeave;
  int absence;
  int leaveOfAbsence;
  int lateArrival;
  int leaveEarly;
  int specialLeave;
  List<ShiftModel>? shiftList;
  List<ShiftAndWorkTimeByUserByDate> list;
  ShiftAndWorkTimeByUser(
      {required this.userName,
      required this.list,
      this.myUser,
      this.absence = 0,
      this.lateArrival = 0,
      this.leaveEarly = 0,
      this.leaveOfAbsence = 0,
      this.paidLeave = 0,
      this.publicHoliday = 0,
      this.specialLeave = 0,
      this.shiftList});
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
