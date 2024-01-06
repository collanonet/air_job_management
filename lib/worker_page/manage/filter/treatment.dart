import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    selected =
        Provider.of<WorkerFilter>(context, listen: false).selectedTreatment;
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
      body: Column(
        children: [
          Column(
            children: [
              item('未経験歓迎'),
              item('まかないあり'),
              item('服装自由'),
              item('髪型/ヘアカラー自由'),
              item('交通費支給'),
              item('バイク/車通勤可'),
              item('自転車通勤可'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SizedBox(
              width: AppSize.getDeviceWidth(context),
              child: ButtonWidget(
                color: AppColor.primaryColor,
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

  Widget item(String title) {
    return Card(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.red,
        checkColor: Colors.white,
        title: Text(title),
        value: selected.contains(title),
        onChanged: (bool? value) {
          if (selected.contains(title)) {
            selected.remove(title);
          } else {
            selected.add(title);
          }

          setState(() {});
        },
      ),
    );
  }
}
