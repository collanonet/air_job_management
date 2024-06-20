import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/models/worker_model/shift.dart';

class CalendarModel {
  DateTime date;
  List<ShiftModel>? shiftModelList;
  String? jobId;
  String? searchJobId;
  String? major;
  String? applyName;
  CalendarModel({required this.date, this.shiftModelList = const [], this.jobId = "", this.applyName = "", this.major = "", this.searchJobId = ""});
}

class GroupedCalendarModel {
  String? applyName;
  String? seekerId;
  String? status;
  MyUser? myUser;
  List<CalendarModel>? calendarModels;
  List<ShiftModel>? allShiftModels = [];
  GroupedCalendarModel({this.applyName, this.calendarModels, this.allShiftModels, this.status, this.seekerId, this.myUser});
}
