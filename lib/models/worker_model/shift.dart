import 'package:air_job_management/helper/date_to_api.dart';

class ShiftModel {
  DateTime? date;
  String? price;
  String? startWorkTime;
  String? endWorkTime;
  String? startBreakTime;
  String? endBreakTime;
  ShiftModel({this.date, this.price, this.endBreakTime, this.startBreakTime, this.endWorkTime, this.startWorkTime});

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
      date: DateToAPIHelper.fromApiToLocal(json["date"].toString()),
      startWorkTime: json["start_work_time"],
      startBreakTime: json["start_break_time"],
      endWorkTime: json["end_work_time"],
      endBreakTime: json["end_break_time"],
      price: json["price"]);
}
