
class PrivacyModel{
  String privacy_url;
  String term_of_use;
  String withdraw_procedures;

  PrivacyModel({
    required this.privacy_url,
    required this.term_of_use,
    required this.withdraw_procedures,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      privacy_url: json["privacy_url"] ,
      term_of_use: json["term_of_use"],
      withdraw_procedures: json["withdraw_procedures"],
    );
  }
}