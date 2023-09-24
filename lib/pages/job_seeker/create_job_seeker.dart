import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../const/const.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';

class CreateJobSeekerPage extends StatefulWidget {
  const CreateJobSeekerPage({Key? key}) : super(key: key);

  @override
  State<CreateJobSeekerPage> createState() => _CreateJobSeekerPageState();
}

class _CreateJobSeekerPageState extends State<CreateJobSeekerPage> {
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

  final _formKey = GlobalKey<FormState>();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
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
          context.pop();
          context.go(MyRoute.jobSeeker);
        } else {
          toastMessageError("$val", context);
        }
      }
    }
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
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              titleWidget(),
              AppSize.spaceHeight16,
              Container(
                padding: const EdgeInsets.all(12),
                width: AppSize.getDeviceWidth(context),
                height: AppSize.getDeviceHeight(context) - 110,
                decoration: boxDecoration,
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
                                  // var date = await d.DatePicker.showDatePicker(context,
                                  //     theme: d.DatePickerTheme(containerHeight: AppSize.getDeviceHeight(context) * 0.5),
                                  //     showTitleActions: true,
                                  //     minTime: DateTime(1900, 1, 1),
                                  //     maxTime: DateTime.now(), onChanged: (date) {
                                  //   print('change $date');
                                  // }, onConfirm: (date) {
                                  //   print('confirm $date');
                                  // }, currentTime: dateTime, locale: d.LocaleType.jp);
                                  if (date != null) {
                                    dateTime = date;
                                    dob.text = DateFormat('yyyy-MM-dd')
                                        .format(dateTime);
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
                                        icon: Icon(
                                            FlutterIcons.eye_with_line_ent,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: AppSize.getDeviceWidth(context) * 0.1,
                            child: ButtonWidget(
                                title: JapaneseText.clearInput,
                                color: AppColor.redColor,
                                onPress: () => clearAllText()),
                          ),
                          AppSize.spaceWidth16,
                          SizedBox(
                            width: AppSize.getDeviceWidth(context) * 0.1,
                            child: ButtonWidget(
                                title: JapaneseText.save,
                                color: AppColor.primaryColor,
                                onPress: () => onSaveUserData()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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

  titleWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 60,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            JapaneseText.applicantSearch,
            style: titleStyle,
          ),
          IconButton(onPressed: () => context.pop(), icon: Icon(Icons.close))
        ],
      ),
    );
  }
}
