import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../2_worker_page/viewprofile/widgets/pickimage.dart';
import '../../api/company/worker_managment.dart';
import '../../api/worker_api/search_api.dart';
import '../../models/worker_model/search_job.dart';
import '../../pages/register/widget/radio_list_tile.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/title.dart';

class CreateOutsideStaffPage extends StatefulWidget {
  final String? uid;
  const CreateOutsideStaffPage({super.key, this.uid});

  @override
  State<CreateOutsideStaffPage> createState() => _CreateOutsideStaffPageState();
}

class _CreateOutsideStaffPageState extends State<CreateOutsideStaffPage> with AfterBuildMixin {
  ScrollController verticalScroll = ScrollController();
  ScrollController horizontalScroll = ScrollController();
  TextEditingController nameKhanJi = TextEditingController();
  TextEditingController nameFu = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController affiliation = TextEditingController();
  TextEditingController qualificationFields = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController municipalities = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController memo = TextEditingController();

  String selectedGender = JapaneseText.male;
  String? selectedLocation;
  List<String> urlList = [];
  late JobPostingForCompanyProvider provider;
  late AuthProvider authProvider;
  late WorkerManagementProvider workerManagementProvider;
  late HomeProvider homeProvider;
  List<dynamic> fileList = [null];
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  WorkerManagement? workerManagement;

