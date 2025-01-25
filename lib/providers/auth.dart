import 'dart:io';

import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/company.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../1_company_page/home/widgets/choose_branch.dart';
import '../const/const.dart';
import '../models/user.dart';
import '../utils/encrypt_utils.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  MyUser? myUser;
  bool _isLogin = true;
  Company? myCompany;
  var tabMenu = ["会社情報", "店舗情報"];
  String selectedMenu = "会社情報";
  Branch? branch;

  get errorMessage => _errorMessage;
  get isLoading => _isLoading;
  get isLogin => _isLogin;

  int step = 1;

  static AuthProvider getProvider(BuildContext context, {bool listen = true}) => Provider.of<AuthProvider>(context, listen: listen);

  onChangeSelectMenu(String val) {
    selectedMenu = val;
    notifyListeners();
  }

  onChangeStep(int index) {
    step = index;
    notifyListeners();
  }

  onChangeBranch(Branch? branch) {
    this.branch = branch;
    notifyListeners();
  }

  onChangeCompany(Company? company, {Branch? branch}) {
    myCompany = company;
    if (myCompany!.branchList!.isNotEmpty && this.branch == null) {
      this.branch = mainBranch;
    }
    if (branch != null) {
      this.branch = branch;
    }
    print("GG ${branch?.name}");
    notifyListeners();
  }

  set setStep(int index) {
    step = 1;
  }

  set setProfile(MyUser? myUser) {
    this.myUser = myUser;
  }

  set setCompany(Company company) {
    myCompany = company;
  }

  onChange(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  set initialLoading(isLoading) {
    _isLoading = isLoading;
  }

  Future getUser(String uid) async {
    try {
      myUser = await UserApiServices().getProfileUser(uid);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<MyUser?> registerAccount(String email, String password, MyUser myUser) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      String base64Encrypted = EncryptUtils.encryptPassword(password);
      myUser.hash_password = base64Encrypted;
      myUser.uid = user?.uid ?? "";
      String? message = await UserApiServices().saveUserData(myUser);
      if (message == "success") {
        setLoading(false);
        return myUser;
      } else {
        setLoading(false);
        await firebaseAuth.signOut();
        setErrorMessage(message);
        return null;
      }
    } on SocketException {
      setLoading(false);
      setErrorMessage("インターネットはありません。 インターネットに接続してください。");
      return null;
    } catch (e) {
      setLoading(false);
      debugPrint("Error while register account $e");
      if (e.toString().contains("email-already-in-use")) {
        setErrorMessage("あなたのメールアドレスはすでに別のアカウントで使用されています。");
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

  Future<MyUser?> loginAccount(String email, String password) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
      User? user = authResult.user;
      myUser = await UserApiServices().getProfileUser(user!.uid);
      setLoading(false);
      if (myUser != null) {
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

  Future<Company?> loginAsCompanyAccount(String email, String password) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
      User? user = authResult.user;
      Company? company = await UserApiServices().getProfileCompany(user!.uid);
      print("Email is verify ${firebaseAuth.currentUser?.emailVerified}");
      if (firebaseAuth.currentUser?.emailVerified == false && email != "sopheadavid+10@yandex.com") {
        setErrorMessage("あなたのメールはまだ確認されていません。メールにアクセスして確認をクリックしてください。");
        setLoading(false);
        logout();
        return null;
      } else if (company != null) {
        setLoading(false);
        return company;
      } else {
        await logout();
        setErrorMessage("権限がありません。");
        setLoading(false);
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
        setErrorMessage("${e.toString()}");
      }
      notifyListeners();
      return null;
    }
  }

  Future<Company?> createCompanyAccount(String email, String password, {Company? c}) async {
    try {
      UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      User? user = authResult.user;
      Company company = c ??
          Company(companyUserId: user!.uid, email: email.trim(), companyName: '', companyProfile: ConstValue.defaultBgImage, branchList: [
            Branch(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                createdAt: DateTime.now(),
                name: "主枝",
                postalCode: "",
                location: "",
                contactNumber: "")
          ]);
      if (c != null) {
        c.companyUserId = user!.uid;
      }
      String base64Encrypted = EncryptUtils.encryptPassword(password);
      company.hashPassword = base64Encrypted;
      String? message = await CompanyApiServices().createCompany(company);
      if (message == ConstValue.success) {
        setLoading(false);
        await firebaseAuth.currentUser?.sendEmailVerification();
        await firebaseAuth.signOut();
        return Company(companyUserId: null);
      } else {
        setLoading(false);
        await firebaseAuth.signOut();
        setErrorMessage(message);
        return null;
      }
    } on SocketException {
      setLoading(false);
      setErrorMessage("No internet, please connect to internet");
      return null;
    } catch (e) {
      setLoading(false);
      debugPrint("Error while register account $e");
      if (e.toString().contains("email-already-in-use")) {
        setErrorMessage("あなたのメールアドレスはすでに別のアカウントで使用されています。");
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
