import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthProvider authProvider;
  bool isShowPassword = false;
  TextEditingController email = TextEditingController(text: 'abcd123');
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
          // SvgPicture.asset(
          //   ImageSource.icLogo,
          //   width: 150,
          //   height: 150,
          // ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          Text(
            "GPSワーク",
            style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 30),
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          AppSize.spaceHeight16,
          CustomTextFieldWidget(
              controller: email,
              isSecureText: false,
              isFromLogin: true,
              width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
              hintText: "スタッフ番号",
              maxLine: 1),
          AppSize.spaceHeight16,
          !authProvider.isLogin
              ? CustomTextFieldWidget(
                  controller: username,
                  isSecureText: false,
                  isFromLogin: true,
                  width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
                  hintText: "Username",
                  maxLine: 1)
              : SizedBox(),
          !authProvider.isLogin ? AppSize.spaceHeight16 : SizedBox(),
          Stack(
            children: [
              CustomTextFieldWidget(
                  isFromLogin: true,
                  controller: password,
                  isSecureText: !isShowPassword,
                  width: AppSize.getDeviceWidth(context) * (Responsive.isDesktop(context) ? 0.5 : 0.8),
                  hintText: "パスワード",
                  maxLine: 1),
              Positioned(
                top: 5,
                right: 10,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    icon: Icon(!isShowPassword ? Icons.visibility_off_rounded : Icons.visibility)),
              )
            ],
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
    } else {}
  }

  buildTab(String title, bool isSelected) {
    return Container(
      width: 150,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: isSelected ? AppColor.primaryColor : AppColor.secondaryColor),
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
