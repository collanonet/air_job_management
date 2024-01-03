import 'package:air_job_management/pages/register/widget/check_box.dart';
import 'package:air_job_management/pages/register/widget/register_step.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../api/user_api.dart';
import '../../const/const.dart';
import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/radio_listtile.dart';

class NewFormRegistrationPage extends StatefulWidget {
  final MyUser myUser;
  const NewFormRegistrationPage({Key? key, required this.myUser})
      : super(key: key);

  @override
  State<NewFormRegistrationPage> createState() =>
      _NewFormRegistrationPageState();
}

class _NewFormRegistrationPageState extends State<NewFormRegistrationPage> {
  late AuthProvider provider;
  //User Info Step 1
  TextEditingController nameKanJi = TextEditingController(text: "");
  TextEditingController nameFurigana = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController dob = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  //Address Step 2
  TextEditingController postalCode = TextEditingController(text: "");
  TextEditingController province = TextEditingController(text: "");
  TextEditingController city = TextEditingController(text: "");
  TextEditingController street = TextEditingController(text: "");
  TextEditingController building = TextEditingController(text: "");
  TextEditingController addressRemark = TextEditingController(text: "");

  //Step 3
  bool notWorking = false;
  bool contractJob = false;
  bool fullTimeJob = false;
  bool temporary = false;
  bool partTimeJob = false;
  TextEditingController finalEdu = TextEditingController(text: "");
  TextEditingController graduateSchoolFaculty = TextEditingController(text: "");
  List<TextEditingController> academicBgList = [
    TextEditingController(text: "")
  ];
  List<TextEditingController> workHistory = [TextEditingController(text: "")];
  String driverLicence = JapaneseText.have;
  TextEditingController otherQual = TextEditingController(text: "");
  TextEditingController employeeHistory = TextEditingController(text: "");

  //Step 4
  FilePickerResult? selectedFile;

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  String gender = JapaneseText.male;

