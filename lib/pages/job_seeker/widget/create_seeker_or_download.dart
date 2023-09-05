import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CreateSeekerOrDownloadListWidget extends StatelessWidget {
  const CreateSeekerOrDownloadListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spacer(),
            ButtonWidget(
                title: "手動登録", color: AppColor.primaryColor, onPress: () {}),
            AppSize.spaceWidth16,
            ButtonWidget(
                title: "応募一覧をダウンロード",
                color: AppColor.primaryColor,
                onPress: () {}),
          ],
        ),
      ),
    );
  }
}
