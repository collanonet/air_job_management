import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/worker/filter.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/custom_button.dart';

enum SingingCharacter { a, b, c, d }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  late WorkerFilter provider;
  String? selected;

  @override
  void initState() {
    selected = Provider.of<WorkerFilter>(context, listen: false).selectedReward;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WorkerFilter>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: const Text('報酬'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.rewardList.length,
                itemBuilder: (context, index) {
                  String value = provider.rewardList[index];
                  return data(context, value);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: ButtonWidget(
                color: AppColor.primaryColor,
                title: 'OK',
                onPress: () {
                  provider.onChangeReward(selected);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget data(BuildContext context, var value) {
    return ListTile(
      onTap: () {
        setState(() {
          selected = value;
        });
      },
      title: Text(value),
      leading: Radio<String?>(
        value: value,
        groupValue: selected,
        activeColor: AppColor.primaryColor,
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        },
      ),
    );
  }
}
