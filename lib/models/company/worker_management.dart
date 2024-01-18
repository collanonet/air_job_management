import 'package:air_job_management/models/user.dart';

import '../worker_model/shift.dart';

class WorkerManagement {
  String? uid;
  String? companyId;
  String? jobLocation;
  String? jobId;
  String? jobTitle;
  MyUser? myUser;
  String? status;
  String? userId;
  String? userName;
  List<ShiftModel>? shiftList;
  WorkerManagement(
      {this.jobTitle, this.myUser, this.companyId, this.shiftList, this.jobId, this.status, this.userId, this.userName, this.jobLocation, this.uid});
  factory WorkerManagement.fromJson(Map<String, dynamic> json) => WorkerManagement(
      shiftList: json["shift"] == null ? [] : List<ShiftModel>.from(json["shift"]!.map((x) => ShiftModel.fromJson(x))),
      companyId: json["company_id"],
      jobTitle: json["job_title"],
      jobLocation: json["job_location"],
      jobId: json["job_id"],
      myUser: json["user"] != null ? MyUser.fromJson(json["user"]) : null,
      status: json["status"],
      userId: json["user_id"],
      userName: json["username"]);
}
