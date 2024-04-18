import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../helper/date_to_api.dart';
import '../../../models/worker_model/shift.dart';
import '../../../utils/common_utils.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_loading_overlay.dart';
import '../../woker_management/widget/job_card.dart';

class ShiftDetailDialogWidget extends StatefulWidget {
  final String jobId;
  final DateTime date;
  ShiftDetailDialogWidget({super.key, required this.jobId, required this.date});

  @override
  State<ShiftDetailDialogWidget> createState() => _ShiftDetailDialogWidgetState();
}

class _ShiftDetailDialogWidgetState extends State<ShiftDetailDialogWidget> with AfterBuildMixin {
  bool isLoading = true;
  List<WorkerManagement> applicantList = [];
  WorkerManagement? workerManagement;
  JobPosting? jobPosting;
  DateTime now = DateTime.now();
  int countApplyPeople = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // actions: isLoading
      //     ? []
      //     : [
      //         Center(
      //           child: Padding(
      //             padding: const EdgeInsets.only(bottom: 20),
      //             child: SizedBox(
      //               width: 130,
      //               child: ButtonWidget(
      //                 onPress: () => Navigator.pop(context),
      //                 title: JapaneseText.close,
      //                 color: AppColor.primaryColor,
      //                 radius: 30,
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      content: CustomLoadingOverlay(
        isLoading: isLoading,
        child: SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.9,
          // height: AppSize.getDeviceHeight(context) * 0.6,
          child: applicantList.isEmpty && isLoading ? SizedBox(height: 150, child: LoadingWidget(AppColor.primaryColor)) : buildJobDetail(),
        ),
      ),
    );
  }

  buildJobDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleWidget(title: "${toJapanDate(widget.date)}"),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppColor.primaryColor,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobPosting?.title ?? "",
                  style: kNormalText.copyWith(fontSize: 16, fontFamily: "Bold", color: AppColor.primaryColor),
                ),
                AppSize.spaceHeight16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    displayColumn("時間", "${jobPosting?.startTimeHour}－${jobPosting?.endTimeHour}"),
                    horizontalDivider(),
                    displayColumn("求人の状態", now.isBefore(widget.date) ? "求人中" : "終了した"),
                    horizontalDivider(),
                    displayColumn("公開設定", "${jobPosting?.selectedPublicSetting}"),
                    horizontalDivider(),
                    displayColumn("募集人数", "${jobPosting?.numberOfRecruit}"),
                    horizontalDivider(),
                    displayColumn("確定人数", "$countApplyPeople"),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 75),
                          child: Text(
                            "任意のワーカーを選んでまとめて",
                            style: normalTextStyle.copyWith(fontSize: 13),
                          ),
                        ),
                        AppSize.spaceHeight8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 130,
                              child: ButtonWidget(
                                radius: 25,
                                color: AppColor.whiteColor,
                                title: "確定する",
                                onPress: () {},
                              ),
                            ),
                            AppSize.spaceWidth8,
                            SizedBox(
                              width: 150,
                              child: ButtonWidget(
                                radius: 25,
                                color: AppColor.whiteColor,
                                title: "不承認にする",
                                onPress: () {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
                AppSize.spaceHeight16,
                divider(),
                AppSize.spaceHeight30,
                Row(
                  children: [
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 80),
                            child: Text(
                              "氏名（漢字）",
                              style: normalTextStyle.copyWith(fontSize: 13),
                            ),
                          )),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("年齢/性別", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("電話番号", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("Good率", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("稼働回数", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("状態", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                AppSize.spaceHeight16,
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: applicantList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var job = applicantList[index];
                      var dateList = job.shiftList!.map((e) => e.date).toList();
                      return job.myUser == null || !dateList.contains(widget.date) ? const SizedBox() : buildUserApplyList(job, index);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  buildUserApplyList(WorkerManagement job, int i) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: job.shiftList!.length,
        itemBuilder: (context, index) {
          var shift = job.shiftList![index];
          return !CommonUtils.isTheSameDate(shift.date, widget.date)
              ? const SizedBox()
              : Container(
                  width: AppSize.getDeviceWidth(context),
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
                  margin: const EdgeInsets.only(bottom: 8, left: 0, right: 0),
                  decoration: BoxDecoration(
                      color: job.isSelect == true ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 1, color: AppColor.primaryColor)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                width: 48,
                                height: 48,
                                imageUrl: job.myUser?.profileImage ?? "",
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColor.whiteColor,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AppSize.spaceWidth16,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (job.myUser?.nameKanJi != null && job.myUser?.nameKanJi != "")
                                              ? "${job.myUser?.nameKanJi}"
                                              : JapaneseText.empty,
                                          style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      AppSize.spaceWidth16,
                                      job.userId != null
                                          ? const SizedBox()
                                          : Icon(
                                              Icons.star,
                                              color: AppColor.primaryColor,
                                            )
                                    ],
                                  ),
                                  Text(
                                    job.jobLocation ?? "",
                                    style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 15),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Center(
                            child: Text(
                              calculateAge(DateToAPIHelper.fromApiToLocal(job.myUser!.dob!.replaceAll("-", "/").toString())) +
                                  "   ${job.myUser?.gender}",
                              style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${job.myUser?.phone}",
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${job.myUser?.rating ?? "95"}%",
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${job.applyCount}回",
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ButtonWidget(
                                  radius: 25,
                                  color: shift.status == "completed"
                                      ? AppColor.bgPageColor
                                      : shift.status == "approved"
                                          ? AppColor.primaryColor
                                          : AppColor.whiteColor,
                                  title: "確定する",
                                  onPress: () {
                                    if (shift.status != "completed") {
                                      updateJobStatus(job.shiftList!, shift, "確定する", index, job.uid!);
                                    } else {
                                      toastMessageError("この仕事は完了しました。", context);
                                    }
                                  },
                                ),
                              ),
                              AppSize.spaceWidth32,
                              SizedBox(
                                width: 150,
                                child: ButtonWidget(
                                  radius: 25,
                                  color: shift.status == "completed"
                                      ? AppColor.bgPageColor
                                      : shift.status == "rejected"
                                          ? AppColor.primaryColor
                                          : AppColor.whiteColor,
                                  title: "不承認にする",
                                  onPress: () {
                                    if (shift.status != "completed") {
                                      updateJobStatus(job.shiftList!, shift, "キャンセル", index, job.uid!);
                                    } else {
                                      toastMessageError("この仕事は完了しました。", context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          flex: 3),
                    ],
                  ),
                );
        });
  }

  updateJobStatus(List<ShiftModel> shiftList, ShiftModel shiftModel, String action, int index, String jobId) {
    shiftModel.status = action == "確定する" ? "approved" : "rejected";
    shiftList[index] = shiftModel;
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await WorkerManagementApiService().updateShiftStatus(shiftList, jobId);
          if (isSuccess) {
            await getData();
            setState(() {
              isLoading = false;
            });
            toastMessageSuccess(JapaneseText.successUpdate, context);
          } else {
            setState(() {
              isLoading = false;
            });
            toastMessageError(JapaneseText.failUpdate, context);
          }
        },
        title: "本当に確定しますか？",
        titleText: action);
  }

  horizontalDivider() {
    return Container(
      width: 1,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColor.secondaryColor,
    );
  }

  divider() {
    return Container(
      width: AppSize.getDeviceHeight(context) * 0.9,
      height: 0.5,
      color: AppColor.bgPageColor,
    );
  }

  displayColumn(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
        ),
        Text(
          val,
          style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal"),
        )
      ],
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    workerManagement = await WorkerManagementApiService().getAJob(widget.jobId);
    jobPosting = await JobPostingApiService().getAJobPosting(workerManagement!.jobId!);
    applicantList = await WorkerManagementApiService().getAllApplicantByJobId(workerManagement!.jobId!);
    for (var job in applicantList) {
      var dateList = job.shiftList!.map((e) => e.date).toList();
      if (job.myUser != null && dateList.contains(widget.date)) {
        countApplyPeople++;
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
