import 'package:air_job_management/utils/encrypt_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_storage/firebase_storage.dart';

class StaffApiServices {
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
}
