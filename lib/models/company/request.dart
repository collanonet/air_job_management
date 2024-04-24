import '../user.dart';
import '../worker_model/shift.dart';

class Request {
  String? uid;
  String? userId;
  String? username;
  String? email;
  String? jobTitle;
  String? jobId;
  String? applyJobId;
  ShiftModel? shiftModel;
  String? date;
  DateTime? createdDate;
  String? fromTime;
  String? toTime;
  bool? isUpdateShift;
  bool? isLeaveEarly;
  bool? isHoliday;
  String? status;
  MyUser? myUser;

  Request(
      {this.shiftModel,
      this.myUser,
      this.uid,
      this.status,
      this.date,
      this.jobId,
      this.userId,
      this.isLeaveEarly,
      this.toTime,
      this.fromTime,
      this.createdDate,
      this.isHoliday,
      this.isUpdateShift,
      this.email,
      this.jobTitle,
      this.username,
      this.applyJobId});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
        applyJobId: json['applyJobId'],
        status: json['status'],
        email: json['email'],
        username: json['username'],
        jobTitle: json['jobTitle'],
        shiftModel: json['shiftModel'] != null ? ShiftModel.fromJson(json['shiftModel']) : null,
        jobId: json['jobId'],
        isLeaveEarly: json['isLeaveEarly'],
        userId: json['userId'],
        date: json['date'],
        createdDate: json['createdDate'].toDate(),
        fromTime: json['fromTime'],
        isHoliday: json['isHoliday'],
        isUpdateShift: json['isUpdateShift'],
        toTime: json['toTime']);
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['applyJobId'] = applyJobId;
    data['shiftModel'] = shiftModel?.toJson();
    data['jobId'] = jobId;
    data['isLeaveEarly'] = isLeaveEarly;
    data['userId'] = userId;
    data['date'] = date;
    data['createdDate'] = createdDate;
    data['fromTime'] = fromTime;
    data['isHoliday'] = isHoliday;
    data['isUpdateShift'] = isUpdateShift;
    data['toTime'] = toTime;
    data['username'] = username;
    data['email'] = email;
    data['jobTitle'] = jobTitle;
    data['status'] = status ?? "pending";
    return data;
  }
}
