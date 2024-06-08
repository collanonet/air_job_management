import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/utils/japanese_text.dart';

class NotificationModel {
  String? uid;
  String? title;
  String? des;
  String? jobId;
  String? jobPostingId;
  String? shortDes;
  String? companyId;
  String? userId;
  String? companyName;
  DateTime? date;
  DateTime? applyDate;
  bool? isJobApply;
  bool? isRequest;
  bool? isRead;
  NotificationModel(
      {this.isRead,
        this.jobPostingId,
        this.jobId,
      this.shortDes,
      this.title,
      this.date,
      this.des,
      this.uid,
      this.userId,
      this.companyId,
      this.companyName,
      this.isJobApply,
      this.isRequest, this.applyDate});
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String shortDes = JapaneseText.empty;
    DateTime applyDate = json["applyDate"] != null ? json["applyDate"].toDate() : DateTime.now();
    if (json["isJobApply"] == true) {
      shortDes = "応募者の${json["username"] ?? ""}さんから求人応募がありました。";
    }
    if (json["isStartTime"] == true) {
      shortDes = "ワーカーの${json["username"] ?? ""}さん　${DateToAPIHelper.convertDateToString(applyDate)}のシフトの就業開始時間の変更申請がありました。";
    }
    if (json["isLeaveEarly"] == true) {
      shortDes = "ワーカーの${json["username"] ?? ""}さん　${DateToAPIHelper.convertDateToString(applyDate)}のシフトの早退申請がありました。";
    }
    if (json["isHoliday"] == true) {
      shortDes = "ワーカーの${json["username"] ?? ""}さん　${DateToAPIHelper.convertDateToString(applyDate)}のシフトの休日申請がありました。";
    }
    return NotificationModel(
      applyDate: json["applyDate"] != null ? json["applyDate"].toDate() : DateTime.now(),
        jobId: json["jobId"] ?? "",
        jobPostingId: json["jobPostingId"] ?? "",
        isRead: json["isRead"] ?? false,
        isJobApply: json["isJobApply"] ?? false,
        isRequest: json["isRequest"] ?? false,
        userId: json["user_id"],
        title: json["isJobApply"] == true ? "応募者からの求人応募" : json["message"]["text"].toString(),
        shortDes: shortDes,
        des: json["message"]["text"],
        date: json["delivery"]["startTime"].toDate());
  }
}
