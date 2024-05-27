import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/user.dart';

import 'job_posting.dart';

class EntryExitHistory {
  String? workingMinuteuid;
  String? startWorkingTime;
  String? endWorkingTime;
  String? scheduleStartWorkingTime;
  String? scheduleEndWorkingTime;
  String? scheduleStartBreakTime;
  String? scheduleEndBreakTime;
  String? workDate;
  String? endWorkDate;
  DateTime? workDateToDateTime;
  DateTime? createdAt;
  bool? isLeaveEarly;
  bool? isLate;
  String? jobTitle;
  String? jobID;
  String? companyId;
  String? companyName;
  String? userId;
  String? amount;
  String? overtime;
  String? nonStatutoryOvertime;
  String? overtimeWithinLegalLimit;
  String? holidayWork;
  bool? isHolidayWork;
  String? uid;
  int? workingHour;
  int? workingMinute;
  int? actualWorkingHour;
  int? actualWorkingMinute;
  int? breakingTimeHour;
  int? breakingTimeMinute;
  int? lateMinute;
  int? latHour;
  int? leaveEarlyMinute;
  int? leaveEarlyHour;
  String? breakTime;
  Review? review;
  MyUser? myUser;
  bool? isPaidLeave;

  EntryExitHistory(
      {this.uid,
      this.myUser,
      this.isPaidLeave,
      this.workDateToDateTime,
      this.review,
      this.companyId,
      this.userId,
      this.endWorkDate,
      this.createdAt,
      this.jobTitle,
      this.companyName,
      this.endWorkingTime,
      this.startWorkingTime,
      this.amount,
      this.isLate,
      this.isLeaveEarly,
      this.jobID,
      this.scheduleEndWorkingTime,
      this.scheduleStartWorkingTime,
      this.workDate,
      this.breakingTimeHour,
      this.breakingTimeMinute,
      this.workingHour,
      this.workingMinute,
      this.lateMinute,
      this.latHour,
      this.leaveEarlyHour,
      this.leaveEarlyMinute,
      this.breakTime,
      this.holidayWork,
      this.isHolidayWork,
      this.overtime,
      this.overtimeWithinLegalLimit,
      this.workingMinuteuid,
      this.nonStatutoryOvertime,
      this.scheduleStartBreakTime,
      this.scheduleEndBreakTime,
      this.actualWorkingMinute,
      this.actualWorkingHour});

  factory EntryExitHistory.fromJson(Map<String, dynamic> json) => EntryExitHistory(
        isPaidLeave: json["isPaidLeave"] ?? false,
        actualWorkingHour: json["actualWorkingHour"] ?? 0,
        actualWorkingMinute: json["actualWorkingMinute"] ?? 0,
        workDateToDateTime: DateToAPIHelper.fromApiToLocal(json["workDate"]),
        scheduleEndBreakTime: json["scheduleEndBreakTime"] ?? "13:00",
        scheduleStartBreakTime: json["scheduleStartBreakTime"] ?? "12:00",
        nonStatutoryOvertime: json["nonStatutoryOvertime"] ?? "00:00",
        holidayWork: json["holidayWork"] ?? "00:00",
        overtime: json["overtime"] ?? "00:00",
        endWorkDate: json["endWorkDate"] ?? json["workDate"],
        overtimeWithinLegalLimit: json["overtimeWithinLegalLimit"] ?? "00:00",
        isHolidayWork: json["isHolidayWork"] ?? false,
        review: json["review"] != null ? Review.fromJson(json["review"]) : null,
        breakTime: json["breakTime"] ?? "",
        leaveEarlyHour: json["leaveEarlyHour"] ?? 0,
        leaveEarlyMinute: json["leaveEarlyMinute"] ?? 0,
        lateMinute: json["lateMinute"],
        latHour: json["latHour"],
        companyId: json["companyId"],
        userId: json["userId"],
        createdAt: json["createdAt"].toDate(),
        jobTitle: json["jobTitle"],
        companyName: json["companyName"],
        endWorkingTime: json["endWorkingTime"],
        startWorkingTime: json["startWorkingTime"],
        amount: json["amount"],
        isLate: json["isLate"],
        isLeaveEarly: json["isLeaveEarly"],
        jobID: json["jobID"],
        scheduleEndWorkingTime: json["scheduleEndWorkingTime"],
        scheduleStartWorkingTime: json["scheduleStartWorkingTime"],
        workDate: json["workDate"],
        breakingTimeHour: json["breakingTimeHour"] ?? 0,
        breakingTimeMinute: json["breakingTimeMinute"] ?? 0,
        workingHour: json["workingHour"] ?? 0,
        workingMinute: json["workingMinute"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "isPaidLeave": isPaidLeave,
        "endWorkDate": endWorkDate,
        "actualWorkingHour": actualWorkingHour,
        "actualWorkingMinute": actualWorkingMinute,
        "overtime": overtime,
        "nonStatutoryOvertime": nonStatutoryOvertime,
        "overtimeWithinLegalLimit": overtimeWithinLegalLimit,
        "holidayWork": holidayWork,
        "isHolidayWork": isHolidayWork,
        "review": review != null ? review!.toJson() : null,
        "breakTime": breakTime,
        "leaveEarlyHour": leaveEarlyHour,
        "leaveEarlyMinute": leaveEarlyMinute,
        "lateMinute": lateMinute,
        "latHour": latHour,
        "uid": uid,
        "companyId": companyId,
        "userId": userId,
        "createdAt": createdAt,
        "jobTitle": jobTitle,
        "companyName": companyName,
        "endWorkingTime": endWorkingTime,
        "startWorkingTime": startWorkingTime,
        "amount": amount,
        "isLate": isLate,
        "isLeaveEarly": isLeaveEarly,
        "jobID": jobID,
        "scheduleEndWorkingTime": scheduleEndWorkingTime,
        "scheduleStartWorkingTime": scheduleStartWorkingTime,
        "scheduleStartBreakTime": scheduleStartBreakTime,
        "scheduleEndBreakTime": scheduleEndBreakTime,
        "workDate": workDate,
        "breakingTimeHour": breakingTimeHour,
        "breakingTimeMinute": breakingTimeMinute,
        "workingHour": workingHour,
        "workingMinute": workingMinute,
      };
}
