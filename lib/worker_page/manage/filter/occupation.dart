import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_button.dart';

class Occupation extends StatefulWidget {
  const Occupation({super.key});

  @override
  State<Occupation> createState() => _OccupationState();
}

class _OccupationState extends State<Occupation> {
  bool isChecked = false;
  final notification = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
            child: ButtonWidget(
              color: AppColor.primaryColor,
              title: 'OK',
              onPress: () {},
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
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}
