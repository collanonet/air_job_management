import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';

import '../../../models/job_posting.dart';
import '../../../utils/style.dart';

class ShiftFrameCardWidget extends StatelessWidget {
  final JobPosting jobPosting;
  final JobPosting? selectJob;
  final Function onClick;
  const ShiftFrameCardWidget({super.key, required this.jobPosting, required this.onClick, this.selectJob});

  @override
  Widget build(BuildContext context) {
    bool isExpired = false;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    DateTime endDate = DateToAPIHelper.fromApiToLocal(jobPosting.endDate!);
    if (endDate.isBefore(today) && today != endDate) {
      isExpired = true;
    }
    return Container(
      height: 110,
      width: AppSize.getDeviceWidth(context),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0),
      decoration: BoxDecoration(
          color: selectJob?.uid == jobPosting.uid ? Colors.orange.withOpacity(0.1) : Colors.transparent,
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
              flex: 3,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${jobPosting.startDate} - ${jobPosting.endDate}\n${jobPosting.startTimeHour} - ${jobPosting.endTimeHour} ",
                  style: kTitleText.copyWith(color: AppColor.darkGrey, fontSize: 16, fontFamily: "Normal"),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: Text(
                  jobPosting.numberOfRecruit ?? "",
                  style: kTitleText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${jobPosting.applyCount ?? ""}",
                  style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Container(
                width: 100,
                height: 36,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25), color: isExpired ? AppColor.endColor : AppColor.duringCorrespondingColor),
                child: Center(
                  child: Text(
                    isExpired ? "終了" : "掲載中",
                    style: kTitleText.copyWith(color: AppColor.whiteColor, fontSize: 16),
                    overflow: TextOverflow.fade,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
