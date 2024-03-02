import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../helper/date_to_api.dart';
import '../../../helper/status_helper.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: isLoading
          ? []
          : [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 130,
                    child: ButtonWidget(
                      onPress: () => Navigator.pop(context),
                      title: JapaneseText.close,
                      color: AppColor.primaryColor,
                      radius: 30,
                    ),
                  ),
                ),
              )
            ],
      content: SizedBox(
        width: AppSize.getDeviceHeight(context) * 0.8,
        // height: AppSize.getDeviceHeight(context) * 0.6,
        child: isLoading ? SizedBox(height: 150, child: LoadingWidget(AppColor.primaryColor)) : buildJobDetail(),
      ),
    );
  }

  buildJobDetail() {
    return SingleChildScrollView(
      child: Column(
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
                    displayColumn("募集人数", "$countApplyPeople/${jobPosting?.numberOfRecruit}"),
                  ],
                ),
                AppSize.spaceHeight16,
                divider(),
                AppSize.spaceHeight16,
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: applicantList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var job = applicantList[index];
                      var dateList = job.shiftList!.map((e) => e.date).toList();
                      return job.myUser == null || !dateList.contains(widget.date)
                          ? const SizedBox()
                          : SizedBox(
                              height: 50,
                              width: AppSize.getDeviceWidth(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        color: AppColor.whiteColor,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  AppSize.spaceWidth16,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.userName ?? "",
                                        style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                                        overflow: TextOverflow.fade,
                                      ),
                                      AppSize.spaceWidth5,
                                      job.userId != null
                                          ? const SizedBox()
                                          : Icon(
                                              Icons.star,
                                              color: AppColor.primaryColor,
                                            )
                                    ],
                                  ),
                                  AppSize.spaceWidth16,
                                  job.myUser?.dob != null
                                      ? Text(
                                          calculateAge(DateToAPIHelper.fromApiToLocal(job.myUser!.dob!.replaceAll("-", "/").toString())) +
                                              "   ${job.myUser?.gender ?? "データなし"}",
                                          style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                                          overflow: TextOverflow.fade,
                                        )
                                      : Text(
                                          job.myUser?.gender ?? "データなし",
                                          style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                                          overflow: TextOverflow.fade,
                                        ),
                                  AppSize.spaceWidth16,
                                  AppSize.spaceWidth16,
                                  StatusHelper().displayStatus(job.status)
                                ],
                              ),
                            );
                    })
              ],
            ),
          )
        ],
      ),
    );
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
      width: AppSize.getDeviceHeight(context) * 0.8,
      height: 0.5,
      color: AppColor.secondaryColor,
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
