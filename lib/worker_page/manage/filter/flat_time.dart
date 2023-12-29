import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/worker/filter.dart';

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
          backgroundColor: AppColor.primaryColor, title: const Text('時間帯')),
      body: Column(
        children: [
          Column(
            children: [
              item('午前中'),
              item('12時−14時'),
              item('14時−16時'),
              item('16時−18時'),
              item('18時−20時'),
              item('20時−22時'),
              item('深夜'),
              item('早朝')
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: ButtonWidget(
              color: AppColor.primaryColor,
              title: 'OK',
              onPress: () {
                provider.onChangeRangeTime(selected);
                Navigator.pop(context);
              },
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
                '午前中',
                '12時−14時',
                '14時−16時',
                '16時−18時',
                '18時−20時',
                '20時−22時',
                '深夜',
                '早朝'
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
