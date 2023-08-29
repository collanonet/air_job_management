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
  TextEditingController email = TextEditingController(text: 'admin@gmail.com');
  TextEditingController password = TextEditingController(text: '123456');
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
      padding: const EdgeInsets.all(16),
      width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/svgs/img.png",
            width: 250,
            height: 80,
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          Text(
            "Air Job",
            style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 30),
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          PrimaryTextField(isRequired: true, hint: "スタッフ番号", controller: email, isObsecure: false),
          AppSize.spaceHeight16,
          !authProvider.isLogin ? PrimaryTextField(hint: "Username", controller: username, isObsecure: false) : SizedBox(),
          !authProvider.isLogin ? AppSize.spaceHeight16 : SizedBox(),
          PrimaryTextField(
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
          AppSize.spaceHeight16,
          ButtonWidget(
              title: authProvider.isLogin ? "ログイン" : "Register",
              color: AppColor.primaryColor,
              onPress: () => authProvider.isLogin ? onLogin() : onRegister()),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
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
        context.go(MyRoute.home);
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
