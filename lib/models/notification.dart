class NotificationModel {
  String? uid;
  String? title;
  String? des;
  String? companyId;
  String? companyName;
  DateTime? date;
  NotificationModel(
      {this.title,
      this.date,
      this.des,
      this.uid,
      this.companyId,
      this.companyName});
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          title: json["message"]["text"].toString().contains("request")
              ? "作業員からのお願い"
              : "労働者からの求人応募",
          des: json["message"]["text"],
          date: json["delivery"]["startTime"].toDate());
}
