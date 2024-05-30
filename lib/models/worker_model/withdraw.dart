import 'package:cloud_firestore/cloud_firestore.dart';

class Withdraw {
  String? uid;
  String? amount;
  Timestamp? createAt;
  String? date;
  String? status;
  String? time;
  Timestamp? updatedAt;
  String? workerID;
  String? workerName;

  Withdraw({this.uid, this.amount, this.createAt, this.date, this.status, this.time, this.updatedAt, this.workerID, this.workerName});
  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      amount: json["amount"] ?? "0",
      createAt: json["created_at"],
      date: json["date"],
      status: json["status"],
      time: json["time"],
      updatedAt: json["updated_at"],
      workerID: json["worker_id"],
      workerName: json["worker_name"],
    );
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['created_at'] = createAt;
    data['date'] = date;
    data['status'] = status;
    data['time'] = time;
    data['updated_at'] = updatedAt;
    data['worker_name'] = workerName;
    return data;
  }
}
