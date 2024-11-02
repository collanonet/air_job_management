import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/helper/status_helper.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../job_posting/create_or_edit_job_posting.dart';
import '../../woker_management/widget/job_card.dart';
import '../applicant_root.dart';

class ApplicantCardWidget extends StatelessWidget {
  final WorkerManagement job;
  const ApplicantCardWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkerManagementProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
      margin: const EdgeInsets.only(bottom: 4, left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(width: 1, color: AppColor.primaryColor)),
      child: InkWell(
        onTap: () {
          // provider.setJob = job;
          // context.go("/company/applicant/${job.uid}");
        },
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
                    child: InkWell(
                      onTap: () {
                        if (job.userId != null) {
                          provider.setJob = job;
                          // context.go("/company/worker-management/${job.uid}");
                          context.go("/company/applicant/${job.uid}");
                        } else {
                          context.go("/company/worker-management/outside-worker/${job.uid}");
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            Expanded(
                              child: Text(
                                (job.myUser?.nameKanJi != null && job.myUser?.nameKanJi != "") ? "${job.myUser?.nameKanJi}" : JapaneseText.empty,
                                style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            AppSize.spaceWidth5,
                            job.userId != null
                                ? const SizedBox()
                                : Icon(
                                    Icons.star,
                                    color: AppColor.primaryColor,
                                  )
                          ]),
                          Text(
                            calculateAge(DateToAPIHelper.fromApiToLocal(job.myUser!.dob!.replaceAll("-", "/").toString())) +
                                "   ${job.myUser?.gender == null || job.myUser?.gender == "" ? JapaneseText.empty : job.myUser?.gender}",
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 14),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: provider.selectedJobStatus == JapaneseText.all
                      ? StatusHelper().displayStatus(job.shiftList!.map((e) => e.status).toString())
                      : StatusHelper().displayStatus(StatusHelper.japanToEnglish(provider.selectedJobStatus).toString()),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: CreateOrEditJobPostingPageForCompany(
                            isView: true,
                            jobPosting: job.jobId,
                          ),
                        )),
                child: Center(
                  child: Text(
                    "${job.jobTitle}",
                    style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "  ${toJapanDateTime(job.createdDate ?? DateTime.now())}",
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 14),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "      ${countWorkingHistory(job.userId.toString())}回",
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 14),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  job.shiftList!.length > 1
                      ? DateToAPIHelper.convertDateToString(job.shiftList!.first.date!) +
                          " ~ " +
                          DateToAPIHelper.convertDateToString(job.shiftList!.last.date!)
                      : DateToAPIHelper.convertDateToString(job.shiftList!.first.date!),
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 14),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

countWorkingHistory(String id) {
  int i = 0;
  for (var entry in entryForApplicant) {
    if (entry.userId == id && entry.endWorkDate != null && entry.endWorkDate != "") {
      i++;
    }
  }
  return i.toString();
}
