class Company {
  String? managerNameKhanJi;
  String? managerNameFu;
  String? managerPhone;
  String? managerEmail;
  String? managerPassword;
  String? companyUserId;
  String? companyName;
  String? companyBranch;
  String? companyLatLng;
  String? companyProfile;
  String? postalCode;
  String? location;
  String? capital;
  String? publicDate;
  String? tel;
  String? tax;
  String? email;
  String? homePage;
  String? affiliate;
  RePresentative? rePresentative;
  List<RePresentative>? manager;
  String? content;
  String? remark;
  String? uid;
  String? status;
  String? area;
  String? industry;
  String? numberOfJobOpening;
  String? hashPassword;
  List<Branch>? branchList;

  Company(
      {this.uid,
      this.area,
      this.industry,
      this.companyName,
      this.companyLatLng,
      this.companyProfile,
      this.postalCode,
      this.location,
      this.capital,
      this.publicDate,
      this.homePage,
      this.affiliate,
      this.rePresentative,
      this.manager,
      this.content,
      this.email,
      this.tax,
      this.tel,
      this.numberOfJobOpening,
      this.companyUserId,
      this.status,
      this.hashPassword,
      this.companyBranch,
      this.remark,
      this.managerEmail,
      this.managerPassword,
      this.managerNameFu,
      this.managerNameKhanJi,
      this.managerPhone,
      this.branchList});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        managerEmail: json["managerEmail"],
        managerPassword: json["managerPassword"],
        managerNameFu: json["managerNameFu"],
        managerNameKhanJi: json["managerNameKhanJi"],
        managerPhone: json["managerPhone"],
        remark: json["remark"],
        companyBranch: json["company_branch"],
        hashPassword: json["hash_password"],
        companyUserId: json["company_user_id"],
        area: json["area"],
        industry: json["industry"],
        companyLatLng: json["lat_lng"],
        status: json["status"],
        tel: json["tel"],
        tax: json["tax"],
        email: json["email"],
        companyName: json["company_name"],
        companyProfile: json["company_profile"],
        postalCode: json["postal_code"],
        location: json["location"],
        capital: json["capital"],
        publicDate: json["public_date"],
        homePage: json["home_page"],
        affiliate: json["affiliate"],
        rePresentative: json["re_presentative"] == null ? null : RePresentative.fromJson(json["re_presentative"]),
        manager: json["manager"] == null ? [] : List<RePresentative>.from(json["manager"]!.map((x) => RePresentative.fromJson(x))),
        content: json["content"],
        branchList: json["branch"] == null ? [] : List<Branch>.from(json["branch"]!.map((x) => Branch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "managerEmail": managerEmail,
        "managerPassword": managerPassword,
        "managerNameFu": managerNameFu,
        "managerNameKhanJi": managerNameKhanJi,
        "managerPhone": managerPhone,
        "remark": remark,
        "company_user_id": companyUserId,
        "hash_password": hashPassword,
        "area": area,
        "industry": industry,
        "lat_lng": companyLatLng,
        "tel": tel,
        "status": status,
        "tax": tax,
        "email": email,
        "company_name": companyName,
        "company_profile": companyProfile,
        "postal_code": postalCode,
        "location": location,
        "capital": capital,
        "public_date": publicDate,
        "home_page": homePage,
        "affiliate": affiliate,
        "re_presentative": rePresentative?.toJson(),
        "manager": manager == null ? [] : List<dynamic>.from(manager!.map((x) => x.toJson())),
        "branch": branchList == null ? [] : List<dynamic>.from(branchList!.map((x) => x.toJson())),
        "content": content,
      };
}

class Branch {
  String? id;
  String? name;
  String? postalCode;
  String? location;
  String? contactNumber;
  DateTime? createdAt;
  String? lat;
  String? lng;

  Branch({this.name, this.postalCode, this.location, this.createdAt, this.contactNumber, this.id, this.lat, this.lng});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
      lat: json["lat"],
      lng: json["lng"],
      id: json["id"],
      name: json["name"],
      postalCode: json["postalCode"],
      location: json["location"],
      contactNumber: json["contactNumber"],
      createdAt: json["createdAt"].toDate());

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "id": id,
        "name": name,
        "postalCode": postalCode,
        "location": location,
        "contactNumber": contactNumber,
        "createdAt": createdAt,
      };
}

class RePresentative {
  String? kanji;
  String? kana;

  RePresentative({
    this.kanji,
    this.kana,
  });

  factory RePresentative.fromJson(Map<String, dynamic> json) => RePresentative(
        kanji: json["kanji"],
        kana: json["kana"],
      );

  Map<String, dynamic> toJson() => {
        "kanji": kanji,
        "kana": kana,
      };
}
