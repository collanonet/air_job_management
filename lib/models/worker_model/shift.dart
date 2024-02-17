import 'package:air_job_management/helper/date_to_api.dart';

class ShiftModel {
  String? title;
  String? image;
  DateTime? date;
  String? price;
  String? startWorkTime;
  String? endWorkTime;
  String? startBreakTime;
  String? endBreakTime;
  ShiftModel({this.date, this.price, this.endBreakTime, this.startBreakTime, this.endWorkTime, this.startWorkTime, this.image, this.title});

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
      date: DateToAPIHelper.fromApiToLocal(json["date"].toString()),
      startWorkTime: json["start_work_time"],
      startBreakTime: json["start_break_time"],
      endWorkTime: json["end_work_time"],
      endBreakTime: json["end_break_time"],
      price: json["price"]);

  @override
  int get hashCode => date.hashCode ^ startBreakTime.hashCode ^ endWorkTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftModel &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          startWorkTime == other.startWorkTime &&
          endWorkTime == other.endWorkTime;
}
