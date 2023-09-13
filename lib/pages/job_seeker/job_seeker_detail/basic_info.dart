import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

import '../../../api/user_api.dart';
import '../../../const/const.dart';
import '../../../models/user.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/style.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_textfield.dart';

class BasicInfoPage extends StatefulWidget {
  final MyUser seeker;
  const BasicInfoPage({Key? key, required this.seeker}) : super(key: key);

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  TextEditingController nameKanJi = TextEditingController(text: "");
  TextEditingController nameFurigana = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController dob = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  TextEditingController note = TextEditingController(text: "");
  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.parse("2000-10-10");

  onSaveUserData() async {
    if (nameKanJi.text.isNotEmpty &&
        nameFurigana.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      MyUser myUser = MyUser(
          nameKanJi: nameKanJi.text,
          phone: phone.text,
          note: note.text,
          nameFu: nameFurigana.text,
          dob: dob.text,
          email: email.text,
          firstName: "",
          hash_password: "",
          lastName: "",
          role: "staff");
      String? val = await UserApiServices()
          .createUserAccount(email.text.trim(), password.text.trim(), myUser);
      setState(() {
        isLoading = false;
      });
      if (val == ConstValue.success) {
        toastMessageSuccess("Create user account success", context);
        clearAllText();
      } else {
        toastMessageError("$val", context);
      }
    }
  }

  @override
  void initState() {
    nameKanJi.text = widget.seeker.nameKanJi ?? "";
    nameFurigana.text = widget.seeker.nameFu ?? "";
    phone.text = widget.seeker.phone ?? "";
    dob.text = widget.seeker.dob ?? "";
    email.text = widget.seeker.email ?? "";
    note.text = widget.seeker.note ?? "";
    super.initState();
  }

  @override
  void dispose() {
    nameKanJi.dispose();
    nameFurigana.dispose();
    phone.dispose();
    dob.dispose();
    email.dispose();
    password.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColor.primaryColor,
                ),
                AppSize.spaceWidth8,
                Text(
                  JapaneseText.applicantSearch,
                  style: titleStyle,
                ),
              ],
            ),
            AppSize.spaceHeight16,
            //Name
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.nameKanJi),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: nameKanJi,
                      hint: '',
                    ),
                  ],
                )),
                AppSize.spaceWidth16,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.nameFugigana),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: nameFurigana,
                      hint: '',
                    ),
                  ],
                )),
              ],
            ),
            AppSize.spaceHeight16,
            //Phone & Dob
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.phone),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: phone,
                      isRequired: false,
                      hint: '',
                    ),
                  ],
                )),
                AppSize.spaceWidth16,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.dob),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      isRequired: false,
                      controller: dob,
                      hint: '',
                      readOnly: true,
                      onTap: () async {
                        var date = await showDatePicker(
                            locale: Locale("ja", "JP"),
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime(1900, 1, 1),
                            lastDate: DateTime.now());
                        if (date != null) {
                          dateTime = date;
                          dob.text = DateFormat('yyyy-MM-dd').format(dateTime);
                        }
                      },
                    ),
                  ],
                )),
              ],
            ),
            AppSize.spaceHeight16,
            //Email & Pass
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.email),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: email,
                      hint: '',
                      readOnly: true,
                    ),
                  ],
                )),
                AppSize.spaceWidth16,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.password),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      readOnly: true,
                      controller: password,
                      hint: '',
                      isObsecure: isShow,
                      suffix: !isShow
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isShow = !isShow;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_ent,
                                  color: AppColor.primaryColor),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isShow = !isShow;
                                });
                              },
                              icon: Icon(FlutterIcons.eye_with_line_ent,
                                  color: AppColor.primaryColor),
                            ),
                    ),
                  ],
                )),
              ],
            ),
            AppSize.spaceHeight16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.note),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: note,
                  hint: "",
                  maxLine: 4,
                  isRequired: false,
                )
              ],
            ),
            AppSize.spaceHeight16,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: AppSize.getDeviceWidth(context) * 0.3,
            //       child: ButtonWidget(title: JapaneseText.clearInput, color: AppColor.redColor, onPress: () => clearAllText()),
            //     ),
            //     AppSize.spaceWidth16,
            //     SizedBox(
            //       width: AppSize.getDeviceWidth(context) * 0.3,
            //       child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  clearAllText() {
    nameFurigana.text = "";
    nameKanJi.text = "";
    email.text = "";
    password.text = "";
    phone.text = "";
    dob.text = "";
    note.text = "";
  }
}
