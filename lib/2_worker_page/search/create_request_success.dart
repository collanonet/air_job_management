import 'package:air_job_management/utils/my_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/respnsive.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';

class CreateJobRequestSuccessPage extends StatelessWidget {
  const CreateJobRequestSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: AppSize.getDeviceWidth(context) * 0.95,
        height: AppSize.getDeviceHeight(context) * 0.96,
        padding: const EdgeInsets.all(32),
        color: AppColor.bgPageColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => context.go(MyRoute.workerJobSearchPartTime),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColor.primaryColor,
                      )),
                  Expanded(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "応募完了",
                        style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                      ),
                    ),
                  ))
                ],
              ),
              AppSize.spaceHeight16,
              Container(
                width: AppSize.getDeviceWidth(context),
                decoration: boxDecoration,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
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
                    Text("お仕事の応募が完了しました。 結果までしばらくお待ちください。",
                        textAlign: TextAlign.center, style: kNormalText.copyWith(fontSize: 16, fontFamily: "Regular", color: AppColor.darkGrey))
                  ],
                ),
              ),
              AppSize.spaceHeight30,
              Center(
                child: SizedBox(
                  width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.8 : 0.25),
                  child: ButtonWidget(
                    title: "他のお仕事を見る",
                    onPress: () => context.go(MyRoute.workerJobSearchPartTime),
                    radius: 5,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
              //Test
              AppSize.spaceHeight16,
            ],
          ),
        ),
      ),
    );
  }
}
