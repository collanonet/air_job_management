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
  TextEditingController scheduleInterview = TextEditingController(text: "");
  TextEditingController finalEdu = TextEditingController(text: "");
  TextEditingController graduateSchoolFaculty = TextEditingController(text: "");
  List<TextEditingController> academicBgList = [TextEditingController(text: "")];
  List<TextEditingController> workHistory = [TextEditingController(text: "")];
  TextEditingController ordinaryAutoLisence = TextEditingController(text: "");
  List<TextEditingController> otherQualList = [TextEditingController(text: "")];
  List<TextEditingController> employmentHistoryList = [TextEditingController(text: "")];
  ScrollController scrollController = ScrollController();

  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.parse("2000-10-10");

  final _formKey = GlobalKey<FormState>();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      if (nameKanJi.text.isNotEmpty && nameFurigana.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty) {
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
            status: "",
            firstName: "",
            hash_password: "",
            lastName: "",
            role: "worker",
            finalEdu: finalEdu.text,
            graduationSchool: graduateSchoolFaculty.text,
            academicBgList: academicBgList.map((e) => e.text).toList(),
            workHistoryList: workHistory.map((e) => e.text).toList(),
            ordinaryAutomaticLicence: ordinaryAutoLisence.text,
            otherQualificationList: otherQualList.map((e) => e.text).toList(),
            employmentHistoryList: employmentHistoryList.map((e) => e.text).toList());
        String? val = await UserApiServices().createUserAccount(email.text.trim(), password.text.trim(), myUser);
        setState(() {
          isLoading = false;
        });
        if (val == ConstValue.success) {
          toastMessageSuccess(JapaneseText.successCreate, context);
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
                child: Scrollbar(
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Divider(),
                        AppSize.spaceHeight16,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColor.primaryColor,
                            ),
                            AppSize.spaceWidth8,
                            Text(
                              JapaneseText.selectionInformation,
                              style: titleStyle,
                            ),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(JapaneseText.scheduleInterviewDateAndTime),
                            AppSize.spaceHeight5,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.15,
                              child: PrimaryTextField(
                                controller: scheduleInterview,
                                hint: "2023/10/10",
                                maxLine: 1,
                                isRequired: false,
                                readOnly: true,
                                onTap: () async {
                                  var date = await showDatePicker(
                                      locale: const Locale("ja", "JP"),
                                      context: context,
                                      initialDate: dateTime,
                                      firstDate: DateTime(1900, 1, 1),
                                      lastDate: DateTime.now().add(Duration(days: 1000)));
                                  if (date != null) {
                                    dateTime = date;
                                    scheduleInterview.text = DateFormat('yyyy-MM-dd').format(dateTime);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        AppSize.spaceHeight16,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColor.primaryColor,
                            ),
                            AppSize.spaceWidth8,
                            Text(
                              JapaneseText.career,
                              style: titleStyle,
                            ),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(JapaneseText.finalEducation),
                                AppSize.spaceHeight5,
                                SizedBox(
                                  width: AppSize.getDeviceWidth(context) * 0.2,
                                  child: PrimaryTextField(
                                    controller: finalEdu,
                                    hint: "未設定",
                                    maxLine: 1,
                                    isRequired: false,
                                  ),
                                )
                              ],
                            ),
                            AppSize.spaceWidth16,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(JapaneseText.graduationSchoolFacultyDepartment),
                                AppSize.spaceHeight5,
                                SizedBox(
                                  width: AppSize.getDeviceWidth(context) * 0.2,
                                  child: PrimaryTextField(
                                    controller: graduateSchoolFaculty,
                                    hint: "未設定",
                                    maxLine: 1,
                                    isRequired: false,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 84,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: academicBgList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(JapaneseText.academicBackground),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: AppSize.getDeviceWidth(context) * 0.2,
                                        child: PrimaryTextField(
                                          controller: academicBgList[index],
                                          hint: "未設定",
                                          maxLine: 1,
                                          isRequired: false,
                                        ),
                                      )
                                    ],
                                  ),
                                  (academicBgList.length - 1) == index ? AppSize.spaceWidth16 : SizedBox(),
                                  (academicBgList.length - 1) == index
                                      ? Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  academicBgList.add(TextEditingController(text: ""));
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                      : Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  academicBgList.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 84,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: workHistory.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(JapaneseText.workHistory),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: AppSize.getDeviceWidth(context) * 0.2,
                                        child: PrimaryTextField(
                                          controller: workHistory[index],
                                          hint: "未設定",
                                          maxLine: 1,
                                          isRequired: false,
                                        ),
                                      )
                                    ],
                                  ),
                                  (workHistory.length - 1) == index ? AppSize.spaceWidth16 : SizedBox(),
                                  (workHistory.length - 1) == index
                                      ? Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  workHistory.add(TextEditingController(text: ""));
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                      : Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  workHistory.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                ],
                              );
                            },
                          ),
                        ),
                        AppSize.spaceHeight16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(JapaneseText.ordinaryAutomaticLicense),
                            AppSize.spaceHeight5,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.15,
                              child: PrimaryTextField(
                                controller: ordinaryAutoLisence,
                                hint: "未設定",
                                maxLine: 1,
                                isRequired: false,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 84,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: otherQualList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(JapaneseText.otherQualification),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: AppSize.getDeviceWidth(context) * 0.2,
                                        child: PrimaryTextField(
                                          controller: otherQualList[index],
                                          hint: "未設定",
                                          maxLine: 1,
                                          isRequired: false,
                                        ),
                                      )
                                    ],
                                  ),
                                  (otherQualList.length - 1) == index ? AppSize.spaceWidth16 : SizedBox(),
                                  (otherQualList.length - 1) == index
                                      ? Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  otherQualList.add(TextEditingController(text: ""));
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                      : Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  otherQualList.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 84,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: employmentHistoryList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(JapaneseText.employmentHistory),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: AppSize.getDeviceWidth(context) * 0.2,
                                        child: PrimaryTextField(
                                          controller: employmentHistoryList[index],
                                          hint: "未設定",
                                          maxLine: 1,
                                          isRequired: false,
                                        ),
                                      )
                                    ],
                                  ),
                                  (employmentHistoryList.length - 1) == index ? AppSize.spaceWidth16 : SizedBox(),
                                  (employmentHistoryList.length - 1) == index
                                      ? Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  employmentHistoryList.add(TextEditingController(text: ""));
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                      : Center(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  employmentHistoryList.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: AppColor.primaryColor,
                                              )),
                                        )
                                ],
                              );
                            },
                          ),
                        ),
                        AppSize.spaceHeight16,
                        AppSize.spaceHeight16,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.1,
                              child: ButtonWidget(title: JapaneseText.clearInput, color: AppColor.redColor, onPress: () => clearAllText()),
                            ),
                            AppSize.spaceWidth16,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.1,
                              child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                            ),
                          ],
                        )
                      ],
                    ),
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
