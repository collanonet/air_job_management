import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateSeekerOrDownloadListWidget extends StatelessWidget {
  final BuildContext context2;
  const CreateSeekerOrDownloadListWidget({super.key, required this.context2});

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
                title: JapaneseText.createJobSeeker,
                color: AppColor.primaryColor,
                onPress: () {
                  context2.go(MyRoute.createJobSeeker);
                }),
            AppSize.spaceWidth16,
            ButtonWidget(
                title: JapaneseText.downloadSeekerList,
                color: AppColor.primaryColor,
                onPress: () {
                  toastMessageSuccess("We are going to implement this function, currently not yet available", context);
                }),
          ],
        ),
      ),
    );
  }
}
