import 'package:air_job_management/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/japan_date_time.dart';
import '../../../providers/company/entry_exit_history.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_choose_date_or_time.dart';
import '../../../widgets/custom_dropdown_string.dart';

class FilterEntryExitList extends StatelessWidget {
  final Function onRefreshData;
  const FilterEntryExitList({super.key, required this.onRefreshData});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EntryExitHistoryProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      // height: 80,
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ワーカーの入退出履歴",
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
                    "役職",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                      radius: 5,
                      width: AppSize.getDeviceWidth(context) * 0.3,
                      selectItem: provider.selectedJobTitle,
                      list: provider.jobTitleList,
                      onChange: (v) => provider.onChangeTitle(v, auth.branch?.id ?? ""))
                ],
              ),
              AppSize.spaceWidth32,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "スタッフ",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  CustomDropDownWidget(
                      radius: 5,
                      width: AppSize.getDeviceWidth(context) * 0.1,
                      selectItem: provider.selectedUsernameForEntryExit,
                      list: provider.usernameListForEntryExit,
                      onChange: (v) => provider.onChangeUsernameForEntryExit(v, auth.branch?.id ?? ""))
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
                        provider.onChangeStartDate(date, auth.branch?.id ?? "");
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
                        provider.onChangeEndDate(date, auth.branch?.id ?? "");
                      }
                    },
                    val: provider.endWorkDate != null ? toJapanDateWithoutWeekDay(provider.endWorkDate!) : "",
                    isHaveIcon: true,
                  ),
                ],
              ),
              AppSize.spaceWidth32,
              Padding(padding: const EdgeInsets.only(top: 20), child: IconButton(onPressed: () => onRefreshData(), icon: const Icon(Icons.refresh)))
            ],
          ),
        ],
      ),
    );
  }
}
