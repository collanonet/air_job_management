import 'package:air_job_management/providers/job_seeker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../api/user_api.dart';
import '../../../const/const.dart';
import '../../../models/user.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/my_route.dart';
import '../../../utils/style.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_button.dart';
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
  TextEditingController note = TextEditingController(text: "");
  TextEditingController scheduleInterview = TextEditingController(text: "");
  TextEditingController finalEdu = TextEditingController(text: "");
  TextEditingController graduateSchoolFaculty = TextEditingController(text: "");
  List<TextEditingController> academicBgList = [TextEditingController(text: "")];
  List<TextEditingController> workHistory = [TextEditingController(text: "")];
  TextEditingController ordinaryAutoLisence = TextEditingController(text: "");
  List<TextEditingController> otherQualList = [TextEditingController(text: "")];
  List<TextEditingController> employmentHistoryList = [TextEditingController(text: "")];
  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  late JobSeekerProvider jobSeekerProvider;

  onSaveUserData() async {
    if (nameKanJi.text.isNotEmpty && nameFurigana.text.isNotEmpty && email.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      widget.seeker.nameKanJi = nameKanJi.text;
      widget.seeker.nameFu = nameFurigana.text;
      widget.seeker.phone = phone.text;
      widget.seeker.note = note.text;
      widget.seeker.email = email.text;
      widget.seeker.interviewDate = scheduleInterview.text;
      widget.seeker.finalEdu = finalEdu.text;
      widget.seeker.graduationSchool = graduateSchoolFaculty.text;
      widget.seeker.academicBgList = academicBgList.map((e) => e.text).toList();
      widget.seeker.workHistoryList = workHistory.map((e) => e.text).toList();
      widget.seeker.ordinaryAutomaticLicence = ordinaryAutoLisence.text;
      widget.seeker.otherQualificationList = otherQualList.map((e) => e.text).toList();
      widget.seeker.employmentHistoryList = employmentHistoryList.map((e) => e.text).toList();
      String? val = await UserApiServices().updateUserData(widget.seeker);
      setState(() {
        isLoading = false;
      });
      if (val == ConstValue.success) {
        toastMessageSuccess(JapaneseText.successUpdate, context);
        await jobSeekerProvider.getAllUser();
        context.pop();
        context.go(MyRoute.jobSeeker);
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
    scheduleInterview.text = widget.seeker.interviewDate ?? "";
    finalEdu.text = widget.seeker.finalEdu ?? "";
    graduateSchoolFaculty.text = widget.seeker.graduationSchool ?? "";
    if (widget.seeker.academicBgList != null && widget.seeker.academicBgList!.isNotEmpty) {
      academicBgList = widget.seeker.academicBgList!.map((e) => TextEditingController(text: e.toString())).toList();
    }
    if (widget.seeker.workHistoryList != null && widget.seeker.workHistoryList!.isNotEmpty) {
      workHistory = widget.seeker.workHistoryList!.map((e) => TextEditingController(text: e.toString())).toList();
    }
    ordinaryAutoLisence.text = widget.seeker.ordinaryAutomaticLicence ?? "";
    if (widget.seeker.otherQualificationList != null && widget.seeker.otherQualificationList!.isNotEmpty) {
      otherQualList = widget.seeker.otherQualificationList!.map((e) => TextEditingController(text: e.toString())).toList();
    }
    if (widget.seeker.employmentHistoryList != null && widget.seeker.employmentHistoryList!.isNotEmpty) {
      employmentHistoryList = widget.seeker.employmentHistoryList!.map((e) => TextEditingController(text: e.toString())).toList();
    }
    super.initState();
  }

  @override
  void dispose() {
    nameKanJi.dispose();
    nameFurigana.dispose();
    phone.dispose();
    dob.dispose();
    email.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    jobSeekerProvider = Provider.of<JobSeekerProvider>(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
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
                  Expanded(child: const SizedBox()),
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
              Center(
                child: SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.1,
                  child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                ),
              ),
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
    phone.text = "";
    dob.text = "";
    note.text = "";
  }
}
