import 'package:air_job_management/utils/japanese_text.dart';

class MyUser {
  String? balance;
  String? rating;
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
  String? interviewDate;
  String? finalEdu;
  String? graduationSchool;
  List<String>? academicBgList;
  List<String>? workHistoryList;
  String? ordinaryAutomaticLicence;
  List<String>? otherQualificationList;
  List<String>? employmentHistoryList;
  String? verifyDoc;
  String? postalCode;
  String? province;
  String? city;
  String? street;
  String? building;
  bool? notWorking;
  bool? contractJob;
  bool? fullTimeJob;
  bool? temporary;
  bool? partTimeJob;
  bool? isFullTimeStaff;
  String? affiliation;
  String? qualificationFields;

  MyUser(
      {this.affiliation,
      this.qualificationFields,
      this.jobStatus,
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
      this.gender,
      this.employmentHistoryList,
      this.academicBgList,
      this.finalEdu,
      this.graduationSchool,
      this.interviewDate,
      this.ordinaryAutomaticLicence,
      this.otherQualificationList,
      this.workHistoryList,
      this.verifyDoc,
      this.postalCode,
      this.province,
      this.city,
      this.street,
      this.building,
      this.notWorking,
      this.contractJob,
      this.fullTimeJob,
      this.temporary,
      this.partTimeJob,
      this.balance,
      this.isFullTimeStaff});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      uid: json["uid"],
      qualificationFields: json["qualification_fields"],
      affiliation: json["affiliation"],
      isFullTimeStaff: json["is_full_time_staff"] ?? false,
      balance: json["balance"] ?? "",
      verifyDoc: json["verifyDoc"] ?? "",
      postalCode: json["postalCode"] ?? "",
      province: json["province"] ?? "",
      city: json["city"] ?? "",
      building: json["building"] ?? "",
      notWorking: json["notWorking"] ?? false,
      contractJob: json["contractJob"] ?? false,
      fullTimeJob: json["fullTimeJob"] ?? false,
      temporary: json["temporary"] ?? false,
      partTimeJob: json["partTimeJob"] ?? false,
      gender: json["gender"] ?? "",
      workingStatus: (json["working_status"] != null && json["working_status"] != "") ? json["working_status"] : JapaneseText.noContact,
      profileImage: json["profile"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      role: json["role"] ?? "worker",
      email: json["email"] ?? "",
      status: json["status"] ?? JapaneseText.free,
      dob: json["dob"] ?? "2000-10-10",
      nameFu: json["name_fu"] ?? "",
      nameKanJi: json["name_kanji"] ?? "",
      note: json["note"] ?? "",
      phone: json["phone"] ?? "",
      jobDetail: json["job_detail"] ?? "",
      jobId: json["job_id"] ?? "",
      jobTitle: json["job_title"] ?? "",
      messageList: json["message_list"] != null ? List<String>.from(json["message_list"].map((e) => e)) : [],
      hash_password: json["hash_password"],
      interviewDate: json["interviewDate"] ?? "",
      finalEdu: json["finalEdu"] ?? "",
      graduationSchool: json["graduationSchool"] ?? "",
      academicBgList: json["academicBgList"] != null ? List<String>.from(json["academicBgList"].map((e) => e)) : [],
      workHistoryList: json["workHistoryList"] != null ? List<String>.from(json["workHistoryList"].map((e) => e)) : [],
      ordinaryAutomaticLicence: json["ordinaryAutomaticLicence"] ?? "",
      employmentHistoryList: json["employmentHistoryList"] != null ? List<String>.from(json["employmentHistoryList"].map((e) => e)) : [],
      otherQualificationList: json["otherQualificationList"] != null ? List<String>.from(json["otherQualificationList"].map((e) => e)) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "profile": profileImage,
        "message_list": messageList != null ? messageList!.map((e) => e) : [],
        "first_name": firstName,
        "email": email,
        "role": role,
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
        "working_status": workingStatus ?? "",
        "interviewDate": interviewDate,
        "finalEdu": finalEdu,
        "graduationSchool": graduationSchool,
        "academicBgList": academicBgList != null ? academicBgList!.map((e) => e) : [],
        "workHistoryList": workHistoryList != null ? workHistoryList!.map((e) => e) : [],
        "ordinaryAutomaticLicence": ordinaryAutomaticLicence,
        "employmentHistoryList": employmentHistoryList != null ? employmentHistoryList!.map((e) => e) : [],
        "otherQualificationList": otherQualificationList != null ? otherQualificationList!.map((e) => e) : [],
        'verifyDoc': verifyDoc,
        'postalCode': postalCode,
        'province': province,
        'city': city,
        'building': building,
        'notWorking': notWorking,
        'contractJob': contractJob,
        'temporary': temporary,
        'partTimeJob': partTimeJob,
        'fullTimeJob': fullTimeJob
      };
}
