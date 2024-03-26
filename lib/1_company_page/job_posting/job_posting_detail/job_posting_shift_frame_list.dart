import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_shift.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/matching_worker.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../helper/date_to_api.dart';
import '../../../helper/japan_date_time.dart';
import '../../../models/job_posting.dart';
import '../../../providers/company/job_posting.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';
import '../widget/matching_and_copy_button.dart';
import '../widget/shift_frame_card.dart';

class JobPostingShiftFramePageForCompany extends StatefulWidget {
  final bool isView;
  const JobPostingShiftFramePageForCompany({super.key, this.isView = false});

  @override
  State<JobPostingShiftFramePageForCompany> createState() => _JobPostingShiftFramePageForCompanyState();
}

class _JobPostingShiftFramePageForCompanyState extends State<JobPostingShiftFramePageForCompany> with AfterBuildMixin {
  late JobPostingForCompanyProvider provider;
  late AuthProvider authProvider;
  ShiftFrame? selectShiftFrame;
  List<ShiftFrame> shiftFrameList = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            AppSize.spaceHeight16,
            AbsorbPointer(
              absorbing: widget.isView,
              child: Row(
                children: [
                  const TitleWidget(title: "シフト枠　一覧"),
                  Expanded(
                      child: MatchingAndCopyButtonWidget(
                    onAdd: () {
                      if (selectShiftFrame == null) {
                        toastMessageError("マッチングの前に、まず1つの仕事を選んでください！", context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  content: MatchingWorkerPage(
                                    jobPosting: provider.jobPosting!,
                                    shiftFrame: selectShiftFrame!,
                                    onSuccess: () {
                                      onRefreshData();
                                    },
                                  ),
                                ));
                      }
                    },
                    onCopyPaste: () {
                      if (selectShiftFrame == null) {
                        toastMessageError("マッチングの前に、まず1つの仕事を選んでください！", context);
                      } else {
                        var now = DateTime.now();
                        provider.transportExp.text = selectShiftFrame!.transportExpenseFee!;
                        provider.hourlyWag.text = selectShiftFrame!.hourlyWag!;
                        provider.numberOfRecruitPeople.text = selectShiftFrame!.recruitmentNumberPeople!;
                        provider.startWorkDate = DateToAPIHelper.fromApiToLocal(selectShiftFrame!.startDate!);
                        provider.endWorkDate = DateToAPIHelper.fromApiToLocal(selectShiftFrame!.endDate!);
                        provider.startWorkingTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(selectShiftFrame!.startWorkTime.toString().split(":")[0]),
                            int.parse(selectShiftFrame!.startWorkTime.toString().split(":")[1]),
                            0);
                        provider.endWorkingTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(selectShiftFrame!.endWorkTime.toString().split(":")[0]),
                            int.parse(selectShiftFrame!.endWorkTime.toString().split(":")[1]),
                            0);
                        provider.startBreakTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(selectShiftFrame!.startBreakTime.toString().split(":")[0]),
                            int.parse(selectShiftFrame!.startBreakTime.toString().split(":")[1]),
                            0);
                        provider.endBreakTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(selectShiftFrame!.endBreakTime.toString().split(":")[0]),
                            int.parse(selectShiftFrame!.endBreakTime.toString().split(":")[1]),
                            0);
                        setState(() {});
                        showCopyAndPaste();
                      }
                    },
                  ))
                ],
              ),
            ),
            AppSize.spaceHeight16,
            Row(
              children: [
                Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Text(
                          "求人タイトル",
                          style: normalTextStyle.copyWith(fontSize: 13),
                        ),
                      )),
                  flex: 3,
                ),
                Expanded(
                  child: Center(
                    child: Text("稼働期間", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Center(
                    child: Text("募集人数", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text("応募人数", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 1,
                ),
                SizedBox(
                    width: 100,
                    child: Center(
                      child: Text("掲載状況", style: normalTextStyle.copyWith(fontSize: 13)),
                    ))
              ],
            ),
            AppSize.spaceHeight16,
            buildList()
          ],
        ),
      ),
    );
  }

  buildList() {
    if (isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (shiftFrameList.isNotEmpty) {
        return Expanded(
          child: ListView.separated(
              itemCount: shiftFrameList.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == shiftFrameList.length ? 20 : 0)),
              itemBuilder: (context, index) {
                ShiftFrame shiftFrame = shiftFrameList[index];
                return ShiftFrameCardWidget(
                  shiftFrame: shiftFrame,
                  selectShiftFrame: selectShiftFrame,
                  title: provider.jobPosting?.title ?? "",
                  onClick: () {
                    setState(() {
                      selectShiftFrame = shiftFrame;
                    });
                  },
                );
              }),
        );
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }

  showCopyAndPaste() {
    showDialog(
        context: context,
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.all(AppSize.getDeviceHeight(context) * 0.1),
              child: const JobPostingShiftPageForCompany(
                isFromCopyShift: true,
              ),
            ),
          );
        }).then((value) {
      if (value != null) {
        setState(() {
          shiftFrameList = value;
        });
      }
    });
  }

  onRefreshData() async {
    debugPrint("Refresh data");
    setState(() {
      isLoading = true;
    });
    shiftFrameList = [];
    // await provider.onInitForJobPostingDetail(authProvider.myCompany?.uid ?? "");
    getData();
  }

  getData() async {
    shiftFrameList.add(ShiftFrame(
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
    shiftFrameList.addAll(provider.jobPosting?.shiftFrameList ?? []);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }
}
