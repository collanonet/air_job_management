import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/register/widget/select_box_tile.dart';
import '../../../providers/worker/filter.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class Treatment extends StatefulWidget {
  const Treatment({super.key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  List<String> selected = [];
  late WorkerFilter provider;

  @override
  void initState() {
    selected = Provider.of<WorkerFilter>(context, listen: false).selectedTreatment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WorkerFilter>(context);
    return Scaffold(
      appBar: AppBar(leadingWidth: 100, leading: const CustomBackButtonWidget(), backgroundColor: AppColor.primaryColor, title: const Text('待遇')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              buildItem('未経験歓迎'),
              buildItem('まかないあり'),
            ],
          ),
          Row(
            children: [
              buildItem('服装自由'),
              buildItem('髪型/ヘアカラー自由'),
            ],
          ),
          Row(
            children: [
              buildItem('交通費支給'),
              buildItem('バイク/車通勤可'),
            ],
          ),
          Row(
            children: [
              buildItem('自転車通勤可'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context) - 32,
              child: ButtonWidget(
                color: AppColor.secondaryColor,
                title: 'OK',
                onPress: () {
                  provider.onChangeTreatment(selected);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
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
