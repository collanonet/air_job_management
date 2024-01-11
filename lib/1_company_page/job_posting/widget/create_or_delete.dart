import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class CreateOrDeleteJobPostingForCompany extends StatelessWidget {
  const CreateOrDeleteJobPostingForCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            ButtonWidget(
                radius: 25,
                title: "新規登録",
                color: AppColor.primaryColor,
                onPress: () {}),
            AppSize.spaceWidth16,
            ButtonWidget(
                radius: 25,
                title: "コピーして作成",
                color: AppColor.primaryColor,
                onPress: () {}),
          ],
        ),
      ),
    );
  }
}
