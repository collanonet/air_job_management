import 'package:air_job_management/helper/role_helper.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../const/const.dart';
import '../models/user.dart';
import '../utils/japanese_text.dart';
import '../utils/my_route.dart';
import '../utils/style.dart';
import '../utils/toast_message_util.dart';

class LoginPage extends StatefulWidget {
  final bool isFromWorker;
  final bool isFullTime;
  const LoginPage({super.key, required this.isFromWorker, required this.isFullTime});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthProvider authProvider;
  bool isShowPassword = false;
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController username = TextEditingController(text: 'Admin ABC');

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // email = TextEditingController(text: 'sopheadavid+2@yandex.com');
    // password = TextEditingController(text: '123456');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        backgroundColor: AppColor.bgPageColor,
        body: Center(
          child: buildBody(),
        ),
      ),
    );
  }

  bool isShow = true;

  buildBody() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.whiteColor,
      ),
      margin: EdgeInsets.all(Responsive.isDesktop(context) ? AppSize.getDeviceHeight(context) * 0.1 : 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.9),
      height: AppSize.getDeviceHeight(context),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                        "ログイン",
                        style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ))
              ],
            ),
            AppSize.spaceHeight30,
            // AppSize.spaceHeight16,
            // socialLoginButton(
            //     assets: "assets/google.png",
            //     title: "Googleでログイン",
            //     colors: const Color(0xffCDD6DD).withOpacity(0.3),
            //     onTap: () async {
            //       MyUser? user = await SocialLogin().googleSignIn(widget.isFullTime, authProvider);
            //       if (user != null) {
            //         if (user.nameKanJi != "" || user.nameFu != "") {
            //           if (user.isFullTimeStaff == true) {
            //             context.go(MyRoute.workerJobSearchFullTime);
            //           } else {
            //             context.go(MyRoute.workerJobSearchPartTime);
            //           }
            //         } else {
            //           if (widget.isFullTime) {
            //             MyPageRoute.goTo(context, NewFormRegistrationPage(myUser: user));
            //           } else {
            //             MyPageRoute.goTo(context, NewFormRegistrationForPartTimePage(myUser: user));
            //           }
            //         }
            //       } else {
            //         MessageWidget.show("Googleでログイン中にエラーが発生しました");
            //       }
            //     }),
            // AppSize.spaceHeight16,
            // socialLoginButton(
            //     assets: "assets/x.png",
            //     title: "Xでログイン",
            //     colors: const Color(0xff495960),
            //     onTap: () async {
            //       MyUser? user = await SocialLogin().twitterSignIn(widget.isFullTime, authProvider);
            //       if (user != null) {
            //         if (user.nameKanJi != "" || user.nameFu != "") {
            //           if (user.isFullTimeStaff == true) {
            //             context.go(MyRoute.workerJobSearchFullTime);
            //           } else {
            //             context.go(MyRoute.workerJobSearchPartTime);
            //           }
            //         } else {
            //           if (widget.isFullTime) {
            //             MyPageRoute.goTo(context, NewFormRegistrationPage(myUser: user));
            //           } else {
            //             MyPageRoute.goTo(context, NewFormRegistrationForPartTimePage(myUser: user));
            //           }
            //         }
            //       } else {
            //         MessageWidget.show("X でログイン中にエラーが発生しました");
            //       }
            //     }),
            // AppSize.spaceHeight16,
            // AppSize.spaceHeight16,
            // Center(
            //   child: Text(
            //     "またはメールアドレスで登録",
            //     style: TextStyle(
            //         color: AppColor.primaryColor,
            //         fontWeight: FontWeight.w600,
            //         fontSize: 18),
            //   ),
            // ),
            AppSize.spaceHeight16,
            AppSize.spaceHeight16,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: Align(alignment: Alignment.centerLeft, child: Text("メールアドレス")),
            ),
            AppSize.spaceHeight5,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: PrimaryTextField(isRequired: true, hint: "sample@sample.com", controller: email, isObsecure: false),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.password)),
            ),
            AppSize.spaceHeight5,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: PrimaryTextField(
                hint: "*****************",
                controller: password,
                isRequired: true,
                isObsecure: isShow,
                suffix: !isShow
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                        icon: Icon(FlutterIcons.eye_ent, color: AppColor.greyColor),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                        icon: Icon(FlutterIcons.eye_with_line_ent, color: AppColor.greyColor),
                      ),
              ),
            ),
            AppSize.spaceHeight16,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: ButtonWidget(
                    title: authProvider.isLogin ? "ログイン" : "Register",
                    color: AppColor.secondaryColor,
                    onPress: () => authProvider.isLogin ? onLogin() : onRegister()),
              ),
            ),
            AppSize.spaceHeight8,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
                child: TextButton(
                    onPressed: () => context.go(MyRoute.resetPassword),
                    child: Text(
                      "パスワードをお忘れの方はこちら＞",
                      style: kNormalText.copyWith(color: AppColor.primaryColor),
                    )),
              ),
            ),
            // const Spacer(),
            //Register Account as a gig-worker
            AppSize.spaceHeight30,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
              child: SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: ButtonWidget(
                  color: Colors.white,
                  title: "新規登録をする方はこちら",
                  onPress: () => context.go(MyRoute.registerAsGigWorker),
                ),
              ),
            ),
            AppSize.spaceHeight16,
            Text(
              "Version " + ConstValue.appVersion,
              style: normalTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  onRegister() {}

  socialLoginButton({required String assets, required String title, required Color colors, required Function onTap}) {
    return Container(
      height: 50,
      width: AppSize.getDeviceWidth(context) - 32,
      margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : AppSize.getDeviceWidth(context) * 0.1),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: colors, border: Border.all(width: 1, color: AppColor.thirdColor)),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              left: 0,
              right: title.contains("X") ? 40 : 0,
              top: 9,
              child: Center(
                child: Text(
                  title,
                  style: normalTextStyle.copyWith(
                      color: title.contains("X") ? Colors.white : const Color(0xff495960), fontSize: 18, fontFamily: "Light"),
                ),
              ),
            ),
            Positioned(
              top: title.contains("X") ? 4 : 8,
              left: Responsive.isMobile(context)
                  ? 10
                  : title.contains("X")
                      ? 25
                      : 30,
              child: Image.asset(
                assets,
                width: title.contains("X") ? 40 : 30,
                height: title.contains("X") ? 40 : 30,
              ),
            )
          ],
        ),
        onPressed: () => onTap(),
      ),
    );
  }

  onLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      MessageWidget.show("スタッフ番号またはパスワードが必要です");
    } else {
      authProvider.setLoading(true);
      MyUser? user = await authProvider.loginAccount(email.text.trim(), password.text.trim());
      if (user != null) {
        context.go(MyRoute.dashboard);
        // if (user.role == RoleHelper.admin) {
        //   context.go(MyRoute.dashboard);
        // } else {
        //   await authProvider.logout();
        //   toastMessageError("求職者の方はモバイルアプリをご利用ください。", context);
        //   // if (user.isFullTimeStaff == true) {
        //   //   isFullTime = true;
        //   //   context.go(MyRoute.workerJobSearchFullTime);
        //   // } else {
        //   //   isFullTime = false;
        //   //   context.go(MyRoute.workerJobSearchPartTime);
        //   // }
        // }
      } else {
        toastMessageError("${authProvider.errorMessage}", context);
      }
    }
  }

  buildTab(String title, bool isSelected) {
    return Container(
      width: 150,
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: isSelected ? AppColor.primaryColor : AppColor.secondaryColor),
      child: InkWell(
        onTap: () {
          if (title == "Login") {
            authProvider.onChange(true);
          } else {
            authProvider.onChange(false);
          }
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: isSelected ? AppColor.whiteColor : AppColor.blackColor),
          ),
        ),
      ),
    );
  }
}
