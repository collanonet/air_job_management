import 'package:air_job_management/providers/worker/filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class Occupation extends StatefulWidget {
  const Occupation({super.key});

  @override
  State<Occupation> createState() => _OccupationState();
}

class _OccupationState extends State<Occupation> {
  bool isChecked = false;
  List<String> selected = [];
  late WorkerFilter provider;

  @override
  void initState() {
    selected =
        Provider.of<WorkerFilter>(context, listen: false).selectedOccupation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WorkerFilter>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        leading: const CustomBackButtonWidget(),
        title: const Text('職種'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              item('すべて'),
              item('軽作業'),
              item('配達・運転'),
              item('販売'),
              item('飲食'),
              item('オフィスワーク'),
              item('イベント・キャンペーン'),
              item('専門職'),
              item('接客'),
              item('エンタメ'),
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
                  provider.onChangeOccupation(selected);
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
          if (title == 'すべて') {
            if (title == 'すべて' &&
                selected.length == provider.occupationList.length) {
              selected = [];
            } else {
              selected = [
                'すべて',
                '軽作業',
                '配達・運転',
                '販売',
                '飲食',
                'オフィスワーク',
                'イベント・キャンペーン',
                '専門職',
                '接客',
                'エンタメ',
              ];
            }
          } else {
            if (selected.contains("すべて")) {
              selected.remove("すべて");
            }
            if (selected.contains(title)) {
              selected.remove(title);
            } else {
              selected.add(title);
            }
          }

          setState(() {});
        },
      ),
    );
  }
}
