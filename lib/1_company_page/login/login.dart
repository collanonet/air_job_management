import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/japanese_text.dart';

class LoginPageForCompany extends StatefulWidget {
  const LoginPageForCompany({super.key});

  @override
  _LoginPageForCompanyState createState() => _LoginPageForCompanyState();
}

class _LoginPageForCompanyState extends State<LoginPageForCompany> {
  late AuthProvider authProvider;
  bool isShowPassword = false;
  TextEditingController email =
      TextEditingController(text: 'sopheadavid+10@yandex.com');
  TextEditingController password = TextEditingController(text: '123456');

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
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
      width: AppSize.getDeviceWidth(context) *
          (Responsive.isDesktop(context) ? 0.5 : 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                "assets/logo.png",
                width: AppSize.getDeviceWidth(context) *
                    (Responsive.isMobile(context) ? 0.6 : 0.25),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: -30,
                  child: Center(
                    child: Text(
                      "求人企業",
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ))
            ],
          ),
          AppSize.spaceHeight30,
          AppSize.spaceHeight16,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child:
                Align(alignment: Alignment.centerLeft, child: Text("メールアドレス")),
          ),
          AppSize.spaceHeight5,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: PrimaryTextField(
                isRequired: true,
                hint: "sample@sample.com",
                controller: email,
                isObsecure: false),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(JapaneseText.password)),
          ),
          AppSize.spaceHeight5,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: PrimaryTextField(
              hint: "⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺⏺",
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
                      icon:
                          Icon(FlutterIcons.eye_ent, color: AppColor.greyColor),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      icon: Icon(FlutterIcons.eye_with_line_ent,
                          color: AppColor.greyColor),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => MessageWidget.show(
                      "We are going to develop this function soon!"),
                  child: Text(
                    "パスワードをお忘れの方はこちら＞",
                    style: kNormalText.copyWith(
                        fontSize: 12, color: AppColor.primaryColor),
                  )),
            ),
          ),
          AppSize.spaceHeight30,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context),
              child: ButtonWidget(
                  radius: 25,
                  title: "ログイン",
                  color: AppColor.primaryColor,
                  onPress: () => onLogin()),
            ),
          ),
          AppSize.spaceHeight16,
          //Register Account as a gig-worker
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context),
              child: ButtonWidget(
                radius: 25,
                color: AppColor.whiteColor,
                title: "新規登録をする方はこちら",
                onPress: () => MessageWidget.show(
                    "We are going to develop this function soon!"),
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
      Company? user = await authProvider.loginAsCompanyAccount(
          email.text.trim(), password.text.trim());
      if (user != null) {
        authProvider.setCompany = user;
        context.go(MyRoute.companyDashboard);
      } else {
        MessageWidget.show("${authProvider.errorMessage}");
      }
    }
  }

  buildTab(String title, bool isSelected) {
    return Container(
      width: 150,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColor.primaryColor : AppColor.secondaryColor),
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
            style: TextStyle(
                color: isSelected ? AppColor.whiteColor : AppColor.blackColor),
          ),
        ),
      ),
    );
  }
}