  @override
  void initState() {
    if (widget.uid != null) {
      isLoading = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    workerManagementProvider = Provider.of<WorkerManagementProvider>(context);
    homeProvider = Provider.of<HomeProvider>(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
        child: Container(
          width: AppSize.getDeviceWidth(context),
          decoration: boxDecorationNoTopRadius,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          margin: const EdgeInsets.all(32),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: verticalScroll,
            child: SingleChildScrollView(
              controller: verticalScroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.spaceHeight30,
                  // achievementsWidget(),
                  // AppSize.spaceHeight20,
                  // Divider(
                  //   color: AppColor.thirdColor.withOpacity(0.3),
                  // ),
                  // AppSize.spaceHeight20,
                  basicInformationWidget(),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  buildUserLocation(),
                  AppSize.spaceHeight20,
                  buildIdentificationCard(),
                  AppSize.spaceHeight20,
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => saveData()),
                    ),
                  ),
                  AppSize.spaceHeight50,
                  AppSize.spaceHeight20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  achievementsWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWidget(title: "実績"),
      AppSize.spaceHeight16,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "直前キャンセル率",
                style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
              ),
              AppSize.spaceHeight5,
              Text(
                "5%",
                style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal"),
              )
            ],
          ),
          Container(
            width: 2,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: AppColor.primaryColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "キャンセル率",
                style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
              ),
              AppSize.spaceHeight5,
              Text(
                "10%",
                style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal"),
              )
            ],
          ),
          Container(
            width: 2,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: AppColor.primaryColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "この店舗で働いた回数",
                style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
              ),
              AppSize.spaceHeight5,
              Text(
                "25回",
                style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal"),
              )
            ],
          ),
        ],
      )
    ]);
  }

  basicInformationWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TitleWidget(title: "基本情報"),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      AppSize.spaceHeight16,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.nameKanJi,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: nameKhanJi,
                  isRequired: true,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.nameFugigana,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: nameFu,
                  isRequired: true,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.dob,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: dob,
                  isRequired: false,
                  readOnly: true,
                  onTap: () async {
                    var date =
                        await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                    if (date != null) {
                      setState(() {
                        dob.text = DateToAPIHelper.convertDateToString(date);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      AppSize.spaceHeight8,
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            JapaneseText.gender,
            style: kNormalText.copyWith(fontSize: 12),
          )),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 7),
              child: RadioListTileWidget(
                title: JapaneseText.male,
                onChange: (v) {
                  setState(() {
                    selectedGender = v;
                  });
                },
                size: 120,
                val: selectedGender,
              )),
          AppSize.spaceWidth32,
          Padding(
              padding: const EdgeInsets.only(top: 7),
              child: RadioListTileWidget(
                title: JapaneseText.female,
                onChange: (v) {
                  setState(() {
                    selectedGender = v;
                  });
                },
                size: 120,
                val: selectedGender,
              )),
          AppSize.spaceWidth32,
          Padding(
              padding: const EdgeInsets.only(top: 7),
              child: RadioListTileWidget(
                title: "その他",
                onChange: (v) {
                  setState(() {
                    selectedGender = v;
                  });
                },
                size: 120,
                val: selectedGender,
              )),
        ],
      ),
      AppSize.spaceHeight8,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.phone,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: phone,
                  isRequired: false,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.email,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: email,
                  isRequired: false,
                ),
              ),
            ],
          ),
        ],
      ),
      AppSize.spaceHeight8,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.affiliate,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: affiliation,
                  isRequired: false,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.qualificationsFieldStep3,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: qualificationFields,
                  isRequired: false,
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  buildUserLocation() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.postalCode,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.13,
                child: PrimaryTextField(
                  hint: "",
                  controller: postalCode,
                  isRequired: false,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    JapaneseText.location,
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              CustomDropDownWidget(
                radius: 5,
                list: provider.locationList,
                onChange: (v) {
                  setState(() {
                    selectedLocation = v;
                  });
                },
                selectItem: selectedLocation,
              ),
            ],
          ),
          AppSize.spaceWidth32,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "市区町村",
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: municipalities,
                  isRequired: false,
                ),
              ),
            ],
          ),
        ],
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "町名番地",
            style: kNormalText.copyWith(fontSize: 12),
          )),
      AppSize.spaceHeight5,
      SizedBox(
        width: (AppSize.getDeviceWidth(context) * 0.4) + 32,
        child: PrimaryTextField(
          hint: "",
          controller: street,
          isRequired: false,
        ),
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "建物名",
            style: kNormalText.copyWith(fontSize: 12),
          )),
      AppSize.spaceHeight5,
      SizedBox(
        width: (AppSize.getDeviceWidth(context) * 0.4) + 32,
        child: PrimaryTextField(
          hint: "",
          controller: buildingName,
          isRequired: false,
        ),
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "メモ",
            style: kNormalText.copyWith(fontSize: 12),
          )),
      AppSize.spaceHeight5,
      SizedBox(
        width: (AppSize.getDeviceWidth(context) * 0.4) + 32,
        child: PrimaryTextField(
          hint: "",
          maxLine: 4,
          controller: memo,
          isRequired: false,
        ),
      ),
    ]);
  }

  buildIdentificationCard() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWidget(title: "本人確認"),
      AppSize.spaceHeight16,
      SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: 162,
        child: Scrollbar(
          isAlwaysShown: true,
          controller: horizontalScroll,
          child: ListView.builder(
              controller: horizontalScroll,
              itemCount: fileList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                dynamic file = fileList[index];
                if (file != null) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Stack(
                      children: [
                        file.toString().contains("https")
                            ? Container(
                                width: 320,
                                height: 162,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1, color: AppColor.thirdColor),
                                ),
                                child: Image.network(file.toString(), fit: BoxFit.cover),
                              )
                            : Container(
                                width: 320,
                                height: 162,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 1, color: AppColor.thirdColor),
                                    image: DecorationImage(image: MemoryImage(file.files.first.bytes!), fit: BoxFit.cover)),
                              ),
                        Positioned(
                            top: 5,
                            right: 15,
                            child: IconButton(
                                onPressed: () => provider.onRemoveFile(index),
                                icon: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColor.primaryColor),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ))))
                      ],
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () => onSelectFile(),
                    child: Container(
                      width: 320,
                      height: 162,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: AppColor.thirdColor)),
                      child: Center(
                        child: IconButton(
                            onPressed: () => onSelectFile(),
                            icon: Icon(
                              Icons.add_circle,
                              color: AppColor.primaryColor,
                              size: 24,
                            )),
                      ),
                    ),
                  );
                }
              }),
        ),
      )
    ]);
  }

  onSelectFile() async {
    var file = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ["jpg", "png", "jpeg"]);
    if (file != null) {
      setState(() {
        fileList.add(file);
      });
    }
  }

  saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      List<String> idenUrl = [];
      for (int i = 0; i < fileList.length; i++) {
        var file = fileList[i];
        if (file != null) {
          if (file.toString().contains("https")) {
            idenUrl.add(file.toString());
          } else {
            String imageUrl = await fileToUrl(file.files.first.bytes!, "outside_user_identification");
            idenUrl.add(imageUrl);
          }
        }
      }
      var user = MyUser(
          email: email.text,
          nameFu: nameFu.text,
          nameKanJi: nameKhanJi.text,
          dob: dob.text,
          affiliation: affiliation.text,
          qualificationFields: qualificationFields.text,
          city: municipalities.text,
          note: memo.text,
          gender: selectedGender,
          role: 'worker',
          phone: phone.text,
          postalCode: postalCode.text,
          street: street.text,
          building: buildingName.text);
      var info = SearchJob(
        jobLocation: selectedLocation,
        companyId: authProvider.myCompany?.uid ?? "",
        company: authProvider.myCompany?.companyName ?? "",
      );
      bool isSuccess = await SearchJobApi().createJobRequestForOutsideUser(
          authProvider.branch?.id ?? "",
          widget.uid,
          info,
          user,
          [
            ShiftModel(price: "0", endBreakTime: "13:00", endWorkTime: "18:00", startBreakTime: "12:00", startWorkTime: "09:00", date: DateTime.now())
          ],
          idenUrl);
      setState(() {
        isLoading = false;
      });
      if (isSuccess) {
        toastMessageSuccess(widget.uid != null ? JapaneseText.successUpdate : JapaneseText.successCreate, context);
        await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
        context.go(MyRoute.companyWorker);
      } else {
        toastMessageError(errorMessage, context);
      }
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    if (widget.uid != null) {
      workerManagement = await WorkerManagementApiService().getAJob(widget.uid.toString());
      setState(() {
        isLoading = false;
      });
      if (workerManagement != null) {
        nameKhanJi.text = workerManagement?.myUser?.nameKanJi ?? "";
        nameFu.text = workerManagement?.myUser?.nameFu ?? "";
        for (var image in workerManagement!.userIdenList!) {
          fileList.add(image);
        }
        nameFu.text = workerManagement?.myUser?.nameFu ?? "";
        dob.text = workerManagement?.myUser?.dob ?? "";
        phone.text = workerManagement?.myUser?.phone ?? "";
        email.text = workerManagement?.myUser?.email ?? "";
        affiliation.text = workerManagement?.myUser?.affiliation ?? "";
        qualificationFields.text = workerManagement?.myUser?.qualificationFields ?? "";
        postalCode.text = workerManagement?.myUser?.postalCode ?? "";
        municipalities.text = workerManagement?.myUser?.city ?? "";
        selectedLocation = workerManagement?.jobLocation;
        selectedGender = workerManagement?.myUser?.gender ?? "";
        street.text = workerManagement?.myUser?.street ?? "";
        buildingName.text = workerManagement?.myUser?.building ?? "";
        memo.text = workerManagement?.myUser?.note ?? "";
      }
    }
  }
}
