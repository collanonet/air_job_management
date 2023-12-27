import 'package:air_job_management/helper/role_helper.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/my_route.dart';

class LoginPage extends StatefulWidget {
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
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        color: AppColor.whiteColor,
      ),
      padding: EdgeInsets.symmetric(vertical: AppSize.getDeviceHeight(context) * 0.1),
      width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                "assets/svgs/img.png",
                width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.3),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: Responsive.isMobile(context) ? -20 : -10,
                  child: Center(
                    child: Text(
                      "求人企業",
                      style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ))
            ],
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: PrimaryTextField(isRequired: true, hint: "スタッフ番号", controller: email, isObsecure: false),
          ),
          AppSize.spaceHeight16,
          !authProvider.isLogin ? PrimaryTextField(hint: "Username", controller: username, isObsecure: false) : SizedBox(),
          !authProvider.isLogin ? AppSize.spaceHeight16 : SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceWidth(context) * 0.1),
            child: PrimaryTextField(
              hint: "パスワード",
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
                      icon: Icon(FlutterIcons.eye_ent, color: AppColor.primaryColor),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      icon: Icon(FlutterIcons.eye_with_line_ent, color: AppColor.primaryColor),
                    ),
            ),
          ),
          AppSize.spaceHeight16,
          SizedBox(
            width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.20),
            child: ButtonWidget(
                title: authProvider.isLogin ? "ログイン" : "Register",
                color: AppColor.primaryColor,
                onPress: () => authProvider.isLogin ? onLogin() : onRegister()),
          ),
          AppSize.spaceHeight16,
          //Register Account as a gig-worker
          Center(
            child: TextButton(
              child: const Text("ギグワーカーとしてアカウントを登録する"),
              onPressed: () => context.go(MyRoute.registerAsGigWorker),
            ),
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          const Text("Version 1.0.1"),
        ],
      ),
    );
  }

  onRegister() {}

  onLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      MessageWidget.show("スタッフ番号またはパスワードが必要です");
    } else {
      authProvider.setLoading(true);
      MyUser? user = await authProvider.loginAccount(email.text.trim(), password.text.trim());
      if (user != null) {
        if (user.role == RoleHelper.admin) {
          context.go(MyRoute.jobOption);
        } else {
          context.go(MyRoute.workerJobSearch);
        }
      } else {
        MessageWidget.show("${authProvider.errorMessage}");
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
