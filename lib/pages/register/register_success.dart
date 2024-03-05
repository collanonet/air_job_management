import 'package:air_job_management/utils/my_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/respnsive.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';

class RegisterSuccessPage extends StatefulWidget {
  final bool isFullTime;
  const RegisterSuccessPage({super.key, required this.isFullTime});

  @override
  State<RegisterSuccessPage> createState() => _RegisterSuccessPageState();
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.bgPageColor,
        centerTitle: true,
        leadingWidth: 100,
        elevation: 0,
        title: Text(
          '登録完了',
          style: kNormalText.copyWith(color: AppColor.primaryColor),
        ),
        leading: const SizedBox(),
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
                  // Icon(
                  //   Icons.location_on_outlined,
                  //   size: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.2 : 0.1),
                  //   color: AppColor.primaryColor,
                  // ),
                  AppSize.spaceHeight30,
                  AppSize.spaceHeight30,
                  Text("登録完了しました",
                      textAlign: TextAlign.center, style: kNormalText.copyWith(fontSize: 16, fontFamily: "Bold", color: AppColor.darkGrey))
                ],
              ),
            ),
            AppSize.spaceHeight30,
            Center(
              child: SizedBox(
                width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.8 : 0.25),
                child: ButtonWidget(
                  title: "応募画面に戻る",
                  onPress: () async {
                    if (widget.isFullTime) {
                      context.go(MyRoute.workerJobSearchFullTime);
                    } else {
                      context.go(MyRoute.workerJobSearchPartTime);
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
