import 'package:air_job_management/api/company/request.dart';
import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../helper/date_to_api.dart';
import '../../../models/user.dart';
import '../../../models/worker_model/shift.dart';
import '../../../utils/common_utils.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_loading_overlay.dart';
import '../../woker_management/widget/job_card.dart';

class ShiftDetailDialogWidget extends StatefulWidget {
  final String jobId;
  final String startTime;
  final String endTime;
  final DateTime date;
  final Function onSuccess;
  const ShiftDetailDialogWidget(
      {super.key, required this.jobId, required this.date, required this.onSuccess, required this.endTime, required this.startTime});

  @override
  State<ShiftDetailDialogWidget> createState() => _ShiftDetailDialogWidgetState();
}

class _ShiftDetailDialogWidgetState extends State<ShiftDetailDialogWidget> with AfterBuildMixin {
  bool isLoading = true;
  List<WorkerManagement> applicantList = [];
  List<Request> requestList = [];
  WorkerManagement? workerManagement;
  JobPosting? jobPosting;
  DateTime now = DateTime.now();
  int countApplyPeople = 0;
  List<String> menuTab = ["新規応募", "変更申請"];
  String selectedTab = "新規応募";
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: CustomLoadingOverlay(
        isLoading: isLoading,
        child: SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.9,
          height: AppSize.getDeviceHeight(context) * 0.9,
          child: applicantList.isEmpty && isLoading ? SizedBox(height: 150, child: LoadingWidget(AppColor.primaryColor)) : buildJobDetail(),
        ),
      ),
    );
  }

  buildTab() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTab = menuTab[0];
              });
            },
            child: Container(
              // width: AppSize.getDeviceWidth(context) * 0.41,
              height: 39,
              alignment: Alignment.center,
              child: Text(
                menuTab[0],
                style: normalTextStyle.copyWith(
                    fontSize: 16, fontFamily: "Bold", color: selectedTab == menuTab[0] ? Colors.white : AppColor.primaryColor),
              ),
              decoration: BoxDecoration(
                  color: selectedTab == menuTab[0] ? AppColor.primaryColor : Colors.white,
                  border: Border.all(width: 2, color: AppColor.primaryColor),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            ),
          ),
        ),
        AppSize.spaceWidth16,
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTab = menuTab[1];
              });
            },
            child: Container(
              // width: AppSize.getDeviceWidth(context) * 0.41,
              height: 39,
              alignment: Alignment.center,
              child: Text(
                menuTab[1],
                style:
                    normalTextStyle.copyWith(fontSize: 16, fontFamily: "Bold", color: selectedTab == menuTab[1] ? Colors.white : AppColor.seaColor),
              ),
              decoration: BoxDecoration(
                  color: selectedTab == menuTab[1] ? AppColor.seaColor : Colors.white,
                  border: Border.all(width: 2, color: AppColor.seaColor),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            ),
          ),
        ),
      ],
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
                  ],
                ),
                AppSize.spaceHeight16,
                divider(),
                AppSize.spaceHeight30,
                buildTab(),
                AppSize.spaceHeight30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "任意のワーカーを選んでまとめて",
                      style: normalTextStyle.copyWith(fontSize: 13),
                    ),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 130,
                      child: ButtonWidget(
                        radius: 25,
                        borderColor: selectedTab == menuTab[1] ? AppColor.seaColor : AppColor.primaryColor,
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
                        borderColor: selectedTab == menuTab[1] ? AppColor.seaColor : AppColor.primaryColor,
                        color: AppColor.whiteColor,
                        title: "不承認にする",
                        onPress: () {},
                      ),
                    )
                  ],
                ),
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
                      flex: 3,
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
                        child: Text(selectedTab == menuTab[0] ? "Good率" : "申請カテゴリ", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: selectedTab == menuTab[0] ? 1 : 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(selectedTab == menuTab[0] ? "稼働回数" : "詳細", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: selectedTab == menuTab[0] ? 1 : 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("状態", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: selectedTab == menuTab[0] ? 4 : 5,
                    ),
                  ],
                ),
                AppSize.spaceHeight16,
                if (selectedTab == menuTab[0])
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: applicantList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var job = applicantList[index];
                        var dateList = job.shiftList!.map((e) => e.date).toList();
                        return job.myUser == null || !dateList.contains(widget.date) ? const SizedBox() : buildUserApplyList(job, index);
                      })
                else if (requestList.isEmpty)
                  const Center(
                    child: EmptyDataWidget(),
                  )
                else
                  buildRequestList()
              ],
            ),
          )
        ],
      ),
    );
  }

  buildRequestList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: requestList.length,
        itemBuilder: (context, index) {
          var request = requestList[index];
          return Container(
            width: AppSize.getDeviceWidth(context),
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
            margin: const EdgeInsets.only(bottom: 8, left: 0, right: 0),
            decoration: BoxDecoration(
                color: Colors.transparent, borderRadius: BorderRadius.circular(16), border: Border.all(width: 1, color: AppColor.primaryColor)),
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
                          imageUrl: request.myUser?.profileImage ?? "",
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
                                    request.username ?? "",
                                    style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                AppSize.spaceWidth16,
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Center(
                      child: Text(
                        calculateAge(DateToAPIHelper.fromApiToLocal(request.myUser!.dob!.replaceAll("-", "/").toString())) +
                            "   ${request.myUser?.gender}",
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
                      "${request.myUser?.phone}",
                      style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Center(child: CommonUtils.displayRequestType(request)),
                  flex: 2,
                ),
                Expanded(
                  child: request.isHoliday == true
                      ? Center(
                          child: Text(
                            request.date.toString(),
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            overflow: TextOverflow.fade,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              request.isUpdateShift == true ? "${request.shiftModel?.startWorkTime}" : "${request.shiftModel?.endWorkTime}",
                              style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: AppColor.seaColor,
                                size: 17,
                              ),
                            ),
                            Text(
                              request.isUpdateShift == true ? "${request.fromTime}" : "${request.toTime}",
                              style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            ),
                          ],
                        ),
                  flex: 2,
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          child: ButtonWidget(
                            radius: 25,
                            borderColor: selectedTab == menuTab[1] ? AppColor.seaColor : AppColor.primaryColor,
                            color: request.status == "approved" ? AppColor.seaColor : AppColor.whiteColor,
                            title: "確定する",
                            onPress: () => updateRequestStatus("確定する", request),
                          ),
                        ),
                        AppSize.spaceWidth8,
                        SizedBox(
                          width: 145,
                          child: ButtonWidget(
                            radius: 25,
                            borderColor: selectedTab == menuTab[1] ? AppColor.seaColor : AppColor.primaryColor,
                            color: request.status == "rejected" ? AppColor.seaColor : AppColor.whiteColor,
                            title: "不承認にする",
                            onPress: () => updateRequestStatus("キャンセル", request),
                          ),
                        )
                      ],
                    ),
                    flex: 5),
              ],
            ),
          );
        });
  }

  updateRequestStatus(String action, Request request) {
    String status = action == "確定する" ? "approved" : "rejected";
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await RequestApiService().updateRequestStatus(request, status, authProvider.myCompany!, authProvider?.branch);
          if (isSuccess) {
            await getData();
            setState(() {
              isLoading = false;
            });
            widget.onSuccess();
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
                        flex: 3,
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
                                width: 140,
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
                                      updateJobStatus(job.shiftList!, shift, "確定する", index, job.uid!, job.myUser!);
                                    } else {
                                      toastMessageError("この仕事は完了しました。", context);
                                    }
                                  },
                                ),
                              ),
                              AppSize.spaceWidth8,
                              SizedBox(
                                width: 145,
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
                                      updateJobStatus(job.shiftList!, shift, "キャンセル", index, job.uid!, job.myUser!);
                                    } else {
                                      toastMessageError("この仕事は完了しました。", context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          flex: 4),
                    ],
                  ),
                );
        });
  }

  updateJobStatus(List<ShiftModel> shiftList, ShiftModel shiftModel, String action, int index, String jobId, MyUser myUser) {
    shiftModel.status = action == "確定する" ? "approved" : "rejected";
    shiftList[index] = shiftModel;
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await WorkerManagementApiService().updateShiftStatus(
              branch: authProvider.branch, shiftList, jobId, myUser: myUser, company: authProvider.myCompany!, shiftModel: shiftModel);
          if (isSuccess) {
            await getData();
            setState(() {
              isLoading = false;
            });
            widget.onSuccess();
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
    requestList = await RequestApiService().getRequestByDate(DateToAPIHelper.convertDateToString(widget.date), workerManagement!.jobId!);
    // var data = await Future.wait([
    //   WorkerManagementApiService().getAJob(widget.jobId),
    //   JobPostingApiService().getAJobPosting(workerManagement!.jobId!),
    //   WorkerManagementApiService().getAllApplicantByJobId(workerManagement!.jobId!),
    //   RequestApiService().getRequestByDate(DateToAPIHelper.convertDateToString(widget.date), widget.jobId)
    // ]);
    // workerManagement = data[0] as WorkerManagement;
    // jobPosting = data[1] as JobPosting;
    // applicantList = data[2] as List<WorkerManagement>;
    // requestList = data[3] as List<Request>;
    print("Request Length ${requestList.length}");
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
