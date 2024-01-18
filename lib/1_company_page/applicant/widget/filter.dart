import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/japan_date_time.dart';
import '../../../utils/app_color.dart';
import '../../../utils/japanese_text.dart';
import '../../../widgets/custom_choose_date_or_time.dart';

class ApplicantFilterDataWidgetForCompany extends StatelessWidget {
  ApplicantFilterDataWidgetForCompany({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkerManagementProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "応募者検索",
            style: titleStyle,
          ),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "対応状況",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                      radius: 5,
                      width: 180,
                      selectItem: provider.selectedJobStatus,
                      list: provider.jobStatus,
                      onChange: (v) => provider.onChangeJobStatus(v))
                ],
              ),
              AppSize.spaceWidth32,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "求人タイトル",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                      radius: 5,
                      width: AppSize.getDeviceWidth(context) * 0.3,
                      selectItem: provider.selectedJobTitle,
                      list: provider.jobTitleList,
                      onChange: (v) => provider.onChangeTitle(v))
                ],
              ),
              AppSize.spaceWidth32,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomChooseDateOrTimeWidget(
                    width: 150,
                    title: "稼働日　開始",
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: provider.startWorkDate ?? DateTime.now(),
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        provider.onChangeStartDate(date);
                      }
                    },
                    val: provider.startWorkDate != null ? toJapanDateWithoutWeekDay(provider.startWorkDate!) : "",
                    isHaveIcon: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: Text(
                      " 〜 ",
                      style: kTitleText.copyWith(fontSize: 16, color: AppColor.thirdColor, fontFamily: "Normal"),
                    ),
                  ),
                  CustomChooseDateOrTimeWidget(
                    width: 150,
                    title: JapaneseText.endWorkingDay,
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: provider.endWorkDate ?? DateTime.now(),
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        provider.onChangeEndDate(date);
                      }
                    },
                    val: provider.endWorkDate != null ? toJapanDateWithoutWeekDay(provider.endWorkDate!) : "",
                    isHaveIcon: true,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
