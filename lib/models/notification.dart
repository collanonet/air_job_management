class NotificationModel {
  String? uid;
  String? title;
  String? des;
  DateTime? date;
  NotificationModel({this.title, this.date, this.des, this.uid});
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(title: json["title"], des: json["description"], date: json["date"].toDate());
}
