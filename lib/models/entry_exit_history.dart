class EntryExitHistory {
  String? workingMinuteuid;
  String? startWorkingTime;
  String? endWorkingTime;
  String? scheduleStartWorkingTime;
  String? scheduleEndWorkingTime;
  String? workDate;
  DateTime? createdAt;
  bool? isLeaveEarly;
  bool? isLate;
  String? jobTitle;
  String? jobID;
  String? companyId;
  String? companyName;
  String? userId;
  String? amount;
  String? uid;
  int? workingHour;
  int? workingMinute;
  int? breakingTimeHour;
  int? breakingTimeMinute;
  int? lateMinute;
  int? latHour;
  int? leaveEarlyMinute;
  int? leaveEarlyHour;
  String? breakTime;

  EntryExitHistory(
      {this.uid,
      this.companyId,
      this.userId,
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
      this.breakTime});

  factory EntryExitHistory.fromJson(Map<String, dynamic> json) => EntryExitHistory(
        breakTime: json["breakTime"] ?? "",
        leaveEarlyHour: json["leaveEarlyHour"],
        leaveEarlyMinute: json["leaveEarlyMinute"],
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
        breakingTimeHour: json["breakingTimeHour"],
        breakingTimeMinute: json["breakingTimeMinute"],
        workingHour: json["workingHour"],
        workingMinute: json["workingMinute"],
      );

  Map<String, dynamic> toJson() => {
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
        "workDate": workDate,
        "breakingTimeHour": breakingTimeHour,
        "breakingTimeMinute": breakingTimeMinute,
        "workingHour": workingHour,
        "workingMinute": workingMinute,
      };
}
