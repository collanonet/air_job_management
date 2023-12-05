class Myjob {
  DateTime? createAt;
  String? jobId;
  String? status;
  String? uid;
  String? uname;

  Myjob({
    this.createAt,
    this.jobId,
    this.status,
    this.uid,
    this.uname,
  });

  factory Myjob.fromJson(Map<String, dynamic> json) {
    return Myjob(
      createAt: json["created_at"] != null ? json["created_at"].toDate() : null,
      jobId: json["job_id"],
      status: json["status"],
      uid: json["user_id"],
      uname: json["username"],
    );
  }
}
