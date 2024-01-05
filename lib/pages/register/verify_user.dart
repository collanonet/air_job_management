import 'package:air_job_management/pages/register/new_register_form_for_part_time.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../models/user.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/page_route.dart';
import '../../utils/respnsive.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/loading.dart';
import '../login.dart';
import 'new_form_register.dart';

class VerifyUserEmailPage extends StatefulWidget {
  final MyUser myUser;
  final bool isFullTime;
  const VerifyUserEmailPage(
      {Key? key, required this.myUser, required this.isFullTime})
      : super(key: key);

  @override
  State<VerifyUserEmailPage> createState() => _VerifyUserEmailPageState();
}

class _VerifyUserEmailPageState extends State<VerifyUserEmailPage>
    with AfterBuildMixin {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // authProvider.onChangeLoading(false);
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black.withOpacity(0.3),
      progressIndicator: LoadingWidget(AppColor.whiteColor),
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
                          child: IconButton(
                              onPressed: () => MyPageRoute.goToReplace(
                                  context,
                                  LoginPage(
                                    isFullTime: widget.isFullTime,
                                    isFromWorker: true,
                                  )),
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColor.primaryColor,
                              ))),
                      Center(
                          child: Image.asset(
                        "assets/svgs/img.png",
                        width: AppSize.getDeviceWidth(context) *
                            (Responsive.isMobile(context) ? 0.6 : 0.3),
                      )),
                      //Email & Pass
                      const Text(
                          "登録を行います。\nまずはメールアドレスに届いたURLをクリックし認証を行ってください。\nその後こちらの「送信する」をクリックしてください。"),
                      AppSize.spaceHeight30,
                      Center(
                        child: SizedBox(
                            width: AppSize.getDeviceWidth(context) *
                                (Responsive.isMobile(context) ? 0.6 : 0.20),
                            child: ButtonWidget(
                                color: AppColor.primaryColor,
                                onPress: () => verifyAccount(),
                                title: "送信する")),
                      ),
                      //Test
                      AppSize.spaceHeight16,
                      // Center(
                      //   child: SizedBox(
                      //       width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.20),
                      //       child: ButtonWidget(
                      //           color: AppColor.primaryColor,
                      //           onPress: () => MyPageRoute.goTo(context, NewFormRegistrationPage(myUser: widget.myUser)),
                      //           title: "送信する")),
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
    );
  }

  verifyAccount() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.currentUser?.reload();
    await Future.delayed(const Duration(seconds: 1));
    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {
      isLoading = false;
    });
    if (isEmailVerified) {
      if (widget.isFullTime) {
        MyPageRoute.goTo(
            context, NewFormRegistrationPage(myUser: widget.myUser));
      } else {
        MyPageRoute.goTo(
            context, NewFormRegistrationForPartTimePage(myUser: widget.myUser));
      }
    } else {
      toastMessageError("検証に失敗しました。 メールにアクセスし、送信されたURLを再度ご確認ください。", context);
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    bool isEmailVerified =
        FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    if (isEmailVerified) {
      if (widget.myUser.isFullTimeStaff == true) {
        MyPageRoute.goTo(
            context, NewFormRegistrationPage(myUser: widget.myUser));
      } else {
        MyPageRoute.goTo(
            context, NewFormRegistrationForPartTimePage(myUser: widget.myUser));
      }
    } else {
      try {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
