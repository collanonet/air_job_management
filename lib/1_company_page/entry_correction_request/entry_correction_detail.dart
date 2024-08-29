import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/dateTime_Cal.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../helper/currency_format.dart';
import '../../helper/date_to_api.dart';
import '../../models/entry_exit_history.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading_overlay.dart';

class EntryCorrectionRequestDetailPage extends StatefulWidget {
  final String entryId;
  const EntryCorrectionRequestDetailPage({super.key, required this.entryId});

  @override
  State<EntryCorrectionRequestDetailPage> createState() =>
      _EntryCorrectionRequestDetailPageState();
}

class _EntryCorrectionRequestDetailPageState
    extends State<EntryCorrectionRequestDetailPage> with AfterBuildMixin {
  EntryExitHistory? entryExitHistory;
  bool isLoading = true;
  double hourlyWageWithTF = 0;
  double hourlyWageWithTFForUpdate = 0;
  double workingHours = 0;
  double hourlyWage = 0;
  double actualWorkingHoursForUpdate = 0;
  double actualWorkingHours = 0;
  double breakTimeHours = 0;
  MyUser? myUser;

  @override
  void initState() {
    super.initState();
  }

  calculateWage() async {
    DateTime workDate = DateToAPIHelper.fromApiToLocal(
        entryExitHistory!.entryExitHistoryCorrection!.startDate!);
    DateTime endDate = DateToAPIHelper.fromApiToLocal(
        entryExitHistory!.entryExitHistoryCorrection!.startDate!);
    DateTime startWorkingTime = DateTime(
        workDate.year,
        workDate.month,
        workDate.day,
        int.parse(entryExitHistory!
            .entryExitHistoryCorrection!.startWorkingTime!
            .split(":")[0]),
        int.parse(entryExitHistory!
            .entryExitHistoryCorrection!.startWorkingTime!
            .split(":")[1]));
    DateTime endWorkingTime = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        int.parse(entryExitHistory!.entryExitHistoryCorrection!.endWorkingTime!
            .split(":")[0]),
        int.parse(entryExitHistory!.entryExitHistoryCorrection!.endWorkingTime!
            .split(":")[1]));

    breakTimeHours = convertTimeStringToHours(
        entryExitHistory!.entryExitHistoryCorrection!.breakTime!);
    List<dynamic> wageCal = ExtraWageCalculator().calculateExtraWage(
        startWorkingTime,
        endWorkingTime,
        hourlyWage,
        breakTimeHours,
        entryExitHistory!.transportationFee!);
    double totalWage = wageCal[0];
    entryExitHistory!.entryExitHistoryCorrection!.totalWage =
        totalWage.toString();
    entryExitHistory!.overtime = wageCal[1];
    entryExitHistory!.midnightOvertime = wageCal[2];
    entryExitHistory!.entryExitHistoryCorrection!.midnightOverTimePay =
        calculateOvertimeAndMidNight(
            actualWorkingHours - breakTimeHours,
            hourlyWageWithTF,
            hourlyWage,
            entryExitHistory!.overtime ?? "00:00",
            entryExitHistory!.midnightOvertime ?? "00:00")[2];
    entryExitHistory!.entryExitHistoryCorrection!.midnightOverTime = wageCal[2];
    entryExitHistory!.entryExitHistoryCorrection!.overtime = wageCal[1];
    entryExitHistory!.entryExitHistoryCorrection!.overtimePay =
        calculateOvertimeAndMidNight(
            actualWorkingHours - breakTimeHours,
            hourlyWageWithTF,
            hourlyWage,
            entryExitHistory!.overtime ?? "00:00",
            entryExitHistory!.midnightOvertime ?? "00:00")[1];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: Container(
        decoration: boxDecoration,
        width: AppSize.getDeviceWidth(context),
        padding: const EdgeInsets.all(32.0),
        child: isLoading
            ? Center(
                child: LoadingWidget(AppColor.primaryColor),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleWidget(title: "ワーカーから就業時間の修正依頼"),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: AppColor.primaryColor),
                      )
                    ],
                  ),
                  AppSize.spaceHeight20,
                  Expanded(
                    child: entryExitHistory!.correctionStatus == "approved"
                        ? correctionWidget()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              oldDataWidget(),
                              Padding(
                                padding: const EdgeInsets.all(32),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColor.secondaryColor,
                                  size: 25,
                                ),
                              ),
                              correctionWidget()
                            ],
                          ),
                  ),
                  SizedBox(
                    width: AppSize.getDeviceWidth(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: ButtonWidget(
                              radius: 25,
                              title: "確定する",
                              color: entryExitHistory!.correctionStatus ==
                                      "approved"
                                  ? Colors.grey
                                  : AppColor.primaryColor,
                              onPress: () {
                                if (entryExitHistory!.correctionStatus ==
                                    "approved") {
                                  toastMessageError(
                                      "アクションはすでに完了しています", context);
                                } else {
                                  onUpdateData("approved");
                                }
                              }),
                        ),
                        AppSize.spaceWidth16,
                        SizedBox(
                            width: 200,
                            child: ButtonWidget(
                              radius: 25,
                              color: entryExitHistory!.correctionStatus ==
                                      "approved"
                                  ? Colors.grey
                                  : AppColor.whiteColor,
                              title: "不承認にする",
                              onPress: () {
                                if (entryExitHistory!.correctionStatus ==
                                    "approved") {
                                  toastMessageError(
                                      "アクションはすでに完了しています", context);
                                } else {
                                  onUpdateData("rejected");
                                }
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  onUpdateData(String status) {
    CustomDialog.confirmApprove(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await EntryExitApiService().updateEntryExitData(
              entryExitHistory!,
              convertToHoursAndMinutes(actualWorkingHoursForUpdate),
              status,
              myUser);

          if (isSuccess) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
            toastMessageSuccess(JapaneseText.successUpdate, context);
          } else {
            setState(() {
              isLoading = false;
            });
            toastMessageError(JapaneseText.failUpdate, context);
          }
        });
  }

  oldDataWidget() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context) * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "修正前の確認画面",
            style: kTitleText,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.justify,
          ),
          AppSize.spaceHeight20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "業務開始",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "業務終了",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.workDate}",
                style: kNormalText,
              ),
              Text(
                "${entryExitHistory!.endWorkDate}",
                style: kNormalText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.startWorkingTime}",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.startWorkingTime!,
                        entryExitHistory!.startWorkingTime!)),
              ),
              Text(
                "${entryExitHistory!.endWorkingTime}",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.endWorkingTime!,
                        entryExitHistory!.endWorkingTime!)),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          const Divider(),
          AppSize.spaceHeight16,
          Text(
            "休憩時間",
            style: kNormalText.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.breakingTimeHour}時間${entryExitHistory!.breakingTimeMinute}分",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.breakTime!,
                        "${entryExitHistory!.breakingTimeHour.toString()}:${entryExitHistory!.breakingTimeMinute.toString()}")),
              ),
              Text(
                "",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          const Divider(),
          AppSize.spaceHeight16,
          Text(
            "報酬内訳",
            style: kNormalText.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "時給",
                style: kNormalText,
              ),
              Text(
                "${CurrencyFormatHelper.displayData(entryExitHistory!.amount.toString())} / 1時間",
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "基本給",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    "${hourlyWage * actualWorkingHours}"),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "残業代",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(calculateOvertimeAndMidNight(
                    actualWorkingHours,
                    hourlyWageWithTF,
                    hourlyWage,
                    entryExitHistory!.overtime ?? "00:00",
                    entryExitHistory!.midnightOvertime ?? "00:00")[1]),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "深夜残業代",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(calculateOvertimeAndMidNight(
                    actualWorkingHours,
                    hourlyWageWithTF,
                    hourlyWage,
                    entryExitHistory!.overtime ?? "00:00",
                    entryExitHistory!.midnightOvertime ?? "00:00")[2]),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "交通費（非課税）",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    entryExitHistory!.transportationFee.toString()),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "内源泉徴収額",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData("0"),
                style: kNormalText.copyWith(color: Colors.red),
              ),
            ],
          ),
          AppSize.spaceHeight20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "支払われる報酬総額",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    "${entryExitHistory!.totalWage}"),
                style: kTitleText,
              ),
            ],
          ),
          AppSize.spaceHeight20,
        ],
      ),
    );
  }

  statusColor(String oldData, String newData) {
    print("Old data $oldData x New data $newData");
    if (oldData == newData) {
      return Colors.black;
    } else {
      return Colors.red;
    }
  }

  correctionWidget() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context) * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "修正内容の確認画面",
            style: kTitleText,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.justify,
          ),
          AppSize.spaceHeight20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "業務開始",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "業務終了",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.entryExitHistoryCorrection?.startDate}",
                style: kNormalText,
              ),
              Text(
                "${entryExitHistory!.entryExitHistoryCorrection?.endDate}",
                style: kNormalText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.entryExitHistoryCorrection?.startWorkingTime}",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.startWorkingTime!,
                        entryExitHistory!.startWorkingTime!)),
              ),
              Text(
                "${entryExitHistory!.entryExitHistoryCorrection?.endWorkingTime}",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.startWorkingTime!,
                        entryExitHistory!.startWorkingTime!)),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          const Divider(),
          AppSize.spaceHeight16,
          Text(
            "休憩時間",
            style: kNormalText.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${entryExitHistory!.entryExitHistoryCorrection!.breakTime!.split(":")[0]}時間${entryExitHistory!.entryExitHistoryCorrection!.breakTime!.split(":")[1]}分",
                style: kNormalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor(
                        entryExitHistory!
                            .entryExitHistoryCorrection!.breakTime!,
                        "${entryExitHistory!.breakingTimeHour.toString()}:${entryExitHistory!.breakingTimeMinute.toString()}")),
              ),
              Text(
                "",
                style: kNormalText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          AppSize.spaceHeight16,
          const Divider(),
          AppSize.spaceHeight16,
          Text(
            "報酬内訳",
            style: kNormalText.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "時給",
                style: kNormalText,
              ),
              Text(
                "${CurrencyFormatHelper.displayData(entryExitHistory!.amount.toString())} / 1時間",
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "基本給",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    "${actualWorkingHoursForUpdate * double.parse(entryExitHistory!.amount.toString())}"),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "残業代",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(calculateOvertimeAndMidNight(
                    actualWorkingHoursForUpdate,
                    hourlyWageWithTFForUpdate,
                    hourlyWage,
                    entryExitHistory!.entryExitHistoryCorrection?.overtime ??
                        "00:00",
                    entryExitHistory!
                            .entryExitHistoryCorrection?.midnightOverTime ??
                        "00:00")[1]),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "深夜残業代",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(calculateOvertimeAndMidNight(
                    actualWorkingHoursForUpdate,
                    hourlyWageWithTFForUpdate,
                    hourlyWage,
                    entryExitHistory!.entryExitHistoryCorrection?.overtime ??
                        "00:00",
                    entryExitHistory!
                            .entryExitHistoryCorrection?.midnightOverTime ??
                        "00:00")[2]),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "交通費（非課税）",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    entryExitHistory!.transportationFee.toString()),
                style: kNormalText,
              ),
            ],
          ),
          AppSize.spaceHeight5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "内源泉徴収額",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData("0"),
                style: kNormalText.copyWith(color: Colors.red),
              ),
            ],
          ),
          AppSize.spaceHeight20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "支払われる報酬総額",
                style: kNormalText,
              ),
              Text(
                CurrencyFormatHelper.displayData(
                    "${entryExitHistory!.entryExitHistoryCorrection!.totalWage}"),
                style: kTitleText,
              ),
            ],
          ),
          AppSize.spaceHeight20,
        ],
      ),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    entryExitHistory =
        await EntryExitApiService().getEntryExitById(widget.entryId);
    entryExitHistory!.uid = widget.entryId;
    myUser = await UserApiServices().getProfileUser(entryExitHistory!.userId!);
    var workingData = calculateBreakTime(
        entryExitHistory!.scheduleEndWorkingTime,
        entryExitHistory!.scheduleStartWorkingTime);
    entryExitHistory!.actualWorkingHour = workingData[0];
    entryExitHistory!.actualWorkingMinute = workingData[1];
    workingHours = convertTimeStringToHours(
        "${entryExitHistory!.actualWorkingHour}:${entryExitHistory!.actualWorkingMinute}");
    var actualWorkingDataForUpdate = calculateBreakTime(
        entryExitHistory!.entryExitHistoryCorrection!.endWorkingTime,
        entryExitHistory!.entryExitHistoryCorrection!.startWorkingTime);
    var afterButBreakTimeForUpdate = calculateBreakTime(
        "${actualWorkingDataForUpdate[0]}:${actualWorkingDataForUpdate[1]}",
        entryExitHistory!.entryExitHistoryCorrection!.breakTime);
    var afterCutOvertimeForUpdate = calculateBreakTime(
        "${actualWorkingDataForUpdate[0]}:${actualWorkingDataForUpdate[1]}",
        entryExitHistory!.entryExitHistoryCorrection!.overtime);
    actualWorkingHoursForUpdate = convertTimeStringToHours(
        "${afterCutOvertimeForUpdate[0]}:${afterCutOvertimeForUpdate[1]}");

    var actualWorkingData = calculateBreakTime(
        entryExitHistory!.endWorkingTime, entryExitHistory!.startWorkingTime);
    var afterButBreakTime = calculateBreakTime(
        "${actualWorkingData[0]}:${actualWorkingData[1]}",
        "${entryExitHistory!.breakingTimeHour}:${entryExitHistory!.breakingTimeMinute}");
    actualWorkingHours = convertTimeStringToHours(
        "${afterButBreakTime[0]}:${afterButBreakTime[1]}");

    print("Working hours $actualWorkingHours, $actualWorkingHoursForUpdate");
    hourlyWage = double.parse(entryExitHistory!.amount!);

    ///Calculate wage with total transportation
    hourlyWageWithTF = ExtraWageCalculator().calculateWageWithTransportFee(
        hourlyWage,
        entryExitHistory!.transportationFee!,
        actualWorkingHours >= 8 ? 8 : actualWorkingHours);
    hourlyWageWithTFForUpdate = ExtraWageCalculator()
        .calculateWageWithTransportFee(
            hourlyWage,
            entryExitHistory!.transportationFee!,
            actualWorkingHoursForUpdate >= 8 ? 8 : actualWorkingHoursForUpdate);

    ///Calculate Total Wage
    //calculateWage();
    setState(() {
      isLoading = false;
    });
  }
}
