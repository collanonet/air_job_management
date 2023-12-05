
import 'package:cloud_firestore/cloud_firestore.dart';

class PenaltyWorkModel{
  Timestamp createAt;
  String reason;
  String title;
  String workerID;
  String workerName;

  PenaltyWorkModel({
    required this.createAt,
    required this.reason,
    required this.title,
    required this.workerID,
    required this.workerName
  });
  factory PenaltyWorkModel.fromJson(Map<String, dynamic> json) {
    return PenaltyWorkModel(
      createAt: json["created_at"],
      reason: json["reason"] ,
      title: json["title"],
      workerID: json["worker_id"],
      workerName: json["worker_name"],
    );
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['created_at'] = createAt;
    data['reason'] = reason;
    data['title'] = title;
    data['worker_id'] = workerID;
    data['worker_name'] = workerName;
    return data;
  }
}