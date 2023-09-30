import 'package:air_job_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class JobPostingApiService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference userRef = FirebaseFirestore.instance.collection('search_job');

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
    try {
      DocumentSnapshot doc = await userRef.doc(uid).get();
      if (doc.exists) {
        MyUser profile = MyUser.fromJson(doc.data() as Map<String, dynamic>);
        return profile;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getProfileUser =>> ${e.toString()}");
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
}
