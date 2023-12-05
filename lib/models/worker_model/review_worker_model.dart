
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewWorkModel{
  String? companyId;
  String companyName;
  Timestamp createAt;
  String star;
  String title;
  String workerID;
  String workerName;

  ReviewWorkModel({
    this.companyId,
    required this.companyName,
    required this.createAt,
    required this.star,
    required this.title,
    required this.workerID,
    required this.workerName
  });
  factory ReviewWorkModel.fromJson(Map<String, dynamic> json) {
    return ReviewWorkModel(
      companyId: json["company_id"] ,
      companyName: json["company_name"] ,
      createAt: json["created_at"],
      star: json["star"],
      title: json["title"],
      workerID: json["worker_id"],
      workerName: json["worker_name"],
    );
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['created_at'] = createAt;
    data['star'] = star;
    data['title'] = title;
    data['worker_id'] = workerID;
    data['worker_name'] = workerName;
    return data;
  }
}