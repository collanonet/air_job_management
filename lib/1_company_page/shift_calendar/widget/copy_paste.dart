import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class CopyPasteShiftCalendarWidget extends StatelessWidget {
  final Function onClick;
  const CopyPasteShiftCalendarWidget({super.key, required this.onClick});

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
            const SizedBox(),
            AppSize.spaceWidth16,
            SizedBox(
              width: 230,
              child: ButtonWidget(radius: 25, title: "コピーして作成", color: AppColor.primaryColor, onPress: () => onClick()),
            ),
          ],
        ),
      ),
    );
  }
}
