import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/worker_page/manage/filter/reward.dart';
import 'package:air_job_management/worker_page/manage/filter/treatment.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_button.dart';
import 'flat_time.dart';
import 'occupation.dart';

class FilterOption extends StatefulWidget {
  const FilterOption({super.key});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: const Text('絞り込み'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            menu('職種', () {
              MyPageRoute.goTo(context, const Occupation());
            }),
            menu('報酬', () {
              MyPageRoute.goTo(context, const RadioExample());
            }),
            menu('時間帯', () {
              MyPageRoute.goTo(context, const FlatTime());
            }),
            menu('待遇', () {
              MyPageRoute.goTo(context, const Treatment());
            }),
            const Spacer(),
            Center(
              child: ButtonWidget(
                color: AppColor.primaryColor,
                title: '検索する',
                onPress: () {},
              ),
            ),
            AppSize.spaceHeight30
          ],
        ),
      ),
    );
  }

  Widget menu(String text, void Function()? onTap) {
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
            width: 80,
            child: Row(
              children: [
                Text(
                  "すべて",
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
