import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';

class ShiftModel {
  String? jobId; //For applicant download
  String? fullName; //For applicant download
  String? title; //For applicant download
  String? jobTitle; //For applicant download
  String? applyCount; //For applicant download
  DateTime? date;
  String? price;
  String? startWorkTime;
  String? endWorkTime;
  String? startBreakTime;
  String? endBreakTime;
  SearchJob? myJob;
  String? status;
  String? image;
  int applicantCount;
  String recruitmentCount;
  List<String>? userNameList;
  String? isAbsent;
  ShiftModel(
      {this.date,
      this.isAbsent,
      this.status,
      this.price,
      this.endBreakTime,
      this.startBreakTime,
      this.endWorkTime,
      this.startWorkTime,
      this.image,
      this.title,
      this.myJob,
      this.jobId,
      this.applicantCount = 0,
      this.recruitmentCount = "0",
      this.fullName,
      this.userNameList,
      this.jobTitle});

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
      date: DateToAPIHelper.fromApiToLocal(json["date"].toString()),
      startWorkTime: json["start_work_time"],
      startBreakTime: json["start_break_time"],
      endWorkTime: json["end_work_time"],
      endBreakTime: json["end_break_time"],
      status: json["status"] ?? "pending",
      price: json["price"]);

  Map<String, dynamic> toJson() => {
        "date": DateToAPIHelper.convertDateToString(date!),
        "start_work_time": startWorkTime,
        "start_break_time": startBreakTime,
        "end_work_time": endWorkTime,
        "end_break_time": endBreakTime,
        "status": status,
        "price": price
      };

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
