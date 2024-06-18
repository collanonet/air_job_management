import 'package:air_job_management/api/company/request.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../pages/register/widget/radio_list_tile.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/title.dart';
import '../1_company_page/applicant/applicant_root.dart';
import '../api/company/worker_managment.dart';
import '../api/entry_exit.dart';
import '../models/worker_model/shift.dart';

class UserBasicInformationPage extends StatefulWidget {
  final MyUser? myUser;
  const UserBasicInformationPage({super.key, required this.myUser});

  @override
  State<UserBasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<UserBasicInformationPage> with AfterBuildMixin {
  MyUser? myUser;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    myUser = widget.myUser;
    super.initState();
  }

  String numberOfWorkTime = "";
  String cancellationRate = "";
  String lastMinuteCancellationRate = "";
  List<ShiftModel> shiftList = [];

  lastMinCountCancelTimes() {
    int i = 0;
    for (var shift in shiftList) {
      if (shift.status == "canceled") {
        i++;
      }
    }
    return i == 0 ? "0" : "${(i * 100) / shiftList.length}";
  }

  cancellationRatesTimes() {
    int i = 0;
    DateTime now = DateTime.now();
    DateTime lastOne = DateTime(now.year, now.month, now.day - 1);
    DateTime lastTwo = DateTime(now.year, now.month, now.day - 2);
    DateTime lastThree = DateTime(now.year, now.month, now.day - 3);
    List<DateTime> dateList = [now, lastOne, lastTwo, lastThree];
    for (var request in requestByUserList) {
      DateTime date = DateToAPIHelper.fromApiToLocal(request.date!);
      if (request.status == "approved" && CommonUtils.isArrayOfDateContainDate(dateList, date)) {
        i++;
      }
    }
    return i == 0 ? "0" : "${(i * 100) / requestByUserList.length}";
  }

  countWorkingHistory(String id) {
    int i = 0;
    for (var entry in entryForApplicant) {
      if (entry.userId == id) {
        i++;
      }
    }
    return i.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.7,
      decoration: boxDecorationNoTopRadius,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.spaceHeight16,
              achievementsWidget(),
              AppSize.spaceHeight8,
              Divider(
                color: AppColor.thirdColor.withOpacity(0.3),
              ),
              AppSize.spaceHeight8,
              basicInformationWidget(),
              AppSize.spaceHeight8,
              Divider(
                color: AppColor.thirdColor.withOpacity(0.3),
              ),
              AppSize.spaceHeight8,
              buildUserLocation(),
              AppSize.spaceHeight8,
              buildIdentificationCard(),
              AppSize.spaceHeight20,
              AppSize.spaceHeight50,
            ],
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
                "$lastMinuteCancellationRate%",
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
                "$cancellationRate%",
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
                "$numberOfWorkTime回",
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
      const TitleWidget(title: "基本情報"),
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
                  controller: TextEditingController(text: "${myUser?.nameKanJi}"),
                  isRequired: false,
                  readOnly: true,
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
                  controller: TextEditingController(text: "${myUser?.nameFu}"),
                  isRequired: false,
                  readOnly: true,
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
                  controller: TextEditingController(text: "${myUser?.dob}"),
                  isRequired: false,
                  readOnly: true,
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
                onChange: (v) {},
                size: 120,
                val: myUser?.gender ?? "",
              )),
          AppSize.spaceWidth32,
          Padding(
              padding: const EdgeInsets.only(top: 7),
              child: RadioListTileWidget(
                title: JapaneseText.female,
                onChange: (v) {},
                size: 120,
                val: myUser?.gender ?? "",
              )),
          AppSize.spaceWidth32,
          Padding(
              padding: const EdgeInsets.only(top: 7),
              child: RadioListTileWidget(
                title: "その他",
                onChange: (v) {},
                size: 120,
                val: myUser?.gender ?? "",
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
                  controller: TextEditingController(text: "${myUser?.phone}"),
                  isRequired: false,
                  readOnly: true,
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
                  controller: TextEditingController(text: "${myUser?.email}"),
                  isRequired: false,
                  readOnly: true,
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
                    "所属",
                    style: kNormalText.copyWith(fontSize: 12),
                  )),
              AppSize.spaceHeight5,
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.2,
                child: PrimaryTextField(
                  hint: "",
                  controller: TextEditingController(text: "${myUser?.affiliation}"),
                  isRequired: false,
                  readOnly: true,
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
                width: AppSize.getDeviceWidth(context) * 0.4,
                child: PrimaryTextField(
                  hint: "",
                  controller:
                      TextEditingController(text: myUser?.otherQualificationList!.map((e) => e).toString().replaceAll("(", "").replaceAll(")", "")),
                  isRequired: false,
                  readOnly: true,
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
                  controller: TextEditingController(text: myUser?.postalCode ?? ""),
                  isRequired: false,
                  readOnly: true,
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
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.13,
                child: PrimaryTextField(
                  hint: "",
                  controller: TextEditingController(text: "${myUser?.city ?? myUser?.province ?? myUser?.street}"),
                  isRequired: false,
                  readOnly: true,
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
                  controller: TextEditingController(text: myUser?.dob ?? ""),
                  isRequired: false,
                  readOnly: true,
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
          controller: TextEditingController(text: myUser?.street ?? ""),
          isRequired: false,
          readOnly: true,
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
          controller: TextEditingController(text: myUser?.building ?? ""),
          isRequired: false,
          readOnly: true,
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
          controller: TextEditingController(text: "${myUser?.note ?? ""}"),
          isRequired: false,
          readOnly: true,
        ),
      ),
    ]);
  }

  ScrollController scrollController2 = ScrollController();

  buildIdentificationCard() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWidget(title: "本人確認"),
      SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: 250,
        child: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController2,
          child: SingleChildScrollView(
            controller: scrollController2,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                displayImage("${myUser?.number_card_url}"),
                AppSize.spaceWidth32,
                displayImage("${myUser?.passport_url}"),
                AppSize.spaceWidth32,
                displayImage("${myUser?.resident_record_url}"),
                AppSize.spaceWidth32,
                displayImage("${myUser?.driver_license_url}"),
                AppSize.spaceWidth32,
                displayImage("${myUser?.basic_resident_register_url}"),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  displayImage(String? url) {
    if (url == null || url == "") {
      return const SizedBox();
    }
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(0xffF0F3F5)),
      child: Image.network(url),
    );
  }

  @override
  void afterBuild(BuildContext context) async {
    // TODO: implement afterBuild
    var auth = Provider.of<AuthProvider>(context, listen: false);
    var data = await Future.wait([
      UserApiServices().getProfileUser(myUser?.uid ?? ""),
      EntryExitApiService().getAllEntryList(auth.myCompany?.uid ?? ""),
      RequestApiService().getAllHolidayRequestByUsers(myUser?.uid ?? ""),
      WorkerManagementApiService().getAllJobApplyForAUSer(auth.myCompany?.uid ?? "", myUser?.uid ?? "", auth.branch?.id ?? "")
    ]);
    myUser = data[0] as MyUser?;
    entryForApplicant = data[1] as List<EntryExitHistory>;
    requestByUserList = data[2] as List<Request>;
    var listWorker = data[3] as List<WorkerManagement>;
    for (var job in listWorker) {
      shiftList.addAll(job.shiftList ?? []);
    }
    lastMinuteCancellationRate = lastMinCountCancelTimes();
    numberOfWorkTime = countWorkingHistory(myUser?.uid ?? "");
    cancellationRate = cancellationRatesTimes();
    setState(() {});
  }
}
