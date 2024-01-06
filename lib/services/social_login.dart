import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/user_api.dart';

class SocialLogin {
  Future<MyUser?> googleSign(bool isFullTime, AuthProvider authProvider) async {
    try {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      GoogleSignIn _googleSignIn = GoogleSignIn(
        // Optional clientId
        clientId:
            '466227911476-j3kt4hamafqcq8eo77blopltjit9k7ok.apps.googleusercontent.com',
        scopes: scopes,
      );

      bool isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        await _googleSignIn.signOut();
      }

      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = kIsWeb
          ? await (googleSignIn.signInSilently())
          : await (googleSignIn.signIn());

      if (kIsWeb && googleSignInAccount == null)
        googleSignInAccount = await (googleSignIn.signIn());

      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var cre = await FirebaseAuth.instance.signInWithCredential(credential);
      if (cre.user != null) {
        MyUser? users = await UserApiServices().getProfileUser(cre.user!.uid);
        if (users != null) {
          return users;
        } else {
          MyUser myUser = MyUser(
              nameKanJi: "",
              nameFu: "",
              lastName: "",
              firstName: "",
              role: "worker",
              uid: "",
              dob: "",
              email: cre.user?.email,
              gender: "");
          myUser.nameKanJi = "";
          myUser.isFullTimeStaff = isFullTime;
          myUser.nameFu = "";
          myUser.note = "";
          myUser.email = cre.user?.email;
          myUser.dob = "";
          myUser.phone = "";
          myUser.interviewDate = "";
          myUser.finalEdu = "";
          myUser.graduationSchool = "";
          myUser.academicBgList = [];
          myUser.workHistoryList = [];
          myUser.ordinaryAutomaticLicence = "";
          myUser.otherQualificationList = [];
          myUser.employmentHistoryList = [];
          return await authProvider.registerAccount(
              cre.user!.email!, cre.user!.email!.split("@")[0], myUser);
        }
      }
      return null;
    } catch (e) {
      print("Error google sign in $e");
      return null;
    }
  }
}
