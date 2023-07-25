import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/encrypt_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_storage/firebase_storage.dart';

class UserApiServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference userRef = FirebaseFirestore.instance.collection('users');

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
      print("Error =>> ${e.toString()}");
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
