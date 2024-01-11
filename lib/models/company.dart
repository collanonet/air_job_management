class Company {
  String? companyUserId;
  String? companyName;
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
  String? uid;
  String? status;
  String? area;
  String? industry;
  String? numberOfJobOpening;

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
      this.status});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
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
        rePresentative: json["re_presentative"] == null
            ? null
            : RePresentative.fromJson(json["re_presentative"]),
        manager: json["manager"] == null
            ? []
            : List<RePresentative>.from(
                json["manager"]!.map((x) => RePresentative.fromJson(x))),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
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
        "manager": manager == null
            ? []
            : List<dynamic>.from(manager!.map((x) => x.toJson())),
        "content": content,
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
