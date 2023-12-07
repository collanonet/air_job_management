import 'package:air_job_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class APIs {
// for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static MyUser me = MyUser(
    lastName: '',
    firstName: '',
    role: '',
    uid: user.uid.toString(),
    dob: '',
    email: user.email.toString(),
    profileImage: user.photoURL.toString(),
    gender: '',
  );

  // to return current user
  static User get user => auth.currentUser!;
  // update profile picture of user
  static Future<void> updateProfilePicture(Uint8List file) async {
    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.jpg');
    //uploading image
    await ref.putData(file);

    //updating image in firestore database
    me.profileImage = await ref.getDownloadURL();
    await firestore.collection('user').doc(user.uid).update({'profile': me.profileImage});
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'first_name': me.firstName,
      'gender': me.gender,
    });
  }

  Future<bool> updateProfile(
      {required String uid, required String profile, required String fullName, required String gender, required String dob}) async {
    try {
      String firstName = "";
      String lastName = "";
      if (fullName.contains(" ")) {
        lastName = fullName.split(" ")[0];
        firstName = fullName.split(" ")[1];
      }
      if (firstName.isNotEmpty) {
        await firestore
            .collection('user')
            .doc(uid)
            .update({"profile": profile, "full_name": fullName, "gender": gender, "first_name": firstName, "last_name": lastName, "dob": dob});
      } else {
        await firestore.collection('user').doc(uid).update({"profile": profile, "full_name": fullName, "gender": gender, "dob": dob});
      }

      return true;
    } catch (e) {
      print("Error =>> ${e.toString()}");
      return false;
    }
  }

  final CollectionReference _tbstudent = FirebaseFirestore.instance.collection('tbstudent');
}