  @override
  void initState() {
    email.text = widget.myUser.email ?? "";
    Provider.of<AuthProvider>(context, listen: false).setStep = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            title: const Text("情報入力ページ"),
            centerTitle: true,
          ),
          body: Container(
            width: AppSize.getDeviceWidth(context),
            height: AppSize.getDeviceHeight(context) * 0.96,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                RegisterStepWidget(
                  isFullTime: true,
                  provider: provider,
                ),
                AppSize.spaceHeight16,
                Expanded(child: buildContent())
              ],
            ),
          ),
        ),
      ),
    );
  }

  nextButtonWidget() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context) - 32,
      child: ButtonWidget(
          color: AppColor.primaryColor,
          onPress: () async {
            if (provider.step == 5) {
              onSaveUserData();
            } else {
              if (_formKey.currentState!.validate()) {
                if (provider.step == 4 && selectedFile == null) {
                  toastMessageError("本人確認書類をアップロードする必要があります。", context);
                } else {
                  provider.onChangeStep(provider.step + 1);
                }
              } else {
                //Please double check each step and enter data in the required fields.
                toastMessageError("各ステップを再確認し、必須フィールドにデータを入力してください。", context);
              }
            }
          },
          title: provider.step == 5 ? "終わり" : "次へ"),
    );
  }

  onSaveUserData() async {
    setState(() {
      isLoading = true;
    });
    String imageUrl = "";
    if (selectedFile != null) {
      imageUrl = await fileToUrl(selectedFile!, "verify_doc");
      // widget.myUser.profile = imageUrl;
    }
    widget.myUser.notWorking = notWorking;
    widget.myUser.contractJob = contractJob;
    widget.myUser.fullTimeJob = fullTimeJob;
    widget.myUser.temporary = temporary;
    widget.myUser.partTimeJob = partTimeJob;
    widget.myUser.verifyDoc = imageUrl;
    widget.myUser.postalCode = postalCode.text;
    widget.myUser.province = province.text;
    widget.myUser.city = city.text;
    widget.myUser.street = street.text;
    widget.myUser.building = building.text;
    widget.myUser.nameKanJi = nameKanJi.text;
    widget.myUser.nameFu = nameFurigana.text;
    widget.myUser.phone = phone.text;
    widget.myUser.note = addressRemark.text;
    widget.myUser.dob = dob.text;
    widget.myUser.email = email.text;
    widget.myUser.interviewDate = "";
    widget.myUser.finalEdu = finalEdu.text;
    widget.myUser.graduationSchool = graduateSchoolFaculty.text;
    widget.myUser.academicBgList = academicBgList.map((e) => e.text).toList();
    widget.myUser.workHistoryList = workHistory.map((e) => e.text).toList();
    widget.myUser.ordinaryAutomaticLicence = "";
    widget.myUser.otherQualificationList = [otherQual.text];
    widget.myUser.employmentHistoryList = [employeeHistory.text];
    String? val = await UserApiServices().updateUserData(widget.myUser);
    setState(() {
      isLoading = false;
    });
    if (val == ConstValue.success) {
      toastMessageSuccess(JapaneseText.successUpdate, context);
      await Future.delayed(const Duration(milliseconds: 300));
      // await FirebaseAuth.instance.signOut();
      context.go(MyRoute.jobOption);
    } else {
      toastMessageError("$val", context);
    }
  }

  buildContent() {
    if (provider.step == 1) {
      return step1();
    } else if (provider.step == 2) {
      return step2();
    } else if (provider.step == 3) {
      return step3();
    } else if (provider.step == 4) {
      return step4();
    } else {
      return step5();
    }
  }

  step1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "名前/連絡先",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Text(JapaneseText.nameKanJi),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: nameKanJi,
            hint: '鈴木　太郎',
          ),
          Text(JapaneseText.nameFugigana),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: nameFurigana,
            hint: 'すずき　たろう',
          ),
          AppSize.spaceHeight16,
          Text(JapaneseText.phone),
          AppSize.spaceHeight5,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTileWidget(
                title: JapaneseText.male,
                size: 90,
                val: gender,
                onChange: (v) {
                  setState(() {
                    gender = v;
                  });
                },
              ),
              AppSize.spaceWidth8,
              RadioListTileWidget(
                title: JapaneseText.female,
                size: 90,
                val: gender,
                onChange: (v) {
                  setState(() {
                    gender = v;
                  });
                },
              ),
              AppSize.spaceWidth8,
              RadioListTileWidget(
                title: JapaneseText.other,
                size: 110,
                val: gender,
                onChange: (v) {
                  setState(() {
                    gender = v;
                  });
                },
              ),
            ],
          ),
          //Phone & Dob
          Text(JapaneseText.phone),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: phone,
            hint: '090−1234−5678',
          ),
          Text(JapaneseText.dob),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: dob,
            hint: '2000/07/01',
            readOnly: true,
            onTap: () async {
              var date = await showDatePicker(
                  locale: const Locale("ja", "JP"),
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
          Text(JapaneseText.email),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: email,
            isRequired: false,
            readOnly: true,
            hint: JapaneseText.email,
          ),
          AppSize.spaceHeight16,
          nextButtonWidget(),
          AppSize.spaceHeight50
        ],
      ),
    );
  }

  step2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "住所",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Text(JapaneseText.postalCode),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: postalCode,
            hint: '111-0032',
          ),
          Text(JapaneseText.province),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: province,
            hint: '東京都',
          ),
          AppSize.spaceHeight5,
          Text(JapaneseText.city),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: city,
            hint: '東京都台東区',
          ),
          AppSize.spaceHeight5,
          Text(JapaneseText.street),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: street,
            hint: '浅草2-27-9',
          ),
          AppSize.spaceHeight5,
          Text(JapaneseText.building),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: building,
            hint: 'クレセンコート 4F',
          ),
          AppSize.spaceHeight5,
          Text(JapaneseText.remark),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: addressRemark,
            hint: '何かメッセージがあれば ご入力ください',
            maxLine: 5,
            isRequired: false,
          ),
          AppSize.spaceHeight16,
          nextButtonWidget(),
          AppSize.spaceHeight50
        ],
      ),
    );
  }

  step3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "現在の就業状況",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckBoxListTileWidget(
                  size: 180,
                  title: JapaneseText.notWorking,
                  val: notWorking,
                  onChange: (v) {
                    setState(() {
                      notWorking = v;
                    });
                  }),
              CheckBoxListTileWidget(
                  size: 180,
                  title: JapaneseText.fullTimeJob,
                  val: fullTimeJob,
                  onChange: (v) {
                    setState(() {
                      fullTimeJob = v;
                    });
                  })
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckBoxListTileWidget(
                  size: 180,
                  title: JapaneseText.contractJob,
                  val: contractJob,
                  onChange: (v) {
                    setState(() {
                      contractJob = v;
                    });
                  }),
              CheckBoxListTileWidget(
                  size: 180,
                  title: JapaneseText.temporary,
                  val: temporary,
                  onChange: (v) {
                    setState(() {
                      temporary = v;
                    });
                  })
            ],
          ),
          CheckBoxListTileWidget(
              size: 280,
              title: JapaneseText.partTimeJob,
              val: partTimeJob,
              onChange: (v) {
                setState(() {
                  partTimeJob = v;
                });
              }),
          const Divider(),
          AppSize.spaceHeight16,
          Text(
            "学歴/職歴/資格",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Text(JapaneseText.finalEducation),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: finalEdu,
            hint: "サンプル大学",
            maxLine: 1,
            isRequired: false,
          ),
          Text(JapaneseText.graduationSchoolFacultyDepartment),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: graduateSchoolFaculty,
            hint: "浅草校　経済学部",
            maxLine: 1,
            isRequired: false,
          ),
          Text(JapaneseText.academicBackground),
          AppSize.spaceHeight5,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: academicBgList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PrimaryTextField(
                        controller: academicBgList[index],
                        hint: "浅草校　経済学部",
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
                                    academicBgList
                                        .add(TextEditingController(text: ""));
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
            itemBuilder: (context, index) {
              return SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PrimaryTextField(
                        controller: workHistory[index],
                        hint: "サンプル株式会社",
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
                                    workHistory
                                        .add(TextEditingController(text: ""));
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
          Text(JapaneseText.driverLicense),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTileWidget(
                  title: JapaneseText.have,
                  val: driverLicence,
                  onChange: (v) {
                    setState(() {
                      driverLicence = v;
                    });
                  },
                  size: 120),
              RadioListTileWidget(
                  title: JapaneseText.none,
                  val: driverLicence,
                  onChange: (v) {
                    setState(() {
                      driverLicence = v;
                    });
                  },
                  size: 120)
            ],
          ),
          Text(JapaneseText.otherQualification),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: otherQual,
            hint: "書道1級",
            maxLine: 1,
            isRequired: false,
          ),
          Text(JapaneseText.employmentHistory),
          AppSize.spaceHeight5,
          PrimaryTextField(
            controller: employeeHistory,
            hint: "東京都台東区",
            maxLine: 1,
            isRequired: false,
          ),
          AppSize.spaceHeight16,
          nextButtonWidget(),
          AppSize.spaceHeight50,
        ],
      ),
    );
  }

  step4() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "本人確認書類をアップロード",
        style: kTitleText.copyWith(color: AppColor.primaryColor),
      ),
      AppSize.spaceHeight16,
      AppSize.spaceHeight16,
      Container(
        width: AppSize.getDeviceWidth(context),
        height: 230,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: AppColor.primaryColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            selectedFile != null
                ? Text("${selectedFile!.files.first.name}")
                : Icon(
                    Icons.file_copy_outlined,
                    color: AppColor.primaryColor,
                    size: 70,
                  ),
            SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.6,
              child: ButtonWidget(
                color: AppColor.primaryColor,
                title: "撮影または画像選択する",
                onPress: () async {
                  var file = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: false,
                      allowedExtensions: ["pdf", "jpg", "png", "jpeg", "db"]);
                  if (file != null) {
                    setState(() {
                      selectedFile = file;
                    });
                  }
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (context) {
                  //       return SizedBox(
                  //         width: AppSize.getDeviceWidth(context),
                  //         height: 200,
                  //         child: Column(
                  //           children: [
                  //             AppSize.spaceHeight8,
                  //             Text(
                  //               "オプションを選んでください",
                  //               style: kTitleText,
                  //             ),
                  //             AppSize.spaceHeight8,
                  //             //From Gallery
                  //             ListTile(
                  //               title: const Text("ギャラリーから"),
                  //               leading: const Icon(Icons.image_outlined),
                  //               onTap: () async {
                  //                 Navigator.pop(context);
                  //                 final ImagePicker picker = ImagePicker();
                  //                 final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  //                 if (image != null) {
                  //                   setState(() {
                  //                     selectedFile = File(image.path);
                  //                   });
                  //                 }
                  //               },
                  //             ),
                  //             const Divider(),
                  //             //From File System
                  //             ListTile(
                  //               title: const Text("ファイルシステムから"),
                  //               leading: const Icon(Icons.file_copy_outlined),
                  //               onTap: () async {
                  //                 Navigator.pop(context);
                  //                 var file = await FilePicker.platform
                  //                     .pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ["pdf", "jpg", "png", "jpeg", "db"]);
                  //                 if (file != null) {
                  //                   setState(() {
                  //                     selectedFile = file;
                  //                   });
                  //                 }
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     });
                },
              ),
            )
          ],
        ),
      ),
      AppSize.spaceHeight50,
      AppSize.spaceHeight16,
      nextButtonWidget(),
    ]));
  }

  step5() {
    return Center(
      child: Column(
        children: [
          Text(
            "すべての登録が完了しました",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight50,
          nextButtonWidget(),
        ],
      ),
    );
  }
}

fileToUrl(FilePickerResult? file, String folderName) async {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //Create a reference to the location you want to upload to in firebase
  try {
    var snap = await _storage
        .ref()
        .child("/$folderName/${file!.files.first.name}")
        .putData(file.files.first.bytes!);
    String dowUrl = await snap.ref.getDownloadURL();

    //returns the download url
    return dowUrl;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
