import 'package:air_job_management/pages/register/verify_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/page_route.dart';
import '../../utils/respnsive.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading.dart';

bool isFullTimeGlobal = false;

class RegisterPage extends StatefulWidget {
  final bool isFullTime;
  const RegisterPage({Key? key, required this.isFullTime}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirmPassword = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController id = TextEditingController(text: "");
  late AuthProvider authProvider;
  bool isSecure = true;
  bool isSecure1 = true;
  DateTime dateTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  String imageUrl = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    isFullTimeGlobal = widget.isFullTime;
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    // authProvider.onChangeLoading(false);
    return Form(
      key: _formKey,
      child: LoadingOverlay(
        isLoading: authProvider.isLoading,
        color: Colors.black.withOpacity(0.3),
        progressIndicator: LoadingWidget(AppColor.primaryColor),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: AppSize.getDeviceWidth(context) * 0.95,
                  height: AppSize.getDeviceHeight(context) * 0.96,
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Icon(Icons.arrow_back_ios_new_rounded,
                                          color: AppColor.primaryColor),
                                      AppSize.spaceWidth8,
                                      Text("戻る",
                                          style: kNormalText.copyWith(
                                            color: AppColor.primaryColor,
                                          ))
                                    ])))),
                        Center(
                            child: Image.asset(
                          "assets/svgs/img.png",
                          width: AppSize.getDeviceWidth(context) *
                              (Responsive.isMobile(context) ? 0.6 : 0.3),
                        )),
                        Center(
                          child: Text(
                            "新規登録",
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        //Email & Pass
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID"),
                            AppSize.spaceHeight5,
                            PrimaryTextField(
                              controller: id,
                              hint: 'ID',
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(JapaneseText.email),
                            AppSize.spaceHeight5,
                            PrimaryTextField(
                              controller: email,
                              hint: JapaneseText.email,
                              isRequired: true,
                              isEmail: true,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("パスワード"),
                            AppSize.spaceHeight5,
                            Stack(
                              children: [
                                PrimaryTextField(
                                  controller: password,
                                  hint: "⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺",
                                  maxLine: 1,
                                  isObsecure: isSecure,
                                ),
                                Positioned(
                                    top: 0,
                                    right:
                                        AppSize.getDeviceWidth(context) * 0.1,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isSecure = !isSecure;
                                          });
                                        },
                                        icon: Icon(isSecure
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye)))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("パスワード（確認）"),
                            AppSize.spaceHeight5,
                            Stack(
                              children: [
                                PrimaryTextField(
                                  controller: confirmPassword,
                                  hint: "⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺",
                                  maxLine: 1,
                                  isObsecure: isSecure1,
                                ),
                                Positioned(
                                    top: 0,
                                    right:
                                        AppSize.getDeviceWidth(context) * 0.1,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isSecure1 = !isSecure1;
                                          });
                                        },
                                        icon: Icon(isSecure1
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye)))
                              ],
                            )
                          ],
                        ),
                        AppSize.spaceHeight16,
                        Center(
                          child: SizedBox(
                            width: AppSize.getDeviceWidth(context) *
                                (Responsive.isMobile(context) ? 0.6 : 0.4),
                            child: ButtonWidget(
                                title: "新規登録する",
                                color: AppColor.secondaryColor,
                                onPress: () => createAccount()),
                          ),
                        ),
                        // Test
                        // AppSize.spaceHeight16,
                        // Center(
                        //   child: SizedBox(
                        //     width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.20),
                        //     child: ButtonWidget(
                        //         title: "新規登録する",
                        //         color: AppColor.primaryColor,
                        //         onPress: () => MyPageRoute.goTo(context, VerifyUserEmailPage(myUser: MyUser(uid: "", email: "admin@gmail.com")))),
                        //   ),
                        // ),
                        AppSize.spaceHeight16,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createAccount() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (password.text == confirmPassword.text) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text)) {
          MyUser myUser = MyUser(
              nameKanJi: "",
              nameFu: "",
              lastName: "",
              firstName: "",
              role: "worker",
              uid: "",
              dob: "",
              email: email.text.trim(),
              gender: "");
          myUser.nameKanJi = "";
          myUser.isFullTimeStaff = widget.isFullTime;
          myUser.nameFu = "";
          myUser.note = "";
          myUser.email = email.text;
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
          MyUser? user = await authProvider.registerAccount(
              email.text.trim(), password.text.trim(), myUser);
          if (user != null) {
            MyPageRoute.goTo(
                context,
                VerifyUserEmailPage(
                  myUser: myUser,
                  isFullTime: widget.isFullTime,
                ));
          } else {
            if (FirebaseAuth.instance.currentUser != null) {
              await FirebaseAuth.instance.currentUser?.reload();
              bool isEmailVerified =
                  FirebaseAuth.instance.currentUser!.emailVerified;
              if (authProvider.errorMessage ==
                      "あなたのメールアドレスはすでに別のアカウントで使用されています。" &&
                  isEmailVerified == false) {
                MyPageRoute.goTo(
                    context,
                    VerifyUserEmailPage(
                      myUser: myUser,
                      isFullTime: widget.isFullTime,
                    ));
              } else {
                toastMessageError("${authProvider.errorMessage}", context);
              }
            } else {
              toastMessageError("${authProvider.errorMessage}", context);
            }
          }
        } else {
          toastMessageError("メールが無効です。", context);
        }
      } else {
        toastMessageError("パスワードと確認パスワードが一致しません。", context);
      }
    }
  }
}
