import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_back_button.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../utils/app_size.dart';
import '../../widgets/loading.dart';
import '../utils/app_color.dart';
import '../utils/respnsive.dart';
import '../utils/style.dart';
import '../utils/toast_message_util.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController email;
  late TextEditingController password;
  bool isLoading = false;

  @override
  void initState() {
    email = TextEditingController(text: "");
    password = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black.withOpacity(0.3),
      progressIndicator: LoadingWidget(AppColor.whiteColor),
      child: Scaffold(
        backgroundColor: AppColor.bgPageColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.whiteColor,
              ),
              margin: EdgeInsets.all(Responsive.isDesktop(context) ? AppSize.getDeviceHeight(context) * 0.1 : 16),
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.9),
              height: AppSize.getDeviceHeight(context) - (Responsive.isDesktop(context) ? AppSize.getDeviceHeight(context) * 0.2 : 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButtonWidget(
                        textColor: AppColor.primaryColor,
                        onPress: () => context.go(MyRoute.login),
                      )),
                  AppSize.spaceHeight30,
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.25),
                      ),
                      Positioned(
                          right: 0,
                          left: 0,
                          bottom: -20,
                          child: Center(
                            child: Text(
                              "ページを忘れた",
                              style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ))
                    ],
                  ),
                  AppSize.spaceHeight30,
                  AppSize.spaceHeight30,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "パスワードをリセットするにはメールアドレスを入力してください",
                      style: kNormalText,
                    ),
                  ),
                  AppSize.spaceHeight30,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
                        child: Text(
                          "メールアドレス",
                          style: kNormalText,
                        ),
                      )),
                  AppSize.spaceHeight8,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
                    child: PrimaryTextField(
                      controller: email,
                      hint: 'メールアドレス',
                    ),
                  ),
                  AppSize.spaceHeight16,
                  AppSize.spaceHeight16,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
                    child: SizedBox(
                        width: AppSize.getDeviceWidth(context), child: ButtonWidget(onPress: () => onRequestResetClick(), title: "パスワード再設定")),
                  ),
                  AppSize.spaceHeight16,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onRequestResetClick() async {
    FocusScope.of(context).unfocus();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (email.text.isNotEmpty) {
      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text)) {
        setState(() {
          isLoading = true;
        });
        try {
        await firebaseAuth.sendPasswordResetEmail(email: email.text.trim());
        print("Reset Password Data: ${firebaseAuth.sendPasswordResetEmail(email: email.text.trim()).toString()}");
          setState(() {
            isLoading = false;
          });
          email.text = "";
          toastMessageSuccess("リセットパスワードのリクエストに成功しました。メールアドレスを確認してください。", context);
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          toastMessageError("$e", context);
        }
      } else {
        toastMessageError("メールが無効です。", context);
      }
    } else {
      toastMessageError("メールアドレスを入力してください。", context);
    }
  }
}
