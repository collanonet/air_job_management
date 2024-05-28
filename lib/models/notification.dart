class NotificationModel {
  String? uid;
  String? title;
  String? des;
  String? companyId;
  String? userId;
  String? companyName;
  DateTime? date;
  NotificationModel({this.title, this.date, this.des, this.uid, this.userId, this.companyId, this.companyName});
  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
      userId: json["user_id"],
      title: json["message"]["text"].toString().contains("rejected") || json["message"]["text"].toString().contains("approved")
          ? "ワーカーから変更申請"
          : json["message"]["text"].toString().contains("request")
              ? "ワーカーからの変更申請などは"
              : json["message"]["text"].toString().contains("job applied")
                  ? "応募者からの求人応募"
                  : "",
      des: json["message"]["text"],
      date: json["delivery"]["startTime"].toDate());
}
