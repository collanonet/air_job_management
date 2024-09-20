import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/user.dart';

import '../utils/japanese_text.dart';
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
  String? midnightOvertime;
  EntryExitHistoryCorrection? entryExitHistoryCorrection;
  double? hourlyWage;
  double? totalWage;
  double? transportationFee;
  String? transportationFeeOptions;
  bool? isConfirm;
  bool? isRequestReview;
  String? correctionStatus;

  EntryExitHistory(
      {this.uid,
      this.myUser,
      this.isPaidLeave,
      this.transportationFeeOptions,
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
      this.actualWorkingHour,
      this.midnightOvertime,
      this.entryExitHistoryCorrection,
      this.totalWage,
      this.hourlyWage,
      this.isRequestReview,
      this.transportationFee,
      this.isConfirm,
      this.correctionStatus});

  factory EntryExitHistory.fromJson(Map<String, dynamic> json) => EntryExitHistory(
        transportationFeeOptions: json["transportationFeeOptions"] ?? JapaneseText.providedTF,
        correctionStatus: json["correctionStatus"] ?? "pending",
        isConfirm: json["isConfirm"] ?? false,
        isRequestReview: json["isRequestReview"] ?? false,
        totalWage: json["totalWage"] != null ? double.parse(json["totalWage"].toString()) : 0.0,
        hourlyWage: double.parse(json["amount"].toString()),
        transportationFee: json["transportationFee"] != null ? double.parse(json["transportationFee"].toString()) : 0.0,
        entryExitHistoryCorrection:
            json["entryExitHistoryCorrection"] != null ? EntryExitHistoryCorrection.fromJson(json["entryExitHistoryCorrection"]) : null,
        midnightOvertime: json["midnightOvertime"] ?? "00:00",
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
        lateMinute: json["lateMinute"] ?? 0,
        latHour: json["latHour"] ?? 0,
        companyId: json["companyId"],
        userId: json["userId"],
        createdAt: json["createdAt"].toDate(),
        jobTitle: json["jobTitle"],
        companyName: json["companyName"],
        endWorkingTime: json["endWorkingTime"] == null || json["endWorkingTime"] == "" ? "00:00" : json["endWorkingTime"],
        startWorkingTime: json["startWorkingTime"] ?? "00:00",
        amount: json["amount"],
        isLate: json["isLate"] ?? false,
        isLeaveEarly: json["isLeaveEarly"] ?? false,
        jobID: json["jobID"],
        scheduleEndWorkingTime: json["scheduleEndWorkingTime"] ?? "09:00",
        scheduleStartWorkingTime: json["scheduleStartWorkingTime"] ?? "18:00",
        workDate: json["workDate"],
        breakingTimeHour: json["break_time_hour"] ?? 0,
        breakingTimeMinute: json["break_time_minute"] ?? 0,
        workingHour: json["workingHour"] ?? 0,
        workingMinute: json["workingMinute"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "transportationFeeOptions": transportationFeeOptions,
        "correctionStatus": correctionStatus,
        "isRequestReview": isRequestReview ?? false,
        "isConfirm": isConfirm ?? false,
        "totalWage": totalWage ?? 0.0,
        "hourlyWage": hourlyWage ?? 0.0,
        "transportationFee": transportationFee ?? 0.0,
        "entryExitHistoryCorrection": entryExitHistoryCorrection,
        "midnightOvertime": midnightOvertime,
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
        "break_time_hour": breakingTimeHour,
        "break_time_minute": breakingTimeMinute,
        "workingHour": workingHour,
        "workingMinute": workingMinute,
      };
}

class EntryExitHistoryCorrection {
  String? startWorkingTime;
  String? endWorkingTime;
  String? breakTime;
  String? startDate;
  String? endDate;
  String? totalWage;
  String? hourlyWage;
  String? transportFee;
  String? overtime;
  String? midnightOverTime;
  String? overtimePay;
  String? midnightOverTimePay;

  EntryExitHistoryCorrection(
      {this.breakTime,
      this.startDate,
      this.endDate,
      this.endWorkingTime,
      this.startWorkingTime,
      this.totalWage,
      this.overtime,
      this.hourlyWage,
      this.transportFee,
      this.midnightOverTime,
      this.midnightOverTimePay,
      this.overtimePay});

  factory EntryExitHistoryCorrection.fromJson(Map<String, dynamic> json) => EntryExitHistoryCorrection(
        endDate: json["endDate"],
        startDate: json["startDate"],
        startWorkingTime: json["startWorkingTime"],
        endWorkingTime: json["endWorkingTime"],
        breakTime: json["breakTime"],
        hourlyWage: json["hourlyWage"],
        midnightOverTime: json["midnightOverTime"],
        midnightOverTimePay: json["midnightOverTimePay"],
        overtime: json["overtime"],
        overtimePay: json["overtimePay"],
        totalWage: json["totalWage"],
        transportFee: json["transportFee"],
      );

  Map<String, dynamic> toJson() => {
        "endDate": endDate,
        "startDate": startDate,
        "startWorkingTime": startWorkingTime,
        "endWorkingTime": endWorkingTime,
        "breakTime": breakTime,
        "hourlyWage": hourlyWage,
        "midnightOverTime": midnightOverTime,
        "midnightOverTimePay": midnightOverTimePay,
        "overtime": overtime,
        "overtimePay": overtimePay,
        "totalWage": totalWage,
        "transportFee": transportFee,
      };
}
