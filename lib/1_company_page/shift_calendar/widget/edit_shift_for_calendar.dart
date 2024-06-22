import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/japan_date_time.dart';
import '../../../pages/job_posting/create_or_edit_job_for_japanese.dart';
import '../../../pages/register/widget/radio_list_tile.dart';
import '../../../providers/company/job_posting.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/style.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_choose_date_or_time.dart';
import '../../../widgets/custom_dropdown_string.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/title.dart';
import '../../job_posting/job_posting_detail/job_posting_shift.dart';

class EditShiftForCalendarPage extends StatefulWidget {
  final String title;
  final Function onUpdate;
  const EditShiftForCalendarPage({super.key, required this.onUpdate, required this.title});

  @override
  State<EditShiftForCalendarPage> createState() => _EditShiftForCalendarPageState();
}

class _EditShiftForCalendarPageState extends State<EditShiftForCalendarPage> {
  late JobPostingForCompanyProvider provider;

  List<String> date = ["月", "火", "水", "木", "金", "土", "日"];
  List<String> selectedDate = ["月", "火", "水", "木", "金", "土", "日"];

  @override
  void initState() {
    if (Provider.of<JobPostingForCompanyProvider>(context, listen: false).jobPosting!.selectedDate!.isNotEmpty) {
      selectedDate = Provider.of<JobPostingForCompanyProvider>(context, listen: false).jobPosting?.selectedDate ?? [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecorationNoTopRadius,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.jobPosting?.title ?? "",
            style: kTitleText.copyWith(color: AppColor.primaryColor),
          ),
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
                title: JapaneseText.postedStartDay,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context, initialDate: provider.startPostDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      provider.startPostDate = date;
                      if (provider.startPostDate.isAfter(provider.endPostDate)) {
                        provider.endPostDate = date;
                      }
                    });
                  }
                },
                val: toJapanDateWithoutWeekDay(provider.startPostDate),
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
                title: JapaneseText.postedEndDay,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context, initialDate: provider.endPostDate, firstDate: provider.startPostDate, lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      provider.endPostDate = date;
                    });
                  }
                },
                val: toJapanDateWithoutWeekDay(provider.endPostDate),
                isHaveIcon: true,
              ),
            ],
          ),
          AppSize.spaceHeight16,
          Divider(
            color: AppColor.thirdColor.withOpacity(0.3),
          ),
          AppSize.spaceHeight16,
          if (widget.title == "日付を選んでシフト枠作成")
            Row(
              children: [
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
                AppSize.spaceWidth16,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "選択された日付",
                      style: kNormalText,
                    ),
                    Text(
                      "${CommonUtils.getDateRange(provider.startWorkDate, provider.endWorkDate).map((e) => "${e.month}/${e.day}").toString().replaceAll(")", "")},${provider.endWorkDate.month}/${provider.endWorkDate.day})",
                      style: kNormalText,
                    )
                  ],
                ))
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                      itemCount: date.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String item = date[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedDate.contains(item)) {
                                selectedDate[index] = "";
                              } else {
                                selectedDate[index] = item;
                              }
                            });
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1, color: AppColor.primaryColor),
                                color: selectedDate.contains(item) ? AppColor.primaryColor : AppColor.primaryColor.withOpacity(0.2)),
                            child: Center(
                              child: Text(
                                item,
                                style: kNormalText.copyWith(
                                    color: selectedDate.contains(item) ? AppColor.whiteColor : AppColor.primaryColor, fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                AppSize.spaceWidth32,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomChooseDateOrTimeWidget(
                      width: 200,
                      title: "シフト枠期間（開始）",
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
                      title: "シフト枠期間（終了）",
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
              ],
            ),
          AppSize.spaceHeight20,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomChooseDateOrTimeWidget(
                title: JapaneseText.startWorkingTime,
                onTap: () async {
                  var time = await showTimePicker(
                      context: context, initialTime: TimeOfDay(hour: provider.startWorkingTime.hour, minute: provider.startWorkingTime.minute));
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
                    title: JapaneseText.privatePost,
                    onChange: (v) => provider.onChangeSelectPublicSetting(JapaneseText.privatePost),
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
          AppSize.spaceHeight5,
          Visibility(
            visible: provider.selectedPublicSetting == JapaneseText.groupLimitRelease,
            child: CustomChipTags(
              list: initialTags,
              chipColor: AppColor.primaryColor,
              iconColor: Colors.white,
              textColor: Colors.white,
              decoration: InputDecoration(hintText: "求職者のメールアドレスを入力してください。", fillColor: AppColor.primaryColor),
              keyboardType: TextInputType.text,
            ),
          ),
          Visibility(
            visible: provider.selectedPublicSetting == JapaneseText.urlLimited,
            child: Row(
              children: [
                //Job need to be create first before can send link to other
                SelectionArea(
                  child: Text(
                    provider.jobPosting?.uid == null
                        ? "他の求職者にリンクを送信する前に、まず求人を作成する必要があります。"
                        : "https://air-job.web.app/job-posting/${provider.jobPosting?.uid}",
                    style: kNormalText.copyWith(fontSize: 15, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                AppSize.spaceWidth16,
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey,
                ),
                AppSize.spaceWidth16,
                InkWell(
                  child: Text(
                    "コピー",
                    style: kNormalText.copyWith(fontSize: 15, color: Colors.blue),
                  ),
                  onTap: () {
                    FlutterClipboard.copy("https://air-job.web.app/job-posting/${provider.jobPosting?.uid}");
                    toastMessageSuccess("リンクのコピー成功", context);
                  },
                )
              ],
            ),
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
          AppSize.spaceHeight20,
          Center(
            child: ButtonWidget(
              title: "シフト枠を作成する",
              onPress: () => widget.onUpdate(selectedDate),
              color: AppColor.primaryColor,
              radius: 25,
            ),
          ),
          AppSize.spaceHeight50,
        ],
      ),
    );
  }
}
