import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/job_posting.dart';
import '../../../utils/style.dart';

class JobPostingCardForCompanyWidget extends StatelessWidget {
  final JobPosting jobPosting;
  final JobPosting? selectedJobPosting;
  final Function onClick;
  const JobPostingCardForCompanyWidget({super.key, required this.jobPosting, required this.selectedJobPosting, required this.onClick});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Container(
      height: 110,
      width: AppSize.getDeviceWidth(context),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0),
      decoration: BoxDecoration(
          color: selectedJobPosting == jobPosting ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: AppColor.primaryColor)),
      child: InkWell(
        onTap: () => onClick(),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
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
                      style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
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
                  jobPosting.majorOccupation ?? "",
                  style: kTitleText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Container(
                width: 190,
                height: 36,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      provider.onChangeSelectMenu(provider.tabMenu[0]);
                      context.go("/company/job-posting/${jobPosting.uid}");
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Center(
                      child: Text(
                        "シフト枠を作成する",
                        style: kTitleText.copyWith(color: AppColor.whiteColor, fontSize: 13),
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
