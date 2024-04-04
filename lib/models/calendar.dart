import 'package:air_job_management/models/worker_model/shift.dart';

class CalendarModel {
  DateTime date;
  List<ShiftModel>? shiftModelList;
  String? jobId;
  String? applyName;
  CalendarModel({required this.date, this.shiftModelList = const [], this.jobId = "", this.applyName = ""});
}

class GroupedCalendarModel {
  String? applyName;
  List<CalendarModel>? calendarModels;
  List<ShiftModel> allShiftModels = [];
  GroupedCalendarModel({this.applyName, this.calendarModels});
}
