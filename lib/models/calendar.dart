import 'package:air_job_management/models/worker_model/shift.dart';

class CalendarModel {
  DateTime date;
  List<ShiftModel>? shiftModelList;
  String? jobId;
  CalendarModel({required this.date, this.shiftModelList = const [], this.jobId = ""});
}
