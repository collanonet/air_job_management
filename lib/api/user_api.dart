import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/encrypt_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../const/const.dart';

class UserApiServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference userRef = FirebaseFirestore.instance.collection('user');
  final CollectionReference jobRef = FirebaseFirestore.instance.collection('job');
  final CollectionReference companyRef = FirebaseFirestore.instance.collection('company');

  Future<String?> saveUserData(MyUser myUser) async {
    try {
      await userRef.doc(myUser.uid).set(myUser.toJson());
      return "success";
    } catch (e) {
      print("Error =>> ${e.toString()}");
      return null;
    }
  }

  updateUserData(MyUser myUser) async {
    try {
      await userRef.doc(myUser.uid).update(myUser.toJson());
      return "success";
    } catch (e) {
      print("Error updateUserData =>> ${e.toString()}");
      return e.toString();
    }
  }

  updateUserAField({required String uid, required String value, required String field}) async {
    try {
      await userRef.doc(uid).update({field: value});
      return "success";
    } catch (e) {
      print("Error update $field =>> ${e.toString()}");
      return e.toString();
    }
  }

  Future<void> updateEmail(String hashPass, String oldEmail, String newEmail) async {
    try {
      print("$hashPass Hash, $oldEmail, $newEmail");
      String pass = EncryptUtils.decryptedPassword(hashPass);
      print("$pass pass, $oldEmail, $newEmail");
      var credential = await f.FirebaseAuth.instance.signInWithEmailAndPassword(email: oldEmail, password: pass);
      credential.user?.updateEmail(newEmail);
      print("updateEmail success");
    } catch (e) {
      print("Error updateEmail =>> ${e.toString()}");
    }
  }

  Future<String?> createUserAccount(String email, String password, MyUser myUser) async {
    try {
      var credential = await f.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String encryptedPassword = EncryptUtils.encryptPassword(password);
      if (credential.user != null) {
        String uid = credential.user!.uid;
        myUser.uid = uid;
        myUser.hash_password = encryptedPassword;
        await userRef.doc(uid).set(myUser.toJson());
        return "success";
      }
      return ConstValue.success;
    } catch (e) {
      print("Error updateEmail =>> ${e.toString()}");
      return "$e";
    }
  }

  Future<List<MyUser>> getAllUser() async {
    try {
      var doc = await userRef.get();
      if (doc.docs.isNotEmpty) {
        List<MyUser> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          MyUser myUser = MyUser.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          myUser.uid = doc.docs[i].id;
          list.add(myUser);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print("Error getAllUser =>> ${e.toString()}");
      return [];
    }
  }

  Future<MyUser?> getProfileUser(String uid) async {
    print("Get profile $uid");
    try {
      DocumentSnapshot doc = await userRef.doc(uid).get();
      if (doc.exists) {
        MyUser profile = MyUser.fromJson(doc.data() as Map<String, dynamic>);
        profile.uid = doc.id;
        return profile;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getProfileUser =>> ${e.toString()}");
      return null;
    }
  }

  Future<Company?> getProfileCompany(String uid) async {
    try {
      var doc = await companyRef.where("company_user_id", isEqualTo: uid).get();
      if (doc.docs.isNotEmpty) {
        Company company = Company.fromJson(doc.docs.first.data() as Map<String, dynamic>);
        company.uid = doc.docs.first.id;
        return company;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getProfileCompany =>> ${e.toString()}");
      return null;
    }
  }

  Future<bool> getUserEmailByID(String uid) async {
    try {
      var doc = await userRef.where("staff_number", isEqualTo: uid).orderBy("last_name", descending: true).get();
      if (doc.size > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error getUserEmailByID $e");
      return false;
    }
  }

  Future<List<JobApply>> getJobByWorkerId(String id) async {
    try {
      var doc = await jobRef.where("user_id", isEqualTo: id).get();
      if (doc.size > 0) {
        List<JobApply> jobList = [];
        for (var data in doc.docs) {
          var job = JobApply.fromJson(data.data() as Map<String, dynamic>);
          jobList.add(job);
        }
        return jobList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getJobByWorkerId =>> ${e.toString()}");
      return [];
    }
  }
}

class JobApply {
  String? status;
  DateTime? createdAt;
  String? userId;
  String? jobId;
  JobApply({this.status, this.createdAt, this.userId, this.jobId});

  factory JobApply.fromJson(Map<String, dynamic> json) => JobApply(
        status: json["status"],
        jobId: json["job_id"],
        createdAt: json["created_at"].toDate(),
        userId: json["user_id"],
      );
}
