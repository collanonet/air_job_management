import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job_for_japanese.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_choose_date_or_time.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/register/widget/radio_list_tile.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_textfield.dart';

class JobPostingShiftPageForCompany extends StatefulWidget {
  const JobPostingShiftPageForCompany({super.key});

  @override
  State<JobPostingShiftPageForCompany> createState() => _JobPostingShiftPageForCompanyState();
}

class _JobPostingShiftPageForCompanyState extends State<JobPostingShiftPageForCompany> {
  ScrollController scrollController2 = ScrollController();
  late JobPostingForCompanyProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController2,
            child: SingleChildScrollView(
              controller: scrollController2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.spaceHeight30,
                  TitleWidget(title: JapaneseText.applicationRequirement),
                  AppSize.spaceHeight16,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomChooseDateOrTimeWidget(
                        width: 200,
                        title: JapaneseText.startWorkingDay,
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context, initialDate: provider.startWorkDate, firstDate: provider.currentDate, lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              provider.startWorkDate = date;
                              if (provider.startWorkDate.isAfter(provider.endWorkDate)) {
                                provider.endWorkDate = date;
                              }
                            });
                          }
                        },
                        val: toJapanDateWithoutWeekDay(provider.startWorkDate),
                        isHaveIcon: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      CustomChooseDateOrTimeWidget(
                        width: 200,
                        title: JapaneseText.endWorkingDay,
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context, initialDate: provider.endWorkDate, firstDate: provider.startWorkDate, lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              provider.endWorkDate = date;
                            });
                          }
                        },
                        val: toJapanDateWithoutWeekDay(provider.endWorkDate),
                        isHaveIcon: true,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomChooseDateOrTimeWidget(
                        title: JapaneseText.startWorkingTime,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: provider.startWorkingTime.hour, minute: provider.startWorkingTime.minute));
                          if (time != null) {
                            setState(() {
                              provider.startWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                            });
                          }
                        },
                        val: dateTimeToHourAndMinute(provider.startWorkingTime),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      CustomChooseDateOrTimeWidget(
                        title: JapaneseText.endWorkingTime,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay(hour: provider.endWorkingTime.hour, minute: provider.endWorkingTime.minute));
                          if (time != null) {
                            setState(() {
                              provider.endWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                            });
                          }
                        },
                        val: dateTimeToHourAndMinute(provider.endWorkingTime),
                      ),
                      AppSize.spaceWidth32,
                      CustomChooseDateOrTimeWidget(
                        title: JapaneseText.startBreakTime,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay(hour: provider.startBreakTime.hour, minute: provider.startBreakTime.minute));
                          if (time != null) {
                            setState(() {
                              provider.startBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                            });
                          }
                        },
                        val: dateTimeToHourAndMinute(provider.startBreakTime),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      CustomChooseDateOrTimeWidget(
                        title: JapaneseText.endBreakTime,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay(hour: provider.endBreakTime.hour, minute: provider.endBreakTime.minute));
                          if (time != null) {
                            setState(() {
                              provider.endBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                            });
                          }
                        },
                        val: dateTimeToHourAndMinute(provider.endBreakTime),
                      ),
                    ],
                  ),
                  Text(
                    JapaneseText.numberOfPeopleRecruiting,
                    style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                  ),
                  AppSize.spaceHeight5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: PrimaryTextField(
                          hint: "20",
                          controller: provider.numberOfRecruitPeople,
                          isRequired: true,
                          isPhoneNumber: true,
                        ),
                      ),
                      AppSize.spaceWidth5,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("人", style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16)),
                      )
                    ],
                  ),
                  Text(
                    JapaneseText.recruitmentDeadlineTime,
                    style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                    radius: 5,
                    selectItem: provider.selectedDeadline,
                    list: provider.applicationDeadlineList,
                    onChange: (v) => provider.onChangeSelectDeadline(v),
                    width: 300,
                  ),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.publicSetting, style: kNormalText.copyWith(fontSize: 12))),
                  AppSize.spaceHeight5,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: RadioListTileWidget(
                            title: JapaneseText.openToPublic,
                            onChange: (v) => provider.onChangeSelectPublicSetting(JapaneseText.openToPublic),
                            size: 120,
                            val: provider.selectedPublicSetting),
                      ),
                      AppSize.spaceWidth32,
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: RadioListTileWidget(
                            title: JapaneseText.groupLimitRelease,
                            onChange: (v) => provider.onChangeSelectPublicSetting(JapaneseText.groupLimitRelease),
                            size: 180,
                            val: provider.selectedPublicSetting),
                      ),
                      AppSize.spaceWidth32,
                      RadioListTileWidget(
                          title: JapaneseText.urlLimited,
                          subTitle: JapaneseText.subUrlLimited,
                          onChange: (v) => provider.onChangeSelectPublicSetting(JapaneseText.urlLimited),
                          size: 600,
                          val: provider.selectedPublicSetting),
                    ],
                  ),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            JapaneseText.hourlyWage,
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                          ),
                          AppSize.spaceHeight5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: PrimaryTextField(
                                  hint: "",
                                  controller: provider.hourlyWag,
                                  isRequired: true,
                                ),
                              ),
                              AppSize.spaceWidth5,
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text("円", style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16)),
                              )
                            ],
                          ),
                        ],
                      ),
                      AppSize.spaceWidth32,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            JapaneseText.transportExpense,
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                          ),
                          AppSize.spaceHeight5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: PrimaryTextField(
                                  hint: "",
                                  controller: provider.transportExp,
                                  isRequired: true,
                                ),
                              ),
                              AppSize.spaceWidth5,
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text("円", style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16)),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            JapaneseText.emergencyContact,
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                          ),
                          AppSize.spaceHeight5,
                          SizedBox(
                            width: 300,
                            child: PrimaryTextField(
                              hint: "",
                              controller: provider.emergencyContact,
                              isRequired: true,
                              isPhoneNumber: true,
                            ),
                          ),
                        ],
                      ),
                      AppSize.spaceWidth32,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            JapaneseText.measuresToPreventPassiveSmoking,
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 12),
                          ),
                          AppSize.spaceHeight5,
                          CustomDropDownWidget(
                            radius: 5,
                            selectItem: provider.selectSmokingInDoor,
                            list: provider.allowSmokingInDoor,
                            onChange: (v) => provider.onChangeAllowSmokingInDoor(v),
                            width: 300,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 20),
                        child: checkBoxTile(
                            size: 300,
                            title: JapaneseText.workInAreasWhereSmokingIsAllowed,
                            val: provider.isAllowSmokingInArea,
                            onChange: (v) => provider.onChangeAllowSmokingInArea(v)),
                      )
                    ],
                  ),
                  AppSize.spaceHeight50
                ],
              ),
            )),
      ),
    );
  }
}
