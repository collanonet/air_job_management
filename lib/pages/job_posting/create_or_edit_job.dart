import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/multi_select.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/company.dart';
import '../../const/const.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown_string.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../../widgets/custom_textfield.dart';

class CreateOrEditJobPage extends StatefulWidget {
  final String? jobPostId;
  const CreateOrEditJobPage({Key? key, required this.jobPostId}) : super(key: key);

  @override
  State<CreateOrEditJobPage> createState() => _CreateOrEditJobPageState();
}

class _CreateOrEditJobPageState extends State<CreateOrEditJobPage> with AfterBuildMixin {
  late JobPostingProvider provider;
  DateTime now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      DateTime start = MyDateTimeUtils.fromApiToLocal(provider.startRecruitDate.text);
      DateTime end = MyDateTimeUtils.fromApiToLocal(provider.endRecruitDate.text);
      if (end.isBefore(start)) {
        // End date is before start date validation
        toastMessageError("募集終了日が募集開始日より前です", context);
      } else if (!provider.interviewLocationLatLng.text.contains(", ") || !provider.companyLocationLatLng.text.contains(", ")) {
        //Invalid latitude and longitude of company location or interview location.
        toastMessageError("会社の所在地または面接の場所の緯度と経度が無効です。", context);
      } else {
        //Continue to create job posting
        JobPosting c = JobPosting(
            status: "",
            uid: widget.jobPostId ?? "",
            title: provider.title.text,
            endDate: provider.endRecruitDate.text,
            startDate: provider.startRecruitDate.text,
            annualHoliday: provider.numberOfAnnualHolidays.text,
            bonus: provider.bonus,
            breakTimeAsMinute: provider.breakTimeMinute.text,
            childCareLeaveSystem: provider.isChildCareSystem,
            company: provider.selectedCompany,
            companyId: provider.selectedCompanyId,
            content: provider.content.text,
            contentOfTheTest: provider.selectedContentOfTest.map((e) => e).toList(),
            description: provider.overview.text,
            desiredGender: provider.selectedDesiredGender,
            desiredNationality: provider.selectedNationality,
            dormOrCompanyHouse: provider.dorm,
            employmentContractProvisioning: provider.contractProvisioning == JapaneseText.yes,
            employmentType: provider.selectedEmploymentType,
            endTimeHour: provider.startWorkTime.text,
            holidayDetail: provider.holidayDetail.text,
            hotelCleaningLearningItem: provider.selectedHotelCleaningItemLearn.map((e) => e).toList(),
            image: provider.imageUrl,
            interviewLocation: Location(
                name: provider.interviewLocation.text,
                des: provider.interviewLocation.text,
                lat: provider.interviewLocationLatLng.text.split(", ")[0],
                lng: provider.interviewLocationLatLng.text.split(", ")[1]),
            isRemoteInterview: provider.isThereRemoteInterview,
            location: Location(
                name: provider.companyLocation.text,
                des: provider.companyLocation.text,
                lat: provider.companyLocationLatLng.text.split(", ")[0],
                lng: provider.companyLocationLatLng.text.split(", ")[1]),
            meals: provider.meals,
            necessaryJapanSkill: provider.selectedNecessaryJapanSkill,
            numberOfRecruit: provider.numberOfRecruitPeople.text,
            occupation: provider.chooseOccupationSkill,
            occupationType: provider.selectedOccupation,
            offHour: provider.offHour,
            otherQualification: provider.otherQualification.text,
            paidHoliday: provider.paidHoliday,
            raise: provider.raise,
            rehire: provider.isRetirementSystem,
            remarkOfRequirement: provider.remark.text,
            retirementSystem: provider.isRetirementSystem,
            reviews: [],
            salaryType: provider.salaryType,
            severancePay: provider.isRetirementBenefits,
            socialInsurance: "",
            startTimeHour: provider.startWorkTime.text,
            statusOfResidence: provider.selectedStatusOfRecident.map((e) => e).toList(),
            trailPeriod: provider.trailPeriod,
            transportExpense: provider.transportExpense,
            wifi: provider.wifi,
            workCatchPhrase: provider.title.text,
            employment: provider.isEmployment,
            health: provider.isHealth,
            industrialAccident: provider.isIndustrialAccident,
            publicWelfare: provider.isWelfare);
        String? val;
        if (widget.jobPostId != null) {
          val = await JobPostingApiService().updateJobPostingInfo(c);
        } else {
          val = await JobPostingApiService().createJob(c);
        }
        provider.onChangeLoading(false);
        if (val == ConstValue.success) {
          toastMessageSuccess(widget.jobPostId != null ? JapaneseText.successUpdate : JapaneseText.successCreate, context);
          await provider.getAllJobPost();
          context.pop();
          context.go(MyRoute.job);
        } else {
          toastMessageError("$val", context);
        }
      }
    }
  }

  @override
  void initState() {
    Provider.of<JobPostingProvider>(context, listen: false).setLoading = true;
    Provider.of<JobPostingProvider>(context, listen: false).setAllController = [];
    Provider.of<JobPostingProvider>(context, listen: false).setImage = "";
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    initialData();
  }

  initialData() async {
    await provider.onInitForJobPostingDetail(widget.jobPostId);
  }

  @override
  void dispose() {
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingProvider>(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: provider.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget(),
              AppSize.spaceHeight16,
              Container(
                padding: const EdgeInsets.all(12),
                width: AppSize.getDeviceWidth(context),
                height: AppSize.getDeviceHeight(context) - 110,
                decoration: boxDecoration,
                child: Scrollbar(
                  controller: controller,
                  isAlwaysShown: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chooseCompany(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [buildTitleOverviewAndContent(), AppSize.spaceWidth16, buildChooseProfile()],
                        ),
                        const Divider(),
                        AppSize.spaceHeight16,
                        buildOccupation(),
                        AppSize.spaceHeight16,
                        buildEmploymentContractProvisioning(),
                        AppSize.spaceHeight16,
                        buildTrailPeriod(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        buildBonus(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        buildNumberOfAnnualHolidayAndDetail(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        buildWifiAndMore(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        buildOnlineInterview(),
                        AppSize.spaceHeight16,
                        buildContentOfTest(),
                        AppSize.spaceHeight16,
                        buildSelectStatusOfRecident(),
                        AppSize.spaceHeight16,
                        buildHotelCleaningItem(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        //Application Requirements
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColor.primaryColor,
                            ),
                            AppSize.spaceWidth8,
                            Text(
                              JapaneseText.applicationRequirement,
                              style: titleStyle,
                            ),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        buildApplicationRequirementAndJapanSkill(),
                        AppSize.spaceHeight16,
                        const Divider(),
                        AppSize.spaceHeight16,
                        //Application Requirements
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColor.primaryColor,
                            ),
                            AppSize.spaceWidth8,
                            Text(
                              JapaneseText.employmentCondition,
                              style: titleStyle,
                            ),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        buildEmploymentCondition(),
                        AppSize.spaceHeight50,
                        Center(
                          child: SizedBox(
                            width: AppSize.getDeviceWidth(context) * 0.2,
                            child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                          ),
                        ),
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

  chooseCompany() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.company,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        CustomDropDownWidget(
          list: provider.allCompany.map((e) => e.companyName.toString()).toList(),
          onChange: (e) => provider.onChangeSelectCompanyForDetail(e),
          width: AppSize.getDeviceWidth(context) * 0.6,
          selectItem: provider.selectedCompany,
        )
      ],
    );
  }

  buildTitleOverviewAndContent() {
    return Column(
      children: [
        //Title
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.workCatchPhrase,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.title,
                  hint: '',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        //Overview or Description
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.overview,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.overview,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        //Content or Access
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.content,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.content,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
      ],
    );
  }

  buildChooseProfile() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(JapaneseText.profileCom),
        AppSize.spaceHeight5,
        InkWell(
          onTap: () async {
            await CompanyApiServices().uploadImageToFirebase(provider);
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColor.darkBlueColor),
              ),
              alignment: Alignment.center,
              child: provider.imageUrl.isEmpty
                  ? Text(
                      "ここにファイルをアップロード",
                      style: normalTextStyle,
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Image.network(
                            provider.imageUrl,
                            fit: BoxFit.cover,
                            width: 230,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                provider.onChangeImageUrl("");
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              )),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        AppSize.spaceHeight8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(JapaneseText.recruitmentStart, style: normalTextStyle),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.startRecruitDate,
                    hint: '',
                    isRequired: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          locale: const Locale("ja", "JP"),
                          context: context,
                          initialDate: provider.startRecruitDate.text.isNotEmpty ? DateTime.parse(provider.startRecruitDate.text) : now,
                          firstDate: now,
                          lastDate: DateTime.now().add(const Duration(days: 3000)));
                      if (date != null) {
                        provider.startRecruitDate.text = MyDateTimeUtils.convertDateToString(date);
                      }
                    },
                  ),
                ],
              ),
            ),
            AppSize.spaceWidth16,
            const Padding(padding: EdgeInsets.only(top: 35), child: Text("~")),
            AppSize.spaceWidth16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    JapaneseText.end,
                    style: normalTextStyle,
                  ),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.endRecruitDate,
                    hint: '',
                    isRequired: true,
                    onTap: () async {
                      var date = await showDatePicker(
                          locale: const Locale("ja", "JP"),
                          context: context,
                          initialDate: provider.endRecruitDate.text.isNotEmpty ? DateTime.parse(provider.endRecruitDate.text) : now,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 3000)));
                      if (date != null) {
                        provider.endRecruitDate.text = MyDateTimeUtils.convertDateToString(date);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(JapaneseText.location, style: normalTextStyle),
            AppSize.spaceHeight5,
            PrimaryTextField(
              controller: provider.companyLocation,
              hint: '',
              isRequired: true,
            ),
          ],
        ),
        AppSize.spaceHeight8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.companyLatLng, style: normalTextStyle),
                AppSize.spaceHeight5,
                SizedBox(
                  width: 200,
                  child: PrimaryTextField(
                    controller: provider.companyLocationLatLng,
                    hint: '',
                    isRequired: true,
                  ),
                ),
              ],
            ),
            AppSize.spaceWidth32,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.numberOfPeopleRecruiting, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: PrimaryTextField(
                        controller: provider.numberOfRecruitPeople,
                        hint: '',
                        isRequired: true,
                        isPhoneNumber: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 15),
                      child: Text("人", style: normalTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    ));
  }

  buildOccupation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.occupation,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.specifiedSkill,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.chooseOccupationSkill,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOccupationSkill(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 160,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.otherThanSpecifiedSkills,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.chooseOccupationSkill,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOccupationSkill(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.occupation,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            CustomDropDownWidget(
              list: provider.occupationList.map((e) => e.toString()).toList(),
              onChange: (e) => provider.onChangeOccupation(e),
              width: AppSize.getDeviceWidth(context) * 0.3,
              selectItem: provider.selectedOccupation,
            )
          ],
        ),
      ],
    );
  }

  buildEmploymentContractProvisioning() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.employmentContract,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: JapaneseText.yes,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.contractProvisioning,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeContractProvisioning(JapaneseText.yes)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: JapaneseText.no,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.contractProvisioning,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeContractProvisioning(JapaneseText.no)),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          width: 90,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.employmentStatus,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            CustomDropDownWidget(
              list: provider.employmentType.map((e) => e.toString()).toList(),
              onChange: (e) => provider.onChangeEmploymentType(e),
              width: AppSize.getDeviceWidth(context) * 0.3,
              selectItem: provider.selectedEmploymentType,
            )
          ],
        ),
      ],
    );
  }

  buildTrailPeriod() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.trailPeriod,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.trailPeriod,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTrailPeriod(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.trailPeriod,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTrailPeriod(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.salaryFrom,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: JapaneseText.monthlySalary,
                      title: Text(
                        JapaneseText.monthlySalary,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.salaryType,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeSalaryType(JapaneseText.monthlySalary)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 100,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: JapaneseText.hourlyWage,
                      title: Text(
                        JapaneseText.hourlyWage,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.salaryType,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeSalaryType(JapaneseText.hourlyWage)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(JapaneseText.startWorkingHourPerDay, style: normalTextStyle),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.startWorkTime,
                    hint: '',
                    isRequired: true,
                    onTap: () async {
                      var date = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          cancelText: JapaneseText.cancel,
                          confirmText: JapaneseText.saveChange,
                          context: context,
                          initialTime: provider.startTime != null
                              ? TimeOfDay(hour: provider.startTime!.hour, minute: provider.startTime!.minute)
                              : TimeOfDay(hour: now.hour, minute: now.minute));
                      if (date != null) {
                        provider.startWorkTime.text = dateTimeToHourAndMinute(DateTime(2023, 1, 1, date.hour, date.minute));
                        provider.onChangeStartWorkTime(DateTime(2023, 1, 1, date.hour, date.minute));
                      }
                    },
                  ),
                ],
              ),
            ),
            AppSize.spaceWidth16,
            const Padding(padding: EdgeInsets.only(top: 35), child: Text("~")),
            AppSize.spaceWidth16,
            SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(JapaneseText.end, style: normalTextStyle),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.endWorkTime,
                    hint: '',
                    isRequired: true,
                    onTap: () async {
                      var date = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          cancelText: JapaneseText.cancel,
                          confirmText: JapaneseText.saveChange,
                          context: context,
                          initialTime: provider.endTime != null
                              ? TimeOfDay(hour: provider.endTime!.hour, minute: provider.endTime!.minute)
                              : TimeOfDay(hour: now.hour, minute: now.minute));
                      if (date != null) {
                        provider.endWorkTime.text = dateTimeToHourAndMinute(DateTime(2023, 1, 1, date.hour, date.minute));
                        provider.onChangeEndWorkTime(DateTime(2023, 1, 1, date.hour, date.minute));
                      }
                    },
                  ),
                ],
              ),
            ),
            AppSize.spaceWidth16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.breakTimeOfTheDay, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: PrimaryTextField(
                        controller: provider.breakTimeMinute,
                        hint: '',
                        isRequired: true,
                        isPhoneNumber: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 15),
                      child: Text("分", style: normalTextStyle),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  buildBonus() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.bonus,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.bonus,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeBonus(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.bonus,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeBonus(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.raise,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.raise,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRaise(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.raise,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRaise(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.offHours,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.offHour,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOffHour(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.offHour,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOffHour(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.paidHoliday,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.paidHoliday,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangePaidHoliday(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.paidHoliday,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangePaidHoliday(false)),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  buildNumberOfAnnualHolidayAndDetail() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            JapaneseText.numberOfHolidays,
            style: normalTextStyle,
          ),
          AppSize.spaceHeight5,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.15,
                child: PrimaryTextField(
                  controller: provider.numberOfAnnualHolidays,
                  hint: '',
                  isRequired: true,
                  isPhoneNumber: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 15),
                child: Text("⽇", style: normalTextStyle),
              ),
            ],
          ),
        ]),
        const SizedBox(
          width: 50,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            JapaneseText.holidayDetail,
            style: normalTextStyle,
          ),
          AppSize.spaceHeight5,
          SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.3,
            child: PrimaryTextField(
              controller: provider.holidayDetail,
              hint: '',
              isRequired: true,
            ),
          )
        ])
      ],
    );
  }

  buildWifiAndMore() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.dormOrCompanyHouse,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      groupValue: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.dorm,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeDorm(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      groupValue: false,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.dorm,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeDorm(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.wifiAbility,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.wifi,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeWifi(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      groupValue: false,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.wifi,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeWifi(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.mealsAbility,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.meals,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeMeals(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.meals,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeMeals(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.transportExpense,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.transportExpense,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTransportExpense(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.transportExpense,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTransportExpense(false)),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  buildOnlineInterview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.isThereRemoteInterview,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: true,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.isThereRemoteInterview,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRemoteInterview(true)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 80,
                  child: RadioListTile(
                      activeColor: AppColor.primaryColor,
                      contentPadding: EdgeInsets.zero,
                      groupValue: false,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.isThereRemoteInterview,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRemoteInterview(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth32,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.interviewLocation,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.4,
                    child: PrimaryTextField(
                      controller: provider.interviewLocation,
                      hint: "",
                      isRequired: true,
                    ))
              ],
            ),
            AppSize.spaceWidth32,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.interviewLatLng,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      controller: provider.interviewLocationLatLng,
                      hint: "",
                      isRequired: true,
                    ))
              ],
            )
          ],
        ),
      ],
    );
  }

  buildContentOfTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.contentOfTest,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Container(
          width: AppSize.getDeviceWidth(context) * 0.6,
          // height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 0.3, color: Colors.grey), borderRadius: BorderRadius.circular(16)),
          child: MultiSelectDialogField2(
            dialogWidth: 400,
            dialogHeight: 300,
            isOffice: true,
            initialValue: provider.selectedContentOfTest,
            items: provider.contentOfTestStaff.map((e) => MultiSelectItem(e, e)).toList(),
            cancelText: Text(JapaneseText.cancel),
            confirmText: Text(JapaneseText.saveChange),
            title: Text(JapaneseText.contentOfTest),
            buttonText: Text(JapaneseText.contentOfTest),
            buttonIcon: const Icon(Icons.arrow_drop_down_rounded),
            listType: MultiSelectListType.LIST,
            onConfirm: (values) {
              provider.onChangeContentOfTest(values);
            },
          ),
        ),
      ],
    );
  }

  buildSelectStatusOfRecident() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.statusOfResidence,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            Container(
              width: AppSize.getDeviceWidth(context) * 0.3,
              // height: 100,
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Colors.white, border: Border.all(width: 0.3, color: Colors.grey), borderRadius: BorderRadius.circular(16)),
              child: MultiSelectDialogField2(
                dialogWidth: 400,
                dialogHeight: 300,
                isOffice: true,
                initialValue: provider.selectedStatusOfRecident,
                items: provider.statusOfRecident.map((e) => MultiSelectItem(e, e)).toList(),
                cancelText: Text(JapaneseText.cancel),
                confirmText: Text(JapaneseText.saveChange),
                title: Text(JapaneseText.statusOfResidence),
                buttonText: Text(JapaneseText.statusOfResidence),
                buttonIcon: const Icon(Icons.arrow_drop_down_rounded),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) {
                  provider.onChangeStatusOfRecident(values);
                },
              ),
            ),
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.otherQualification,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.3,
                child: PrimaryTextField(
                  controller: provider.otherQualification,
                  hint: "",
                  isRequired: true,
                ))
          ],
        ),
      ],
    );
  }

  buildHotelCleaningItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.hotelCleanLearningItems,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Container(
          width: AppSize.getDeviceWidth(context) * 0.3,
          // height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 0.3, color: Colors.grey), borderRadius: BorderRadius.circular(16)),
          child: MultiSelectDialogField2(
            dialogWidth: 400,
            dialogHeight: 300,
            isOffice: true,
            initialValue: provider.selectedHotelCleaningItemLearn,
            items: provider.hotelCleaningItemLearn.map((e) => MultiSelectItem(e, e)).toList(),
            cancelText: Text(JapaneseText.cancel),
            confirmText: Text(JapaneseText.saveChange),
            title: Text(JapaneseText.hotelCleanLearningItems),
            buttonText: Text(JapaneseText.hotelCleanLearningItems),
            buttonIcon: const Icon(Icons.arrow_drop_down_rounded),
            listType: MultiSelectListType.LIST,
            onConfirm: (values) {
              provider.onChangeHotelCleaningItemLearn(values);
            },
          ),
        ),
      ],
    );
  }

  buildApplicationRequirementAndJapanSkill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(JapaneseText.titleOfApplicationRequirement, style: normalTextStyle),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.desiredGender,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: JapaneseText.male,
                          title: Text(
                            JapaneseText.male,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.selectedDesiredGender,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeChooseGender(JapaneseText.male)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: JapaneseText.female,
                          title: Text(
                            JapaneseText.female,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.selectedDesiredGender,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeChooseGender(JapaneseText.female)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 140,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: JapaneseText.bothGender,
                          title: Text(
                            JapaneseText.bothGender,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.selectedDesiredGender,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeChooseGender(JapaneseText.bothGender)),
                    )
                  ],
                )
              ],
            ),
            AppSize.spaceWidth32,
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                JapaneseText.desiredNationality,
                style: normalTextStyle,
              ),
              AppSize.spaceHeight5,
              CustomDropDownWidget(
                list: provider.nationalityList,
                onChange: (v) => provider.onChangeNationality(v),
                selectItem: provider.selectedNationality,
              )
            ])
          ],
        ),
        AppSize.spaceHeight16,
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            JapaneseText.necessaryJapanSkill,
            style: normalTextStyle,
          ),
          AppSize.spaceHeight5,
          CustomDropDownWidget(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            list: provider.necessaryJapanSkillList,
            onChange: (v) => provider.onChangeNecessaryJapanSkill(v),
            selectItem: provider.selectedNecessaryJapanSkill,
          )
        ]),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.remark,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.remark,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
      ],
    );
  }

  buildEmploymentCondition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(JapaneseText.socialInsurance, style: normalTextStyle),
            AppSize.spaceHeight5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: CheckboxListTile(
                      activeColor: AppColor.primaryColor,
                      value: provider.isEmployment,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(JapaneseText.employment, style: normalTextStyle),
                      dense: true,
                      onChanged: (val) => provider.onChangeEmployment(val!)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 100,
                  child: CheckboxListTile(
                      activeColor: AppColor.primaryColor,
                      value: provider.isIndustrialAccident,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(JapaneseText.workerCompensation, style: normalTextStyle),
                      dense: true,
                      onChanged: (val) => provider.onChangeIndustrialAccident(val!)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 100,
                  child: CheckboxListTile(
                      activeColor: AppColor.primaryColor,
                      value: provider.isHealth,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(JapaneseText.health, style: normalTextStyle),
                      dense: true,
                      onChanged: (val) => provider.onChangeHealth(val!)),
                ),
                AppSize.spaceWidth16,
                SizedBox(
                  width: 100,
                  child: CheckboxListTile(
                      activeColor: AppColor.primaryColor,
                      value: provider.isWelfare,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(JapaneseText.welfare, style: normalTextStyle),
                      dense: true,
                      onChanged: (val) => provider.onChangeWelfare(val!)),
                ),
              ],
            )
          ],
        ),
        AppSize.spaceHeight16,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.childCareLeaveSystem, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: true,
                          title: Text(
                            JapaneseText.yes,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isChildCareSystem,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeChildCare(true)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: false,
                          title: Text(
                            JapaneseText.no,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isChildCareSystem,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeChildCare(false)),
                    )
                  ],
                )
              ],
            ),
            AppSize.spaceWidth32,
            AppSize.spaceWidth16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.retirementSystem, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: true,
                          title: Text(
                            JapaneseText.yes,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isRetirementSystem,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeRetirement(true)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: false,
                          title: Text(
                            JapaneseText.no,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isRetirementSystem,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeRetirement(false)),
                    )
                  ],
                )
              ],
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
                Text(JapaneseText.rehire, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: true,
                          title: Text(
                            JapaneseText.yes,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isReemployment,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeReemployment(true)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: false,
                          title: Text(
                            JapaneseText.no,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isReemployment,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeReemployment(false)),
                    )
                  ],
                )
              ],
            ),
            AppSize.spaceWidth32,
            AppSize.spaceWidth16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.severancePay, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: true,
                          title: Text(
                            JapaneseText.yes,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isRetirementBenefits,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeRetirementBenefits(true)),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 80,
                      child: RadioListTile(
                          activeColor: AppColor.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: false,
                          title: Text(
                            JapaneseText.no,
                            style: normalTextStyle.copyWith(fontSize: 12),
                          ),
                          value: provider.isRetirementBenefits,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) => provider.onChangeRetirementBenefits(false)),
                    )
                  ],
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  clearAllText() {}

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
            JapaneseText.applicantSearch + " (Foreigner)",
            style: titleStyle,
          ),
          IconButton(splashRadius: 30, onPressed: () => context.pop(), icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
