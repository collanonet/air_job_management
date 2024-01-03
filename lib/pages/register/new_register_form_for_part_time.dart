import 'package:air_job_management/pages/register/widget/register_step.dart';
import 'package:air_job_management/pages/register/widget/select_box_tile.dart';
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

class NewFormRegistrationForPartTimePage extends StatefulWidget {
  final MyUser myUser;
  const NewFormRegistrationForPartTimePage({Key? key, required this.myUser})
      : super(key: key);

  @override
  State<NewFormRegistrationForPartTimePage> createState() =>
      _NewFormRegistrationForPartTimePageState();
}

class _NewFormRegistrationForPartTimePageState
    extends State<NewFormRegistrationForPartTimePage> {
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
                  isFullTime: false,
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
                if (provider.step == 2 && selectedAffiliation == null) {
                  toastMessageError("選んでください所属。", context);
                }
                if (provider.step == 3 && selectedQualificationsField == null) {
                  toastMessageError("選んでください保有資格。", context);
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
    }
    {
      return step4();
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

  String? selectedAffiliation;
  String? selectedQualificationsField;

  step2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            JapaneseText.affiliationStep2,
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.highSchoolStudent2,
                  val: selectedAffiliation == JapaneseText.highSchoolStudent2,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.highSchoolStudent2;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.highSchoolStudent2,
                  val: selectedAffiliation == JapaneseText.vocationalStudent,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.vocationalStudent;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.universityOrGraduatedStudent,
                  val: selectedAffiliation ==
                      JapaneseText.universityOrGraduatedStudent,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation =
                            JapaneseText.universityOrGraduatedStudent;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.partTimeJob2,
                  val: selectedAffiliation == JapaneseText.partTimeJob2,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.partTimeJob2;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.companyEmployeeFullTime,
                  val: selectedAffiliation ==
                      JapaneseText.companyEmployeeFullTime,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation =
                            JapaneseText.companyEmployeeFullTime;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.companyEmployeeContractOrTemporary,
                  val: selectedAffiliation ==
                      JapaneseText.companyEmployeeContractOrTemporary,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation =
                            JapaneseText.companyEmployeeContractOrTemporary;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.highSchoolStudent2,
                  val: selectedAffiliation ==
                      JapaneseText.freelanceOrSelfEmployed,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation =
                            JapaneseText.freelanceOrSelfEmployed;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.highSchoolStudent2,
                  val: selectedAffiliation == JapaneseText.houseWife,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.houseWife;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.unemployed,
                  val: selectedAffiliation == JapaneseText.unemployed,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.unemployed;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.notApplicable,
                  val: selectedAffiliation == JapaneseText.notApplicable,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedAffiliation = null;
                      });
                    } else {
                      setState(() {
                        selectedAffiliation = JapaneseText.notApplicable;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          AppSize.spaceHeight50,
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
            JapaneseText.qualificationsFieldStep3,
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.driveLicenseNormal,
                  val: selectedQualificationsField ==
                      JapaneseText.driveLicenseNormal,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.driveLicenseNormal;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.driveLicenseMediumOrLarge,
                  val: selectedQualificationsField ==
                      JapaneseText.driveLicenseMediumOrLarge,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.driveLicenseMediumOrLarge;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.driveLicenseMoto,
                  val: selectedQualificationsField ==
                      JapaneseText.driveLicenseMoto,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.driveLicenseMoto;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.forkliftDrivingSkill,
                  val: selectedQualificationsField ==
                      JapaneseText.forkliftDrivingSkill,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.forkliftDrivingSkill;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.hazardousMaterialsHandlerABC,
                  val: selectedQualificationsField ==
                      JapaneseText.hazardousMaterialsHandlerABC,
                  onChange: (v) {
                    if (v == selectedAffiliation) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.hazardousMaterialsHandlerABC;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText
                      .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel2,
                  val: selectedQualificationsField ==
                      JapaneseText
                          .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel2,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText
                            .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel2;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText
                      .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel1,
                  val: selectedQualificationsField ==
                      JapaneseText
                          .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel1,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText
                            .personWhoHasCompletedTrainingForFirstTimeCareWorkersLevel1;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.careWorker,
                  val: selectedQualificationsField == JapaneseText.careWorker,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.careWorker;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.nursingCareSupportSpecialist,
                  val: selectedQualificationsField ==
                      JapaneseText.nursingCareSupportSpecialist,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.nursingCareSupportSpecialist;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.nurseTeacher,
                  val: selectedQualificationsField == JapaneseText.nurseTeacher,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.nurseTeacher;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.doctor,
                  val: selectedQualificationsField == JapaneseText.doctor,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.doctor;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.pharmacist,
                  val: selectedQualificationsField == JapaneseText.pharmacist,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.pharmacist;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.nurseAssociateNurse,
                  val: selectedQualificationsField ==
                      JapaneseText.nurseAssociateNurse,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.nurseAssociateNurse;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.physicalTherapistOccupational,
                  val: selectedQualificationsField ==
                      JapaneseText.physicalTherapistOccupational,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.physicalTherapistOccupational;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.chef,
                  val: selectedQualificationsField == JapaneseText.chef,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.chef;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.registeredDietitianNutritionist,
                  val: selectedQualificationsField ==
                      JapaneseText.registeredDietitianNutritionist,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.registeredDietitianNutritionist;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.itSupport,
                  val: selectedQualificationsField == JapaneseText.itSupport,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.itSupport;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.basicInformationEngineer,
                  val: selectedQualificationsField ==
                      JapaneseText.basicInformationEngineer,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.basicInformationEngineer;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.appliedInformationEngineer,
                  val: selectedQualificationsField ==
                      JapaneseText.appliedInformationEngineer,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.appliedInformationEngineer;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.itStrategist,
                  val: selectedQualificationsField == JapaneseText.itStrategist,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField = JapaneseText.itStrategist;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.hairdresserBarber,
                  val: selectedQualificationsField ==
                      JapaneseText.hairdresserBarber,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.hairdresserBarber;
                      });
                    }
                  }),
              SelectBoxListTileWidget(
                  size: (AppSize.getDeviceWidth(context) * 0.5) - 24,
                  title: JapaneseText.massageTherapist,
                  val: selectedQualificationsField ==
                      JapaneseText.massageTherapist,
                  onChange: (v) {
                    if (v == selectedQualificationsField) {
                      setState(() {
                        selectedQualificationsField = null;
                      });
                    } else {
                      setState(() {
                        selectedQualificationsField =
                            JapaneseText.massageTherapist;
                      });
                    }
                  }),
            ],
          ),
          AppSize.spaceHeight16,
          nextButtonWidget(),
          AppSize.spaceHeight50,
        ],
      ),
    );
  }

  step4() {
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
