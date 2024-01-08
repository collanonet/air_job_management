import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/worker_page/viewprofile/widgets/pickimage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../api/user_api.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  final MyUser seeker;
  const EditProfile({super.key, required this.seeker});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameKanJi = TextEditingController(text: "");
  TextEditingController nameFurigana = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController dob = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController note = TextEditingController(text: "");
  TextEditingController scheduleInterview = TextEditingController(text: "");
  TextEditingController finalEdu = TextEditingController(text: "");
  TextEditingController graduateSchoolFaculty = TextEditingController(text: "");
  List<TextEditingController> academicBgList = [
    TextEditingController(text: "")
  ];
  List<TextEditingController> workHistory = [TextEditingController(text: "")];
  TextEditingController ordinaryAutoLisence = TextEditingController(text: "");
  List<TextEditingController> otherQualList = [TextEditingController(text: "")];
  List<TextEditingController> employmentHistoryList = [
    TextEditingController(text: "")
  ];
  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  String imageUrl = "";
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    var img = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (img != null) {
      setState(() {
        _image = img.files.first.bytes;
      });
    }
  }

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image != null) {
        imageUrl = await fileToUrl(_image!, "images");
        widget.seeker.profileImage = imageUrl;
      }
      widget.seeker.profileImage = imageUrl;
      widget.seeker.nameKanJi = nameKanJi.text;
      widget.seeker.nameFu = nameFurigana.text;
      widget.seeker.phone = phone.text;
      widget.seeker.note = note.text;
      widget.seeker.dob = dob.text;
      widget.seeker.email = email.text;
      widget.seeker.interviewDate = scheduleInterview.text;
      widget.seeker.finalEdu = finalEdu.text;
      widget.seeker.graduationSchool = graduateSchoolFaculty.text;
      widget.seeker.academicBgList = academicBgList.map((e) => e.text).toList();
      widget.seeker.workHistoryList = workHistory.map((e) => e.text).toList();
      widget.seeker.ordinaryAutomaticLicence = ordinaryAutoLisence.text;
      widget.seeker.otherQualificationList =
          otherQualList.map((e) => e.text).toList();
      widget.seeker.employmentHistoryList =
          employmentHistoryList.map((e) => e.text).toList();
      String? val = await UserApiServices().updateUserData(widget.seeker);
      setState(() {
        isLoading = false;
      });
      if (val == ConstValue.success) {
        toastMessageSuccess(JapaneseText.successUpdate, context);
        Navigator.pop(context, widget.seeker);
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
    imageUrl = widget.seeker.profileImage ?? "";
    if (widget.seeker.academicBgList != null &&
        widget.seeker.academicBgList!.isNotEmpty) {
      academicBgList = widget.seeker.academicBgList!
          .map((e) => TextEditingController(text: e.toString()))
          .toList();
    }
    if (widget.seeker.workHistoryList != null &&
        widget.seeker.workHistoryList!.isNotEmpty) {
      workHistory = widget.seeker.workHistoryList!
          .map((e) => TextEditingController(text: e.toString()))
          .toList();
    }
    ordinaryAutoLisence.text = widget.seeker.ordinaryAutomaticLicence ?? "";
    if (widget.seeker.otherQualificationList != null &&
        widget.seeker.otherQualificationList!.isNotEmpty) {
      otherQualList = widget.seeker.otherQualificationList!
          .map((e) => TextEditingController(text: e.toString()))
          .toList();
    }
    if (widget.seeker.employmentHistoryList != null &&
        widget.seeker.employmentHistoryList!.isNotEmpty) {
      employmentHistoryList = widget.seeker.employmentHistoryList!
          .map((e) => TextEditingController(text: e.toString()))
          .toList();
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
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "アカウント設定",
              style: kTitleText.copyWith(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: AppColor.primaryColor,
          ),
          body: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(children: [
                        _image != null
                            ?
                            // imageUrl: myUser?.profile ?? "",

                            ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Image.memory(_image!),
                                ),
                              )
                            : imageUrl.isNotEmpty
                                ? CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(imageUrl!),
                                  )
                                : const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/image1.jpg"),
                                    backgroundColor:
                                        Color.fromARGB(255, 206, 205, 205),
                                    radius: 80,
                                  ),
                        const SizedBox(
                          height: 20,
                        ),
                        Positioned(
                          child: IconButton(
                            onPressed: () => selectImage(),
                            icon: const Icon(
                              Icons.edit,
                              size: 40,
                              color: Color.fromARGB(255, 38, 37, 36),
                            ),
                          ),
                          bottom: 3,
                          left: 95,
                        )
                      ]),
                    ),
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
                                  dob.text =
                                      DateFormat('yyyy-MM-dd').format(dateTime);
                                }
                              },
                            ),
                          ],
                        )),
                      ],
                    ),
                    Column(
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
                    ),
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
                          style: kTitleText,
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
                          width: AppSize.getDeviceWidth(context),
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
                                  lastDate:
                                      DateTime.now().add(Duration(days: 1000)));
                              if (date != null) {
                                dateTime = date;
                                scheduleInterview.text =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
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
                          style: kTitleText,
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
                              width: AppSize.getDeviceWidth(context) * 0.45,
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
                            Text(
                                JapaneseText.graduationSchoolFacultyDepartment),
                            AppSize.spaceHeight5,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.45,
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
                    Text(JapaneseText.academicBackground),
                    AppSize.spaceHeight5,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: academicBgList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: AppSize.getDeviceWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PrimaryTextField(
                                  controller: academicBgList[index],
                                  hint: "未設定",
                                  maxLine: 1,
                                  isRequired: false,
                                ),
                              ),
                              AppSize.spaceWidth16,
                              (academicBgList.length - 1) == index
                                  ? Center(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              academicBgList.add(
                                                  TextEditingController(
                                                      text: ""));
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
                          ),
                        );
                      },
                    ),
                    Text(JapaneseText.workHistory),
                    AppSize.spaceHeight5,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workHistory.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: AppSize.getDeviceWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PrimaryTextField(
                                  controller: workHistory[index],
                                  hint: "未設定",
                                  maxLine: 1,
                                  isRequired: false,
                                ),
                              ),
                              AppSize.spaceWidth16,
                              (workHistory.length - 1) == index
                                  ? Center(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              workHistory.add(
                                                  TextEditingController(
                                                      text: ""));
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
                          ),
                        );
                      },
                    ),
                    Text(JapaneseText.ordinaryAutomaticLicense),
                    AppSize.spaceHeight5,
                    SizedBox(
                      width: AppSize.getDeviceWidth(context) - 32,
                      child: PrimaryTextField(
                        controller: ordinaryAutoLisence,
                        hint: "未設定",
                        maxLine: 1,
                        isRequired: false,
                      ),
                    ),
                    Text(JapaneseText.otherQualification),
                    AppSize.spaceHeight5,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: otherQualList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PrimaryTextField(
                                controller: otherQualList[index],
                                hint: "未設定",
                                maxLine: 1,
                                isRequired: false,
                              ),
                            ),
                            AppSize.spaceWidth16,
                            (otherQualList.length - 1) == index
                                ? Center(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            otherQualList.add(
                                                TextEditingController(
                                                    text: ""));
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
                    Text(JapaneseText.employmentHistory),
                    AppSize.spaceHeight5,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: employmentHistoryList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: PrimaryTextField(
                              controller: employmentHistoryList[index],
                              hint: "未設定",
                              maxLine: 1,
                              isRequired: false,
                            )),
                            AppSize.spaceWidth16,
                            (employmentHistoryList.length - 1) == index
                                ? Center(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            employmentHistoryList.add(
                                                TextEditingController(
                                                    text: ""));
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
                                            employmentHistoryList
                                                .removeAt(index);
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
                    AppSize.spaceHeight16,
                    Center(
                      child: SizedBox(
                        width: AppSize.getDeviceWidth(context) * 0.4,
                        height: 56,
                        child: ButtonWidget(
                            title: JapaneseText.save,
                            color: AppColor.primaryColor,
                            onPress: () => onSaveUserData()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
