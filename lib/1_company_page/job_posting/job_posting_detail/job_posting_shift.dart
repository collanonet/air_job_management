import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job_for_japanese.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_choose_date_or_time.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:air_job_management/widgets/date_input.dart';
import 'package:air_job_management/widgets/time_input.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../helper/date_to_api.dart';
import '../../../pages/register/widget/radio_list_tile.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_textfield.dart';

List<String> initialTags = [];

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
    final start = provider.startWorkDate;              // 既存の開始日
    final end   = provider.endWorkDate;                // 既存の終了日（現在値）
    final last  = DateTime(2100, 12, 31);
    if (widget.isFromCopyShift == true) {
      return Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController2,
            child: SingleChildScrollView(
              controller: scrollController2,
              primary: false,
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
                       SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.postedStartDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.startPostDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startPostDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startPostDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                      // CustomChooseDateOrTimeWidget(
                      //   width: 200,
                      //   title: JapaneseText.postedStartDay,
                      //   onTap: () async {
                      //     var date = await showDatePicker(
                      //         context: context, initialDate: provider.startPostDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
                      //     if (date != null) {
                      //       setState(() {
                      //         provider.startPostDate = date;
                      //         if (provider.startPostDate.isAfter(provider.endPostDate)) {
                      //           provider.endPostDate = date;
                      //         }
                      //       });
                      //     }
                      //   },
                      //   val: toJapanDateWithoutWeekDay(provider.startPostDate),
                      //   isHaveIcon: true,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.postedEndDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.endPostDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endPostDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endPostDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                      // CustomChooseDateOrTimeWidget(
                      //   width: 200,
                      //   title: JapaneseText.postedEndDay,
                      //   onTap: () async {
                      //     var date = await showDatePicker(
                      //         context: context, initialDate: provider.endPostDate, firstDate: provider.startPostDate, lastDate: DateTime(2100));
                      //     if (date != null) {
                      //       setState(() {
                      //         provider.endPostDate = date;
                      //       });
                      //     }
                      //   },
                      //   val: toJapanDateWithoutWeekDay(provider.endPostDate),
                      //   isHaveIcon: true,
                      // ),
                    ],
                  ),
                  AppSize.spaceHeight16,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight16,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.startWorkingDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.startWorkDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startWorkDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startWorkDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                      // CustomChooseDateOrTimeWidget(
                      //   width: 200,
                      //   title: JapaneseText.startWorkingDay,
                      //   onTap: () async {
                      //     var date = await showDatePicker(
                      //         context: context, initialDate: provider.startWorkDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
                      //     if (date != null) {
                      //       setState(() {
                      //         provider.startWorkDate = date;
                      //         if (provider.startWorkDate.isAfter(provider.endWorkDate)) {
                      //           provider.endWorkDate = date;
                      //         }
                      //       });
                      //     }
                      //   },
                      //   val: toJapanDateWithoutWeekDay(provider.startWorkDate),
                      //   isHaveIcon: true,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                     SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.endWorkingDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.endWorkDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endWorkDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endWorkDate = dt;
                              });
                            }
                          },
                        ),
                      ),


                      // CustomChooseDateOrTimeWidget(
                      //   width: 200,
                      //   title: JapaneseText.endWorkingDay,
                      //   onTap: () async {
                      //     var date = await showDatePicker(
                      //         context: context, initialDate: provider.endWorkDate, firstDate: provider.startWorkDate, lastDate: DateTime(2100));
                      //     if (date != null) {
                      //       setState(() {
                      //         provider.endWorkDate = date;
                      //       });
                      //     }
                      //   },
                      //   val: toJapanDateWithoutWeekDay(provider.endWorkDate),
                      //   isHaveIcon: true,
                      // ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.startWorkingTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.startWorkingTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.startWorkingTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                      // CustomChooseDateOrTimeWidget(
                      //   title: JapaneseText.startWorkingTime,
                      //   onTap: () async {
                      //     var time = await showTimePicker(
                      //         context: context,
                      //         initialTime: TimeOfDay(hour: provider.startWorkingTime.hour, minute: provider.startWorkingTime.minute));
                      //     if (time != null) {
                      //       setState(() {
                      //         provider.startWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                      //       });
                      //     }
                      //   },
                      //   val: dateTimeToHourAndMinute(provider.startWorkingTime),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.endWorkingTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.endWorkingTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.endWorkingTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                      // CustomChooseDateOrTimeWidget(
                      //   title: JapaneseText.endWorkingTime,
                      //   onTap: () async {
                      //     var time = await showTimePicker(
                      //         context: context, initialTime: TimeOfDay(hour: provider.endWorkingTime.hour, minute: provider.endWorkingTime.minute));
                      //     if (time != null) {
                      //       setState(() {
                      //         provider.endWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                      //       });
                      //     }
                      //   },
                      //   val: dateTimeToHourAndMinute(provider.endWorkingTime),
                      // ),
                      AppSize.spaceWidth32,
                      SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.startBreakTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.startBreakTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.startBreakTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                      // CustomChooseDateOrTimeWidget(
                      //   title: JapaneseText.startBreakTime,
                      //   onTap: () async {
                      //     var time = await showTimePicker(
                      //         context: context, initialTime: TimeOfDay(hour: provider.startBreakTime.hour, minute: provider.startBreakTime.minute));
                      //     if (time != null) {
                      //       setState(() {
                      //         provider.startBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                      //       });
                      //     }
                      //   },
                      //   val: dateTimeToHourAndMinute(provider.startBreakTime),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Text(
                          " 〜 ",
                          style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                        ),
                      ),
                      SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.endBreakTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.endBreakTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.endBreakTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                      // CustomChooseDateOrTimeWidget(
                      //   title: JapaneseText.endBreakTime,
                      //   onTap: () async {
                      //     var time = await showTimePicker(
                      //         context: context, initialTime: TimeOfDay(hour: provider.endBreakTime.hour, minute: provider.endBreakTime.minute));
                      //     if (time != null) {
                      //       setState(() {
                      //         provider.endBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                      //       });
                      //     }
                      //   },
                      //   val: dateTimeToHourAndMinute(provider.endBreakTime),
                      // ),
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
                          CustomDropDownWidget(
                            radius: 5,
                            selectItem: provider.selectedTFOptions,
                            list: provider.transportationFeeOptions,
                            onChange: (v) => provider.onChangeTFOptions(v),
                            width: 300,
                          ),
                          AppSize.spaceHeight5,
                        ],
                      ),
                      AppSize.spaceWidth32,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "交通費（1日につき）",
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
            )),
      );
    } else {
      return Expanded(
        child: Container(
          width: AppSize.getDeviceWidth(context),
          decoration: boxDecorationNoTopRadius,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Scrollbar(
              thumbVisibility: true,
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
                           SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.postedStartDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.startPostDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startPostDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startPostDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                          // CustomChooseDateOrTimeWidget(
                          //   width: 200,
                          //   title: JapaneseText.postedStartDay,
                          //   onTap: () async {
                          //     var date = await showDatePicker(
                          //         context: context, initialDate: provider.startPostDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
                          //     if (date != null) {
                          //       setState(() {
                          //         provider.startPostDate = date;
                          //         if (provider.startPostDate.isAfter(provider.endPostDate)) {
                          //           provider.endPostDate = date;
                          //         }
                          //       });
                          //     }
                          //   },
                          //   val: toJapanDateWithoutWeekDay(provider.startPostDate),
                          //   isHaveIcon: true,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              " 〜 ",
                              style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                            ),
                          ),
                           SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.postedEndDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.endPostDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endPostDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.endPostDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                          // CustomChooseDateOrTimeWidget(
                          //   width: 200,
                          //   title: JapaneseText.postedEndDay,
                          //   onTap: () async {
                          //     var date = await showDatePicker(
                          //         context: context, initialDate: provider.endPostDate, firstDate: provider.startPostDate, lastDate: DateTime(2100));
                          //     if (date != null) {
                          //       setState(() {
                          //         provider.endPostDate = date;
                          //       });
                          //     }
                          //   },
                          //   val: toJapanDateWithoutWeekDay(provider.endPostDate),
                          //   isHaveIcon: true,
                          // ),
                        ],
                      ),
                      AppSize.spaceHeight16,
                      Divider(
                        color: AppColor.thirdColor.withOpacity(0.3),
                      ),
                      AppSize.spaceHeight16,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            SizedBox(
                        width: 200,
                        child: DatePickerField(
                          label: JapaneseText.startWorkingDay,
                          helperText: 'YYYY/MM/DD',
                          firstDate: DateTime.now(),          
                          lastDate: DateTime(2100, 12, 31),               
                          initialDate: provider.startWorkDate,              
                          onChanged: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startWorkDate = dt;
                              });
                            }
                          },
                          onSubmitted: (dt) {
                            if (dt != null) {
                              setState(() {
                                provider.startWorkDate = dt;
                              });
                            }
                          },
                        ),
                      ),
                          // CustomChooseDateOrTimeWidget(
                          //   width: 200,
                          //   title: JapaneseText.startWorkingDay,
                          //   onTap: () async {
                          //     var date = await showDatePicker(
                          //         context: context, initialDate: provider.startWorkDate, firstDate: DateTime(2023, 1, 1), lastDate: DateTime(2100));
                          //     if (date != null) {
                          //       setState(() {
                          //         provider.startWorkDate = date;
                          //         if (provider.startWorkDate.isAfter(provider.endWorkDate)) {
                          //           provider.endWorkDate = date;
                          //         }
                          //       });
                          //     }
                          //   },
                          //   val: toJapanDateWithoutWeekDay(provider.startWorkDate),
                          //   isHaveIcon: true,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              " 〜 ",
                              style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                            ),
                          ),
                         SizedBox(
                            width: 200,
                            child: DatePickerField(
                              label: JapaneseText.endWorkingDay,
                              helperText: 'YYYY/MM/DD',
                              firstDate: DateTime.now(),              // 入力の下限
                              lastDate: DateTime(2100, 12, 31),               // 入力の上限
                              initialDate: provider.endWorkDate,              // 初期表示
                              onChanged: (dt) {
                                if (dt != null) {
                                  setState(() {
                                    provider.endWorkDate = dt;
                                  });
                                }
                              },
                              onSubmitted: (dt) {
                                if (dt != null) {
                                  setState(() {
                                    provider.endWorkDate = dt;
                                  });
                                }
                              },
                            ),
                          ),

                         
                          // CustomChooseDateOrTimeWidget(
                          //   width: 200,
                          //   title: JapaneseText.endWorkingDay,
                          //   onTap: () async {
                          //     var date = await showDatePicker(
                          //         context: context, initialDate: provider.endWorkDate, firstDate: provider.startWorkDate, lastDate: DateTime(2100));
                          //     if (date != null) {
                          //       setState(() {
                          //         provider.endWorkDate = date;
                          //       });
                          //     }
                          //   },
                          //   val: toJapanDateWithoutWeekDay(provider.endWorkDate),
                          //   isHaveIcon: true,
                          // ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                             SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.startWorkingTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.startWorkingTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.startWorkingTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                          // CustomChooseDateOrTimeWidget(
                          //   title: JapaneseText.startWorkingTime,
                          //   onTap: () async {
                          //     var time = await showTimePicker(
                          //         context: context,
                          //         initialTime: TimeOfDay(hour: provider.startWorkingTime.hour, minute: provider.startWorkingTime.minute));
                          //     if (time != null) {
                          //       setState(() {
                          //         provider.startWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                          //       });
                          //     }
                          //   },
                          //   val: dateTimeToHourAndMinute(provider.startWorkingTime),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              " 〜 ",
                              style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.endWorkingTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.endWorkingTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.endWorkingTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                          // CustomChooseDateOrTimeWidget(
                          //   title: JapaneseText.endWorkingTime,
                          //   onTap: () async {
                          //     var time = await showTimePicker(
                          //         context: context,
                          //         initialTime: TimeOfDay(hour: provider.endWorkingTime.hour, minute: provider.endWorkingTime.minute));
                          //     if (time != null) {
                          //       setState(() {
                          //         provider.endWorkingTime = DateTime(1, 1, 1, time.hour, time.minute);
                          //       });
                          //     }
                          //   },
                          //   val: dateTimeToHourAndMinute(provider.endWorkingTime),
                          // ),
                          AppSize.spaceWidth32,
                          SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.startBreakTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.startBreakTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.startBreakTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),
                          // CustomChooseDateOrTimeWidget(
                          //   title: JapaneseText.startBreakTime,
                          //   onTap: () async {
                          //     var time = await showTimePicker(
                          //         context: context,
                          //         initialTime: TimeOfDay(hour: provider.startBreakTime.hour, minute: provider.startBreakTime.minute));
                          //     if (time != null) {
                          //       setState(() {
                          //         provider.startBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                          //       });
                          //     }
                          //   },
                          //   val: dateTimeToHourAndMinute(provider.startBreakTime),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              " 〜 ",
                              style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TimePickerField(
                              label: JapaneseText.endBreakTime,
                              // helperText: "Enter in HH:mm format",
                              initialTime: TextEditingController(text: dateTimeToHourAndMinute(provider.endBreakTime)),
                              onChanged: (val) {
                                    final parts = val.split(":");
                                    if (parts.length == 2) {
                                      final hour = int.tryParse(parts[0]);
                                      final minute = int.tryParse(parts[1]);
                                      if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                                        setState(() {
                                          provider.endBreakTime = DateTime(1, 1, 1, hour, minute);
                                        });
                                      }
                                    }
                                  },
                              onSubmitted: (time) => print("Submitted: $time"),
                            ),
                          ),

                          // CustomChooseDateOrTimeWidget(
                          //   title: JapaneseText.endBreakTime,
                          //   onTap: () async {
                          //     var time = await showTimePicker(
                          //         context: context, initialTime: TimeOfDay(hour: provider.endBreakTime.hour, minute: provider.endBreakTime.minute));
                          //     if (time != null) {
                          //       setState(() {
                          //         provider.endBreakTime = DateTime(1, 1, 1, time.hour, time.minute);
                          //       });
                          //     }

                          //   },
                          //   val: dateTimeToHourAndMinute(provider.endBreakTime),
                          // ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              CustomDropDownWidget(
                                radius: 5,
                                selectItem: provider.selectedTFOptions,
                                list: provider.transportationFeeOptions,
                                onChange: (v) => provider.onChangeTFOptions(v),
                                width: 300,
                              ),
                            ],
                          ),
                          AppSize.spaceWidth32,
                          provider.selectedTFOptions == JapaneseText.notProvidedTF
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "交通費（1日につき）",
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
                                ),
                          AppSize.spaceHeight5,
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
    provider.jobPosting?.transportationFeeOptions = provider.selectedTFOptions;
    provider.jobPosting?.isAllowSmokingInArea = provider.isAllowSmokingInArea;
    provider.jobPosting?.selectSmokingInDoor = provider.selectSmokingInDoor;
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
      toastMessageSuccess(JapaneseText.successCreate, context);
      Navigator.pop(context, provider.jobPosting!.shiftFrameList);
    } else {
      toastMessageError(JapaneseText.failCreate, context);
    }
  }
}
