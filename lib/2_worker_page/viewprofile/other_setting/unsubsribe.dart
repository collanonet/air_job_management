import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/respnsive.dart';
import '../../../utils/style.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class UnsubscribePage extends StatefulWidget {
  const UnsubscribePage({super.key});

  @override
  State<UnsubscribePage> createState() => _UnsubscribePageState();
}

class _UnsubscribePageState extends State<UnsubscribePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('退会手続き'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
                width: AppSize.getDeviceWidth(context),
                decoration: boxDecoration,
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("よろしければ退会理由を教えてください。", style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal", color: AppColor.darkGrey)),
                      AppSize.spaceHeight30,
                      item("退会理由１"),
                      item("退会理由2"),
                      item("退会理由3"),
                      item("退会理由4"),
                      item("退会理由5"),
                      item("退会理由6"),
                    ],
                  ),
                )),
            AppSize.spaceHeight30,
            Center(
              child: SizedBox(
                width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.8 : 0.25),
                child: ButtonWidget(
                  title: "つぎへ",
                  onPress: () async {
                    toastMessageSuccess(JapaneseText.successUpdate, context);
                  },
                  radius: 5,
                  color: AppColor.secondaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> selected = [];

  Widget item(String title) {
    return Card(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColor.secondaryColor,
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
