import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';

class JobApplyCardWidget extends StatelessWidget {
  final WorkerManagement job;
  const JobApplyCardWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkerManagementProvider>(context);
    return Container(
      height: 110,
      width: AppSize.getDeviceWidth(context),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
      margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(width: 1, color: AppColor.primaryColor)),
      child: InkWell(
        onTap: () {
          if (job.userId != null) {
            provider.setJob = job;
            context.go("/company/worker-management/${job.uid}");
          } else {
            context.go("/company/worker-management/outside-worker/${job.uid}");
          }
        },
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
                        Icons.person,
                        color: AppColor.whiteColor,
                        size: 35,
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
                            Text(
                              job.userName ?? "",
                              style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                              overflow: TextOverflow.fade,
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
                          style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
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
                    calculateAge(DateToAPIHelper.fromApiToLocal(job.myUser!.dob!.replaceAll("-", "/").toString())) + "   ${job.myUser?.gender}",
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
                  job.shiftList!.length > 1
                      ? DateToAPIHelper.convertDateToString(job.shiftList!.first.date!) +
                          " ~ " +
                          DateToAPIHelper.convertDateToString(job.shiftList!.last.date!)
                      : DateToAPIHelper.convertDateToString(job.shiftList!.first.date!),
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
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
          ],
        ),
      ),
    );
  }
}

String calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString() + "歳";
}
