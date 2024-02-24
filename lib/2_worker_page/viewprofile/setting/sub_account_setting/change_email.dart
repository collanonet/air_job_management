import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../../api/user_api.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/japanese_text.dart';
import '../../../../widgets/custom_back_button.dart';

class ChangeEmailPage extends StatefulWidget {
  final MyUser? myUser;
  const ChangeEmailPage({super.key, this.myUser});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController currentPassword = TextEditingController(text: "");
  TextEditingController newEmail = TextEditingController(text: "");
  late AuthProvider authProvider;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isObsecureNewPass = true;

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
            title: const Text('メールアドレス変更'),
            leading: const CustomBackButtonWidget(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: AppSize.getDeviceWidth(context),
              padding: const EdgeInsets.all(16),
              decoration: boxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSize.spaceHeight16,
                  Text(
                    "現在のメールアドレス",
                    style: kNormalText.copyWith(fontSize: 14, fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  Text(
                    "${widget.myUser?.email}",
                    style: kNormalText.copyWith(fontSize: 14),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    "新しいメールアドレス",
                    style: kNormalText.copyWith(fontSize: 14, fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  PrimaryTextField(
                    controller: newEmail,
                    hint: "新しいメールアドレス",
                    isEmail: true,
                  ),
                  Text(
                    "現在のパスワード",
                    style: kNormalText.copyWith(fontSize: 14, fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  PrimaryTextField(
                      controller: currentPassword,
                      hint: "現在のパスワード",
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
      if (widget.myUser!.email != newEmail.text.trim()) {
        setLoading(true);
        MyUser? myUser = await authProvider.loginAccount(widget.myUser!.email ?? "", currentPassword.text.trim());
        if (myUser != null) {
          var user = FirebaseAuth.instance.currentUser;
          user!.updateEmail(newEmail.text.trim()).then((_) {
            widget.myUser!.email = newEmail.text.trim();
            authProvider.myUser!.email = newEmail.text.trim();
            UserApiServices().updateUserAField(uid: user.uid, value: newEmail.text.trim(), field: "email");
            setLoading(false);
            toastMessageSuccess(JapaneseText.successUpdate, context);
            Navigator.pop(context, widget.myUser);
          }).catchError((error) {
            setLoading(false);
            toastMessageError(error.toString(), context);
          });
        } else {
          setLoading(false);
          //Current Password invalid
          toastMessageError("現在のパスワードが無効", context);
        }
      } else {
        //Old and New Email are the same
        toastMessageError("新しいメールアドレスと古いメールアドレスが同じ", context);
      }
    }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
