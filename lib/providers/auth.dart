import 'dart:io';

import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/role_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  MyUser? myUser;
  bool _isLogin = true;

  get errorMessage => _errorMessage;
  get isLoading => _isLoading;
  get isLogin => _isLogin;

  set setProfile(MyUser myUser) {
    this.myUser = myUser;
  }

  onChange(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  set initialLoading(isLoading) {
    _isLoading = isLoading;
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Future registerAccount(String email, String password, String fullName) async {
  //   try {
  //     setLoading(true);
  //     UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  //     print(authResult.user);
  //     User? user = authResult.user;
  //     String message = await ApiService().saveProfileUser(email: email.trim(), username: fullName, uid: user!.uid);
  //     _profile = Profile(uid: user.uid, email: email.trim(), fullName: fullName, imageUrl: ConstValue.defaultImage);
  //     await Future.delayed(Duration(seconds: 1));
  //     if (message == "success") {
  //       setLoading(false);
  //       return user;
  //     } else {
  //       setLoading(false);
  //       await logout();
  //       setErrorMessage(message);
  //       return null;
  //     }
  //   } on SocketException {
  //     setLoading(false);
  //     setErrorMessage("No internet, please connect to internet");
  //     return null;
  //   } catch (e) {
  //     await Future.delayed(Duration(seconds: 1));
  //     setLoading(false);
  //     print(e);
  //     if (e.toString().contains("user-not-found")) {
  //       setErrorMessage("ユーザーが見つかりません");
  //     } else if (e.toString().contains("wrong-password")) {
  //       setErrorMessage("無効な,ID, パスワードです");
  //     } else if (e.toString().contains("invalid-email")) {
  //       setErrorMessage("無効なメールアドレス");
  //     } else {
  //       setErrorMessage("何かがうまくいかなかった");
  //     }
  //     notifyListeners();
  //     return null;
  //   }
  // }

  Future<MyUser?> loginAccount(String email, String password) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
      User? user = authResult.user;
      myUser = await UserApiServices().getProfileUser(user!.uid);
      setLoading(false);
      if (myUser != null && (myUser!.role == RoleHelper.admin || myUser!.role == RoleHelper.subManager)) {
        return myUser;
      } else {
        await logout();
        setErrorMessage("権限がありません。");
        return null;
      }
    } on SocketException {
      setLoading(false);
      setErrorMessage("No internet, please connect to internet");
      return null;
    } catch (e) {
      print("Error $e");
      setLoading(false);
      if (e.toString().contains("user-not-found")) {
        setErrorMessage("ユーザーが見つかりません");
      } else if (e.toString().contains("wrong-password")) {
        setErrorMessage("無効な,ID, パスワードです");
      } else if (e.toString().contains("invalid-email")) {
        setErrorMessage("無効なメールアドレス");
      } else {
        setErrorMessage("何かがうまくいかなかった");
      }
      notifyListeners();
      return null;
    }
  }

  Stream<User?> get user => firebaseAuth.authStateChanges().map((event) => event);

  logout() async {
    await firebaseAuth.signOut();
  }

  setLoading(isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setErrorMessage(msg) {
    _errorMessage = msg;
    debugPrint("Error is $msg");
    notifyListeners();
  }
}
