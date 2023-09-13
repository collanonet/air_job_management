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

  MyUser(
      {this.email,
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
      this.workingStatus});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        workingStatus: json["working_status"] ?? "",
        profileImage: json["profile"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        role: json["role"] ?? "",
        email: json["email"] ?? "",
        dob: json["dob"],
        nameFu: json["name_fu"],
        nameKanJi: json["name_kanji"],
        note: json["note"],
        phone: json["phone"],
        hash_password: json["hash_password"]);
  }

  Map<String, dynamic> toJson() => {
        "profile": profileImage,
        "first_name": firstName,
        "email": email,
        "role": "staff",
        "dob": dob,
        "name_fu": nameFu,
        "name_kanji": nameKanJi,
        "note": note,
        "uid": uid,
        "phone": phone,
        "hash_password": hash_password,
        "last_name": lastName,
        "working_status": workingStatus ?? ""
      };
}
