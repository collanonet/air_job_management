import 'package:air_job_management/const/status.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobPostingCardWidget extends StatelessWidget {
  final JobPosting jobPosting;
  final bool? fromSeekerPage;
  const JobPostingCardWidget(
      {Key? key, required this.jobPosting, this.fromSeekerPage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime endDate = MyDateTimeUtils.fromApiToLocal(
        jobPosting.endDate ?? jobPosting.startDate!);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColor.primaryColor),
          borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (fromSeekerPage == true) {
              toastMessageSuccess(
                  "We are going to implement update job status soon!", context);
            } else {
              context.go("${MyRoute.job}/${jobPosting.uid}",
                  extra: jobPosting.form);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primaryColor),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.folder_copy_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      AppSize.spaceWidth5,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jobPosting.workCatchPhrase ??
                                  jobPosting.title ??
                                  "",
                              style: normalTextStyle.copyWith(
                                  fontSize: 13, color: AppColor.primaryColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            AppSize.spaceHeight5,
                            Text(
                              jobPosting.company ?? JapaneseText.empty,
                              style: normalTextStyle.copyWith(fontSize: 12),
                            ),
                            AppSize.spaceHeight5,
                            Text(
                              "${jobPosting.startDate} ~ ${jobPosting.endDate}",
                              style: normalTextStyle.copyWith(
                                  fontSize: 11, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      AppSize.spaceWidth5,
                    ],
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Text("${jobPosting.location?.name}",
                      style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                      jobPosting.employmentType ??
                          JapaneseText.fullTimeEmployee,
                      style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 2,
                ),
                Expanded(
                  child: Text(jobPosting.numberOfRecruit ?? "1",
                      style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 2,
                ),
                Expanded(
                  child: StatusUtils.displayStatusForJobPosting(
                      endDate.isBefore(now)
                          ? JapaneseText.end
                          : JapaneseText.duringCorrespondence),
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
