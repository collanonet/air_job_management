import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/job_posting.dart';
import '../../../utils/style.dart';

class JobPostingCardForCompanyWidget extends StatelessWidget {
  final JobPosting jobPosting;
  const JobPostingCardForCompanyWidget({super.key, required this.jobPosting});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: AppSize.getDeviceWidth(context),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: AppColor.primaryColor)),
      child: InkWell(
        onTap: () => context.go("/company/job-posting/${jobPosting.uid}"),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColor.primaryColor),
                    child: Center(
                      child: Icon(
                        Icons.folder_rounded,
                        color: AppColor.whiteColor,
                        size: 22,
                      ),
                    ),
                  ),
                  AppSize.spaceWidth16,
                  Expanded(
                    child: Text(
                      jobPosting.title ?? "",
                      style: kTitleText.copyWith(
                          color: AppColor.primaryColor, fontSize: 16),
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              flex: 4,
            ),
            Expanded(
              child: Center(
                child: Text(
                  jobPosting.occupationType ?? "",
                  style: kTitleText.copyWith(
                      color: AppColor.primaryColor, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Container(
                width: 180,
                height: 36,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColor.primaryColor),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        context.go("/company/job-posting/${jobPosting.uid}"),
                    borderRadius: BorderRadius.circular(25),
                    child: Center(
                      child: Text(
                        "シフト枠を作成する",
                        style: kTitleText.copyWith(
                            color: AppColor.whiteColor, fontSize: 16),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
