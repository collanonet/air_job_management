import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/app_color.dart';
import '../../../utils/respnsive.dart';
import '../../../widgets/custom_back_button.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('通知'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: AppSize.getDeviceWidth(context),
              decoration: boxDecoration,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.6 : 0.25),
                  ),
                  Icon(
                    Icons.notifications_none_rounded,
                    size: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.2 : 0.1),
                    color: AppColor.primaryColor,
                  ),
                  AppSize.spaceHeight30,
                  Text("エアジョブから通知を受け取るには、通知を許可してください。",
                      textAlign: TextAlign.center, style: kNormalText.copyWith(fontSize: 16, fontFamily: "Bold", color: AppColor.darkGrey))
                ],
              ),
            ),
            AppSize.spaceHeight30,
            Center(
              child: SizedBox(
                width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.8 : 0.25),
                child: ButtonWidget(
                  title: "通知を許可する",
                  onPress: () async {
                    if (await Permission.notification.request().isGranted) {
                      toastMessageSuccess("通知パーミッションが有効", context);
                    } else {
                      toastMessageError("通知権限が無効", context);
                    }
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
}
