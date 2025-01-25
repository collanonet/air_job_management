import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/company.dart';
import '../../utils/japanese_text.dart';
import '../../utils/my_route.dart';
import '../home/widgets/choose_branch.dart';

class LoginPageForCompany extends StatefulWidget {
  const LoginPageForCompany({super.key});

  @override
  _LoginPageForCompanyState createState() => _LoginPageForCompanyState();
}

class _LoginPageForCompanyState extends State<LoginPageForCompany> {
  late AuthProvider authProvider;
  bool isShowPassword = false;
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // email = TextEditingController(text: 'sopheadavid+1000@yandex.com');
    // password = TextEditingController(text: '123456789');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
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
        borderRadius: BorderRadius.circular(18),
        color: AppColor.whiteColor,
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 50),
      width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
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
                  bottom: -30,
                  child: Center(
                    child: Text(
                      authProvider.isLogin ? "ログイン" : "新規登録",
                      style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ))
            ],
          ),
          AppSize.spaceHeight30,
          AppSize.spaceHeight16,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: Align(alignment: Alignment.centerLeft, child: Text("メールアドレス")),
          ),
          AppSize.spaceHeight5,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: PrimaryTextField(isRequired: true, hint: "sample@sample.com", controller: email, isObsecure: false),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.password)),
          ),
          AppSize.spaceHeight5,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
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
          authProvider.isLogin
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => context.go(MyRoute.resetPasswordCompany),
                        child: Text(
                          "パスワードをお忘れの方はこちら＞",
                          style: kNormalText.copyWith(fontSize: 12, color: AppColor.primaryColor),
                        )),
                  ),
                )
              : SizedBox(),
          AppSize.spaceHeight30,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context),
              child:
                  ButtonWidget(radius: 25, title: authProvider.isLogin ? "ログインする" : "新規登録する", color: AppColor.primaryColor, onPress: () => onLogin()),
            ),
          ),
          AppSize.spaceHeight16,
          //Register Account as a gig-worker
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context),
              child: ButtonWidget(
                radius: 25,
                color: AppColor.whiteColor,
                title: authProvider.isLogin ? "新規アカウント登録する方" : "すでにアカウントをお持ちの方",
                onPress: () {
                  if (authProvider.isLogin) {
                    authProvider.onChange(false);
                  } else {
                    authProvider.onChange(true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  onLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      MessageWidget.show("スタッフ番号またはパスワードが必要です");
    } else {
      authProvider.setLoading(true);
      Company? user;

      ///Login or Register conditions
      if (authProvider.isLogin) {
        user = await authProvider.loginAsCompanyAccount(email.text.trim(), password.text.trim());
      } else {
        user = await authProvider.createCompanyAccount(email.text.trim(), password.text.trim());
      }
      if (user != null) {
        if (user.companyUserId != null) {
          authProvider.setCompany = user;
          authProvider.onChangeBranch(mainBranch);
          context.go(MyRoute.companyInformationManagement);
        } else {
          authProvider.onChange(true);
          toastMessageSuccess("会社が正常に作成されました。メールにアクセスして、送信された確認リンクをクリックしてください。", context);
        }
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
