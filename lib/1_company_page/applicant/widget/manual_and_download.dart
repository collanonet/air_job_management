import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class ManualAndDownloadApplicantWidget extends StatelessWidget {
  const ManualAndDownloadApplicantWidget({super.key});

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
            SizedBox(width: 130, child: ButtonWidget(radius: 25, title: "手動登録", color: AppColor.primaryColor, onPress: () {})),
            AppSize.spaceWidth16,
            SizedBox(
              width: 230,
              child: ButtonWidget(radius: 25, title: "応募一覧をダウンロード", color: AppColor.primaryColor, onPress: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
