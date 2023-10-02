import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/company.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
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

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      DateTime start = DateTime.parse(provider.startRecruitDate.text);
      DateTime end = DateTime.parse(provider.endRecruitDate.text);
      if (end.isBefore(start)) {
        // End date is before start date validation
        toastMessageError("募集終了日が募集開始日より前です", context);
      } else {
        //Continue to create job posting
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
      child: Scaffold(
        body: CustomLoadingOverlay(
          isLoading: provider.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        AppSize.spaceHeight50,
                        SizedBox(
                          width: AppSize.getDeviceWidth(context) * 0.1,
                          child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                      "Upload File Here",
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
                        provider.startRecruitDate.text = DateFormat('yyyy-MM-dd').format(date);
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
                        provider.endRecruitDate.text = DateFormat('yyyy-MM-dd').format(date);
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(JapaneseText.location, style: normalTextStyle),
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
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.specifiedSkill,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.chooseOccupationSkill,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOccupationSkill(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 160,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.otherThanSpecifiedSkills,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.chooseOccupationSkill,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.contractProvisioning == JapaneseText.yes,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeContractProvisioning(JapaneseText.yes)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.contractProvisioning != JapaneseText.yes,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.trailPeriod,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTrailPeriod(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.trailPeriod,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeTrailPeriod(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth16,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.monthlySalary,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.salaryType == JapaneseText.monthlySalary,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeSalaryType(JapaneseText.monthlySalary)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.hourlyWage,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.salaryType != JapaneseText.monthlySalary,
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
              width: AppSize.getDeviceWidth(context) * 0.2,
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
              width: AppSize.getDeviceWidth(context) * 0.2,
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
                      width: 100,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.bonus,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeBonus(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.bonus,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeBonus(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth16,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.raise,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRaise(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.raise,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeRaise(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth16,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.offHour,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOffHour(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.offHour,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangeOffHour(false)),
                )
              ],
            )
          ],
        ),
        AppSize.spaceWidth16,
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
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.yes,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: provider.paidHoliday,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => provider.onChangePaidHoliday(true)),
                ),
                AppSize.spaceWidth5,
                SizedBox(
                  width: 120,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        JapaneseText.no,
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      value: !provider.paidHoliday,
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

  clearAllText() {}

  titleWidget() {
    return Material(
      child: Container(
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
            IconButton(splashRadius: 30, onPressed: () => context.pop(), icon: const Icon(Icons.close))
          ],
        ),
      ),
    );
  }
}
