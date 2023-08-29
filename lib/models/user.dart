class MyUser {
  String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  MyUser({this.email, this.firstName, this.lastName, this.uid, this.role});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(firstName: json["first_name"] ?? "", lastName: json["last_name"] ?? "", role: json["role"] ?? "", email: json["email"] ?? "");
  }
}
