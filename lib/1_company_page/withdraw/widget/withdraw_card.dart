import 'package:air_job_management/helper/currency_format.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/widthraw.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_button.dart';

class WithdrawCardWidget extends StatelessWidget {
  final WithdrawModel withdrawModel;
  final Function onApprove;
  final Function onReject;
  final Function onUserTap;
  const WithdrawCardWidget({super.key, required this.onUserTap, required this.withdrawModel, required this.onApprove, required this.onReject});

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
              child: InkWell(
                onTap: () => onUserTap(withdrawModel.workerID),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        withdrawModel.workerName == "" ? JapaneseText.empty : withdrawModel.workerName.toString(),
                        style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: Text(
                  CurrencyFormatHelper.displayData(withdrawModel.amount.toString()),
                  style: kNormalText.copyWith(fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${toJapanDateTime(withdrawModel.createdAt!)}",
                  style: kNormalText.copyWith(fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${withdrawModel.bankModel?.bankId}",
                  style: kNormalText.copyWith(fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${withdrawModel.bankModel?.fullName}",
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${CommonUtils.statusFromApiToLocal(withdrawModel.status!)}",
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  withdrawModel.reason ?? "",
                  style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                  overflow: TextOverflow.fade,
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: ButtonWidget(
                      radius: 25,
                      color: withdrawModel.status == "approved" ? AppColor.primaryColor : AppColor.whiteColor,
                      title: "承認",
                      onPress: () => onApprove(),
                    ),
                  ),
                  AppSize.spaceWidth16,
                  SizedBox(
                    width: 100,
                    child: ButtonWidget(
                      radius: 25,
                      color: withdrawModel.status == "rejected" ? AppColor.primaryColor : AppColor.whiteColor,
                      title: "拒否",
                      onPress: () => onReject(),
                    ),
                  )
                ],
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
