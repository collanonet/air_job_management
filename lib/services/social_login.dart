import 'package:air_job_management/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/user_api.dart';

class SocialLogin {
  Future<MyUser?> googleSign() async {
    try {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      GoogleSignIn _googleSignIn = GoogleSignIn(
        // Optional clientId
        // clientId: 'your-client_id.apps.googleusercontent.com',
        scopes: scopes,
      );

      var googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var cre = await FirebaseAuth.instance.signInWithCredential(credential);
      if (cre.user != null) {
        MyUser? users = await UserApiServices().getProfileUser(cre.user!.uid);
        return users;
      }
      return null;
    } catch (e) {
      print("Error google sign in $e");
      return null;
    }
  }
}
