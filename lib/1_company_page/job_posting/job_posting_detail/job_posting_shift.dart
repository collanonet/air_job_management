import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job_for_japanese.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_choose_date_or_time.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/date_to_api.dart';
import '../../../pages/register/widget/radio_list_tile.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class JobPostingShiftPageForCompany extends StatefulWidget {
  final bool? isFromCopyShift;
  final bool isView;
  const JobPostingShiftPageForCompany({super.key, this.isFromCopyShift = false, this.isView = false});

  @override
  State<JobPostingShiftPageForCompany> createState() => _JobPostingShiftPageForCompanyState();
}

class _JobPostingShiftPageForCompanyState extends State<JobPostingShiftPageForCompany> {
  ScrollController scrollController2 = ScrollController();
  late JobPostingForCompanyProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    if (widget.isFromCopyShift == true) {
      return Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController2,
            child: SingleChildScrollView(
              controller: scrollController2,
              primary: false,
              child: AbsorbPointer(
                absorbing: !widget.isView,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSize.spaceHeight16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleWidget(title: JapaneseText.applicationRequirement),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                      ],
                    ),
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
                                context: context, initialDate: provider.startWorkDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
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
                      JapaneseText.numberOfPeopleRecruiting + " (半角文字)",
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
                    if (widget.isFromCopyShift == true)
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => updateShiftFrameJob()),
                        ),
                      )
                    else
                      const SizedBox(),
                    AppSize.spaceHeight50,
                  ],
                ),
              ),
            )),
      );
    } else {
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
                primary: false,
                child: AbsorbPointer(
                  absorbing: widget.isView,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSize.spaceHeight16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [TitleWidget(title: JapaneseText.applicationRequirement), SizedBox()],
                      ),
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
                                  context: context, initialDate: provider.startWorkDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
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
                                  context: context,
                                  initialTime: TimeOfDay(hour: provider.endWorkingTime.hour, minute: provider.endWorkingTime.minute));
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
                                  context: context,
                                  initialTime: TimeOfDay(hour: provider.startBreakTime.hour, minute: provider.startBreakTime.minute));
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
                        JapaneseText.numberOfPeopleRecruiting + " (半角文字)",
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
                      if (widget.isFromCopyShift == true)
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => updateShiftFrameJob()),
                          ),
                        )
                      else
                        const SizedBox(),
                      AppSize.spaceHeight50,
                    ],
                  ),
                ),
              )),
        ),
      );
    }
  }

  updateShiftFrameJob() async {
    provider.jobPosting?.motorCycleCarCommutingPossible = provider.motorCycleCarCommutingPossible;
    provider.jobPosting?.bicycleCommutingPossible = provider.bicycleCommutingPossible;
    provider.jobPosting?.selectedPublicSetting = provider.selectedPublicSetting;
    provider.jobPosting?.occupationType = provider.selectedOccupationType;
    provider.jobPosting?.majorOccupation = provider.selectedSpecificOccupation;
    provider.jobPosting?.jobLocation = provider.selectedLocation;
    provider.jobPosting?.startTimeHour = dateTimeToHourAndMinute(provider.startWorkingTime);
    provider.jobPosting?.endTimeHour = dateTimeToHourAndMinute(provider.endWorkingTime);
    provider.jobPosting?.startBreakTimeHour = dateTimeToHourAndMinute(provider.startBreakTime);
    provider.jobPosting?.endBreakTimeHour = dateTimeToHourAndMinute(provider.endBreakTime);
    provider.jobPosting?.startDate = DateToAPIHelper.convertDateToString(provider.startWorkDate);
    provider.jobPosting?.endDate = DateToAPIHelper.convertDateToString(provider.endWorkDate);
    provider.jobPosting!.shiftFrameList!.add(ShiftFrame(
        startDate: DateToAPIHelper.convertDateToString(provider.startWorkDate),
        recruitmentNumberPeople: provider.numberOfRecruitPeople.text,
        expiredTime: null,
        endDate: DateToAPIHelper.convertDateToString(provider.endWorkDate),
        endBreakTime: dateTimeToHourAndMinute(provider.endBreakTime),
        endWorkTime: dateTimeToHourAndMinute(provider.endWorkingTime),
        startBreakTime: dateTimeToHourAndMinute(provider.startBreakTime),
        startWorkTime: dateTimeToHourAndMinute(provider.startWorkingTime),
        applicationDateline: provider.selectedDeadline,
        bicycleCommutingPossible: provider.bicycleCommutingPossible,
        emergencyContact: provider.emergencyContact.text,
        hourlyWag: provider.hourlyWag.text,
        motorCycleCarCommutingPossible: provider.motorCycleCarCommutingPossible,
        selectedPublicSetting: provider.selectedPublicSetting,
        transportExpenseFee: provider.transportExp.text));
    String? isSuccess = await JobPostingApiService().updateJobPostingInfo(provider.jobPosting!);
    if (isSuccess == ConstValue.success) {
      MessageWidget.show(JapaneseText.successCreate);
      Navigator.pop(context, provider.jobPosting!.shiftFrameList);
    } else {
      MessageWidget.show(JapaneseText.failCreate);
    }
  }
}
