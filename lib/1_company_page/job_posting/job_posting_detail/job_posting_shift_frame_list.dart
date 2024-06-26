import 'package:air_job_management/1_company_page/job_posting/widget/matching_worker.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

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
  UpdateHistory? selectShiftFrame;
  bool isLoading = true;
  int index = 0;
  List<UpdateHistory> updateHistoyList = [];

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
                    onDelete: () {
                      if (selectShiftFrame == null) {
                        toastMessageError("マッチングの前に、まず1つの仕事を選んでください！", context);
                      } else {
                        CustomDialog.confirmDelete(
                            context: context,
                            onDelete: () {
                              Navigator.pop(context);
                              onDelete();
                            });
                      }
                    },
                    onAdd: () {
                      if (selectShiftFrame == null) {
                        toastMessageError("マッチングの前に、まず1つの仕事を選んでください！", context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  content: MatchingWorkerPage(
                                    jobPosting: provider.jobPosting!,
                                    shiftFrame: ShiftFrame(
                                        startDate: selectShiftFrame!.startDate,
                                        recruitmentNumberPeople: selectShiftFrame!.recruitment,
                                        expiredTime: null,
                                        endDate: selectShiftFrame!.endDate,
                                        endBreakTime: provider.jobPosting!.endBreakTimeHour,
                                        endWorkTime: selectShiftFrame!.endTime,
                                        startBreakTime: provider.jobPosting!.startBreakTimeHour,
                                        startWorkTime: selectShiftFrame!.startTime,
                                        applicationDateline: provider.jobPosting!.applicationDateline,
                                        bicycleCommutingPossible: provider.jobPosting!.bicycleCommutingPossible,
                                        emergencyContact: provider.jobPosting!.emergencyContact,
                                        hourlyWag: provider.jobPosting!.hourlyWag,
                                        motorCycleCarCommutingPossible: provider.jobPosting!.motorCycleCarCommutingPossible,
                                        selectedPublicSetting: provider.jobPosting!.selectedPublicSetting,
                                        transportExpenseFee: provider.jobPosting!.transportExpenseFee),
                                    onSuccess: () {
                                      onRefreshData();
                                    },
                                  ),
                                ));
                      }
                    },
                    onCopyPaste: () {
                      // if (selectShiftFrame == null) {
                      //   toastMessageError("マッチングの前に、まず1つの仕事を選んでください！", context);
                      // } else {
                      //   var now = DateTime.now();
                      //   provider.transportExp.text = selectShiftFrame!.transportExpenseFee!;
                      //   provider.hourlyWag.text = selectShiftFrame!.hourlyWag!;
                      //   provider.numberOfRecruitPeople.text = selectShiftFrame!.recruitmentNumberPeople!;
                      //   provider.startWorkDate = DateToAPIHelper.fromApiToLocal(selectShiftFrame!.startDate!);
                      //   provider.endWorkDate = DateToAPIHelper.fromApiToLocal(selectShiftFrame!.endDate!);
                      //   provider.startWorkingTime = DateTime(
                      //       now.year,
                      //       now.month,
                      //       now.day,
                      //       int.parse(selectShiftFrame!.startWorkTime.toString().split(":")[0]),
                      //       int.parse(selectShiftFrame!.startWorkTime.toString().split(":")[1]),
                      //       0);
                      //   provider.endWorkingTime = DateTime(
                      //       now.year,
                      //       now.month,
                      //       now.day,
                      //       int.parse(selectShiftFrame!.endWorkTime.toString().split(":")[0]),
                      //       int.parse(selectShiftFrame!.endWorkTime.toString().split(":")[1]),
                      //       0);
                      //   provider.startBreakTime = DateTime(
                      //       now.year,
                      //       now.month,
                      //       now.day,
                      //       int.parse(selectShiftFrame!.startBreakTime.toString().split(":")[0]),
                      //       int.parse(selectShiftFrame!.startBreakTime.toString().split(":")[1]),
                      //       0);
                      //   provider.endBreakTime = DateTime(
                      //       now.year,
                      //       now.month,
                      //       now.day,
                      //       int.parse(selectShiftFrame!.endBreakTime.toString().split(":")[0]),
                      //       int.parse(selectShiftFrame!.endBreakTime.toString().split(":")[1]),
                      //       0);
                      //   setState(() {});
                      //   showCopyAndPaste();
                      // }
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
                  flex: 2,
                ),
                // Expanded(
                //   child: Center(
                //     child: Text("応募人数", style: normalTextStyle.copyWith(fontSize: 13)),
                //   ),
                //   flex: 1,
                // ),
                Expanded(
                    flex: 2,
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
      if (updateHistoyList.isNotEmpty) {
        return Expanded(
          child: ListView.separated(
              itemCount: updateHistoyList.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == updateHistoyList.length ? 20 : 0)),
              itemBuilder: (context, index) {
                UpdateHistory shiftFrame = updateHistoyList[index];
                return ShiftFrameCardWidget(
                  shiftFrame: shiftFrame,
                  selectShiftFrame: selectShiftFrame,
                  title: shiftFrame.title ?? "",
                  onUpdateStatus: () {
                    updateJobHistory(index, shiftFrame.isClose!);
                  },
                  onClick: () {
                    setState(() {
                      this.index = index;
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

  // showCopyAndPaste() {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return Scaffold(
  //           backgroundColor: Colors.transparent,
  //           body: Padding(
  //             padding: EdgeInsets.all(AppSize.getDeviceHeight(context) * 0.1),
  //             child: const JobPostingShiftPageForCompany(
  //               isFromCopyShift: true,
  //             ),
  //           ),
  //         );
  //       }).then((value) {
  //     if (value != null) {
  //       onRefreshData();
  //     }
  //   });
  // }

  onDelete() async {
    try {
      updateHistoyList.removeAt(index);
      setState(() {
        isLoading = true;
      });
      selectShiftFrame = null;
      provider.jobPosting!.updateList = updateHistoyList;
      String? isSuccess = await JobPostingApiService().updateJobPostingInfo(provider.jobPosting!);
      setState(() {
        isLoading = false;
      });
      if (isSuccess == ConstValue.success) {
        toastMessageSuccess(JapaneseText.successUpdate, context);
        onRefreshData();
      } else {
        toastMessageSuccess(JapaneseText.failUpdate, context);
      }
    } catch (e) {
      toastMessageSuccess(e.toString(), context);
    }
  }

  updateJobHistory(int index, bool isClose) async {
    updateHistoyList[index].isClose = !isClose;
    await JobPostingApiService().updateJobHistory(provider.jobPosting!.uid!, updateHistoyList);
    onRefreshData();
  }

  onRefreshData() async {
    debugPrint("Refresh data");
    setState(() {
      isLoading = true;
    });
    updateHistoyList = [];
    provider.jobPosting = await JobPostingApiService().getAJobPosting(provider.jobPosting!.uid!);
    setState(() {});
    getData();
  }

  getData() async {
    try {
      if (provider.jobPosting != null && provider.jobPosting!.updateList!.isEmpty) {
        updateHistoyList.add(UpdateHistory(
          recruitment: provider.jobPosting!.numberOfRecruit.toString(),
          postStartDate: provider.jobPosting!.postedStartDate.toString(),
          postEndDate: provider.jobPosting!.postedEndDate.toString(),
          startDate: provider.jobPosting!.startDate.toString(),
          endDate: provider.jobPosting!.endDate.toString(),
          title: provider.jobPosting!.title.toString(),
          startTime: provider.jobPosting!.startTimeHour.toString(),
          endTime: provider.jobPosting!.endTimeHour.toString(),
        ));
      } else {
        updateHistoyList.addAll(provider.jobPosting?.updateList ?? []);
      }
      // if (widget.isView) {
      //   updateHistoyList.add(UpdateHistory(
      //     recruitment: provider.numberOfRecruitPeople.text.toString(),
      //     postStartDate: DateToAPIHelper.convertDateToString(provider.startPostDate),
      //     postEndDate: DateToAPIHelper.convertDateToString(provider.endPostDate),
      //     startDate: DateToAPIHelper.convertDateToString(provider.startWorkDate),
      //     endDate: DateToAPIHelper.convertDateToString(provider.endWorkDate),
      //     title: provider.title.text.toString(),
      //     startTime: dateTimeToHourAndMinute(provider.startWorkingTime),
      //     endTime: dateTimeToHourAndMinute(provider.endWorkingTime),
      //   ));
      //   provider.jobPosting?.updateList = updateHistoyList;
      // }
      updateHistoyList.sort((a, b) => b.endDate!.compareTo(a.endDate!));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }
}
