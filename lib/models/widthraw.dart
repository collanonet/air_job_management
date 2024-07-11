class WithdrawModel {
  String? uid;
  String? amount;
  DateTime? createdAt;
  String? date;
  String? status;
  String? time;
  DateTime? updatedAt;
  String? workerID;
  String? workerName;
  BankModel? bankModel;
  String? reason;
  String? transactionImageUrl;
  String? moreTransportationFee;
  WithdrawModel(
      {this.uid,
      this.bankModel,
      this.date,
      this.status,
      this.createdAt,
      this.time,
      this.amount,
      this.updatedAt,
      this.workerID,
      this.workerName,
      this.reason,
      this.transactionImageUrl,
      this.moreTransportationFee});

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
        moreTransportationFee: json["more_transportation_fee"] ?? "0",
        transactionImageUrl: json["transactionImageUrl"],
        reason: json["reason"],
        createdAt: json["created_at"].toDate(),
        date: json["date"],
        amount: json["amount"] ?? "0",
        bankModel: json["bank"] != null ? BankModel.fromJson(json["bank"]) : null,
        status: json["status"],
        time: json["time"],
        updatedAt: json["updated_at"].toDate(),
        workerID: json["worker_id"],
        workerName: json["worker_name"].toString().replaceAll(" ", ""),
      );
}

class BankModel {
  String? fullName;
  String? bankId;
  String? uid;
  String? bankName;
  String? userId;
  bool? isChecked;
  BankModel({this.bankId, this.fullName, this.bankName, this.isChecked, this.uid, this.userId});

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
      bankName: json["bankName"], userId: json["userId"], fullName: json["fullName"], bankId: json["bankId"], isChecked: json["isChecked"] ?? false);

  Map<String, dynamic> toJson() => {"bankName": bankName, "fullName": fullName, "bankId": bankId, "isChecked": isChecked, "userId": userId};
}
