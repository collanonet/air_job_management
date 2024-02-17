import 'package:air_job_management/models/worker_model/shift.dart';

class Myjob {
  DateTime? createAt;
  String? jobId;
  String? jobTitle;
  String? jobLocation;
  String? status;
  String? uid;
  String? uname;
  String? image;
  List<ShiftModel>? shiftList;

  Myjob({this.createAt, this.jobId, this.status, this.uid, this.uname, this.shiftList, this.jobTitle, this.jobLocation, this.image});

  factory Myjob.fromJson(Map<String, dynamic> json) {
    return Myjob(
      shiftList: List<ShiftModel>.from(json["shift"].map((e) => ShiftModel.fromJson(e))),
      createAt: json["created_at"] != null ? json["created_at"].toDate() : null,
      jobId: json["job_id"],
      jobLocation: json["job_location"],
      jobTitle: json["job_title"],
      status: json["status"],
      uid: json["user_id"],
      uname: json["username"],
      image: json["image_job_url"],
    );
  }
}
