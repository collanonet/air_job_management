import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/japanese_text.dart';
import '../../../../utils/toast_message_util.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_loading_overlay.dart';
import '../../../../widgets/custom_textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  final MyUser? myUser;
  const ChangePasswordPage({super.key, this.myUser});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentPassword = TextEditingController(text: "");
  TextEditingController newPassword = TextEditingController(text: "");
  late AuthProvider authProvider;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isObsecureNewPass = true;
  bool isObsecureOldPass = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: AppColor.bgPageColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            centerTitle: true,
            leadingWidth: 100,
            title: const Text('パスワード変更'),
            leading: const CustomBackButtonWidget(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: AppSize.getDeviceWidth(context),
              padding: const EdgeInsets.all(16),
              decoration: boxDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.spaceHeight16,
                  Text(
                    "現在のパスワード",
                    style: kNormalText.copyWith(fontSize: 14, fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  PrimaryTextField(
                      controller: currentPassword,
                      hint: "現在のパスワード",
                      isObsecure: isObsecureNewPass,
                      suffix: !isObsecureNewPass
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isObsecureNewPass = !isObsecureNewPass;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_ent, color: AppColor.greyColor),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isObsecureNewPass = !isObsecureNewPass;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_with_line_ent, color: AppColor.greyColor),
                            )),
                  Text(
                    "新しいパスワード",
                    style: kNormalText.copyWith(fontSize: 14, fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  PrimaryTextField(
                      controller: newPassword,
                      hint: "新しいパスワード",
                      isObsecure: isObsecureOldPass,
                      suffix: !isObsecureOldPass
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isObsecureOldPass = !isObsecureOldPass;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_ent, color: AppColor.greyColor),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isObsecureOldPass = !isObsecureOldPass;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_with_line_ent, color: AppColor.greyColor),
                            )),
                  AppSize.spaceHeight16,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context),
                    child: ButtonWidget(
                      title: "保存する",
                      onPress: () => onChangePassword(),
                      color: AppColor.secondaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setLoading(true);
      MyUser? myUser = await authProvider.loginAccount(widget.myUser!.email ?? "", currentPassword.text.trim());
      if (myUser != null) {
        var user = FirebaseAuth.instance.currentUser;
        user!.updatePassword(newPassword.text.trim()).then((_) {
          setLoading(false);
          toastMessageSuccess(JapaneseText.successUpdate, context);
          Navigator.pop(context);
        }).catchError((error) {
          setLoading(false);
          toastMessageError(error.toString(), context);
        });
      } else {
        setLoading(false);
        //Current Password invalid
        toastMessageError("現在のパスワードが無効", context);
      }
    }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
