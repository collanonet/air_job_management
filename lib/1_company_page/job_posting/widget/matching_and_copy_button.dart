import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class MatchingAndCopyButtonWidget extends StatelessWidget {
  final Function onAdd;
  const MatchingAndCopyButtonWidget({super.key, required this.onAdd});

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
            SizedBox(width: 180, child: ButtonWidget(radius: 25, title: "手動マッチング", color: AppColor.primaryColor, onPress: () => onAdd())),
            AppSize.spaceWidth16,
            SizedBox(
              width: 180,
              child: ButtonWidget(radius: 25, title: "コピーして作成", color: AppColor.primaryColor, onPress: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
