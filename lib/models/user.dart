import 'package:air_job_management/utils/japanese_text.dart';

class MyUser {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? nameKanJi;
  String? nameFu;
  String? phone;
  String? dob;
  String? note;
  String? hash_password;
  String? profileImage;
  String? workingStatus;
  String? jobDetail;
  String? jobTitle;
  String? jobId;
  String? status;
  String? gender;
  String? jobStatus;
  List<String>? messageList;

  MyUser(
      {this.jobStatus,
      this.messageList,
      this.email,
      this.firstName,
      this.lastName,
      this.uid,
      this.role,
      this.note,
      this.phone,
      this.nameKanJi,
      this.dob,
      this.nameFu,
      this.hash_password,
      this.profileImage,
      this.workingStatus,
      this.jobDetail,
      this.jobTitle,
      this.status,
      this.jobId,
      this.gender});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        gender: json["gender"] ?? "",
        workingStatus:
            (json["working_status"] != null && json["working_status"] != "")
                ? json["working_status"]
                : JapaneseText.noContact,
        profileImage: json["profile"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        role: json["role"] ?? "",
        email: json["email"] ?? "",
        status: json["status"] ?? JapaneseText.free,
        dob: json["dob"] ?? "",
        nameFu: json["name_fu"] ?? "",
        nameKanJi: json["name_kanji"] ?? "",
        note: json["note"] ?? "",
        phone: json["phone"] ?? "",
        jobDetail: json["job_detail"] ?? "",
        jobId: json["job_id"] ?? "",
        jobTitle: json["job_title"] ?? "",
        messageList: json["message_list"] != null
            ? List<String>.from(json["message_list"].map((e) => e))
            : [],
        hash_password: json["hash_password"]);
  }

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "profile": profileImage,
        "message_list": messageList != null ? messageList!.map((e) => e) : [],
        "first_name": firstName,
        "email": email,
        "role": "staff",
        "dob": dob ?? "",
        "name_fu": nameFu,
        "name_kanji": nameKanJi,
        "note": note,
        "uid": uid,
        "phone": phone,
        "hash_password": hash_password,
        "last_name": lastName,
        "job_detail": jobDetail,
        "job_title": jobTitle,
        "job_id": jobId,
        "gender": gender ?? "",
        "working_status": workingStatus ?? ""
      };
}
