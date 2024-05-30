import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/withdraw.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/japan_date_time.dart';
import '../../../utils/app_color.dart';
import '../../../utils/japanese_text.dart';
import '../../../widgets/custom_choose_date_or_time.dart';

class WithdrawFilterWidget extends StatelessWidget {
  const WithdrawFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WithdrawProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "検索を取り消す",
            style: titleStyle,
          ),
          AppSize.spaceHeight8,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "求職者名",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                      radius: 5,
                      width: AppSize.getDeviceWidth(context) * 0.3,
                      selectItem: provider.selectUser,
                      list: provider.userList,
                      onChange: (v) => provider.onChangeUser(v, auth.branch?.id ?? ""))
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
                          initialDate: provider.startDate ?? DateTime.now(),
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        provider.onChangeStartDate(date, auth.branch?.id ?? "");
                      }
                    },
                    val: provider.startDate != null ? toJapanDateWithoutWeekDay(provider.startDate!) : "",
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
                          initialDate: provider.endDate ?? DateTime.now(),
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        provider.onChangeEndDate(date, auth.branch?.id ?? "");
                      }
                    },
                    val: provider.endDate != null ? toJapanDateWithoutWeekDay(provider.endDate!) : "",
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
