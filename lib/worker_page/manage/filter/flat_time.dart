import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/register/widget/select_box_tile.dart';
import '../../../providers/worker/filter.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_back_button.dart';

class FlatTime extends StatefulWidget {
  const FlatTime({super.key});

  @override
  State<FlatTime> createState() => _FlatTimeState();
}

class _FlatTimeState extends State<FlatTime> {
  List<String> selected = [];
  late WorkerFilter provider;

  @override
  void initState() {
    selected =
        Provider.of<WorkerFilter>(context, listen: false).selectedRangeTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WorkerFilter>(context);
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 100,
          leading: const CustomBackButtonWidget(),
          backgroundColor: AppColor.primaryColor,
          title: const Text('時間帯')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.25,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.rangeTime.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildItem(provider.rangeTime[index]);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: SizedBox(
                width: AppSize.getDeviceWidth(context),
                child: ButtonWidget(
                  color: AppColor.secondaryColor,
                  title: 'OK',
                  onPress: () {
                    provider.onChangeRangeTime(selected);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: SelectBoxListTileWidget(
          size: AppSize.getDeviceWidth(context) * 0.25,
          title: item,
          val: selected.contains(item),
          onChange: (v) {
            if (selected.contains(item)) {
              setState(() {
                selected.remove(item);
              });
            } else {
              setState(() {
                selected.add(item);
              });
            }
          }),
    );
  }
}
