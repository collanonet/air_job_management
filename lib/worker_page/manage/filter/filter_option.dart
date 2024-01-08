import 'package:air_job_management/providers/worker/filter.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/worker_page/manage/filter/reward.dart';
import 'package:air_job_management/worker_page/manage/filter/treatment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';
import 'flat_time.dart';
import 'occupation.dart';

class FilterOption extends StatefulWidget {
  const FilterOption({super.key});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  late WorkerFilter workerFilter;

  @override
  Widget build(BuildContext context) {
    workerFilter = Provider.of<WorkerFilter>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('絞り込み'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => workerFilter.onClearFilter(),
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 1, color: AppColor.primaryColor)),
                      alignment: Alignment.center,
                      child: Text(
                        "リセット",
                        style:
                            kNormalText.copyWith(color: AppColor.primaryColor),
                      )),
                ),
              ),
            ),
            menu('職種', () {
              MyPageRoute.goTo(context, const Occupation());
            },
                workerFilter.selectedOccupation.isEmpty ||
                        workerFilter.selectedOccupation.length ==
                            workerFilter.occupationList.length
                    ? "すべて"
                    : workerFilter.selectedOccupation.map((e) => e).toString()),
            menu('報酬', () {
              MyPageRoute.goTo(context, const RadioExample());
            }, workerFilter.selectedReward ?? "指定なし"),
            menu('時間帯', () {
              MyPageRoute.goTo(context, const FlatTime());
            },
                workerFilter.selectedRangeTime.isEmpty
                    ? "指定なし"
                    : workerFilter.selectedRangeTime.map((e) => e).toString()),
            menu('待遇', () {
              MyPageRoute.goTo(context, const Treatment());
            },
                workerFilter.selectedTreatment.isEmpty
                    ? "指定なし"
                    : workerFilter.selectedTreatment.map((e) => e).toString()),
            const Spacer(),
            Center(
              child: SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: ButtonWidget(
                  color: AppColor.primaryColor,
                  title: '検索する',
                  onPress: () => Navigator.pop(context),
                ),
              ),
            ),
            AppSize.spaceHeight30
          ],
        ),
      ),
    );
  }

  Widget menu(String text, void Function()? onTap, String selection) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            text,
            style: normalTextStyle,
          ),
          trailing: SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  selection,
                  style: normalTextStyle,
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
