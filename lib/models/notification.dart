import 'package:air_job_management/utils/japanese_text.dart';

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
      title: json["message"]["text"].toString().contains("rejected") ||
              json["message"]["text"].toString().contains("approved") ||
              json["message"]["text"].toString().contains("この度就業開始時間の変更申請を受領しました。") ||
              json["message"]["text"].toString().contains("宜しくお願い致します。") ||
              json["message"]["text"].toString().contains("この度早退申請を受領しました。") ||
              json["message"]["text"].toString().contains("直接ご相談させる場合は、ご担当者まで連絡ください。") ||
              json["message"]["text"].toString().contains("この度休日申請を受領しました。") ||
              json["message"]["text"].toString().contains("申請頂いた日時については") ||
              json["message"]["text"].toString().contains("この度早退申請を受領しました。") ||
              json["message"]["text"].toString().contains("この度就業終了時間の変更申請を受領しました。")
          ? "ワーカーから変更申請"
          : json["message"]["text"].toString().contains("request") ||
                  json["message"]["text"].toString().contains("この度は掲載求人にご応募頂きまして、誠にありがとうございます。") ||
                  json["message"]["text"].toString().contains("残念ながらシフトのマッチングができませんでした。") ||
                  json["message"]["text"].toString().contains("request") ||
                  json["message"]["text"].toString().contains("request") ||
                  json["message"]["text"].toString().contains("request")
              ? "ワーカーからの変更申請などは"
              : json["message"]["text"].toString().contains("job applied") ||
                      json["message"]["text"].toString().contains("この度は掲載求人にご応募頂きまして、誠にありがとうございます。")
                  ? "応募者からの求人応募"
                  : JapaneseText.empty,
      des: json["message"]["text"],
      date: json["delivery"]["startTime"].toDate());
}
