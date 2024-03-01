import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/splash_page.dart';
import '../../utils/app_color.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: AppSize.getDeviceWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSize.spaceHeight30,
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/svgs/img.png')),
            AppSize.spaceHeight50,
            GestureDetector(
              onTap: () {
                // MyPageRoute.goTo(
                //     context, const RegisterPage(isFullTime: false));
                // MyPageRoute.goTo(
                //     context, const RootPage("", isFullTime: false));
                isFullTime = false;
                context.go(MyRoute.workerJobSearchPartTime);
              },
              child: Container(
                width: 300,
                height: 114,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'すぐ働ける仕事を探す',
                    style: normalTextStyle.copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            AppSize.spaceHeight30,
            GestureDetector(
              onTap: () {
                // MyPageRoute.goTo(context, const RegisterPage(isFullTime: true));
                // MyPageRoute.goTo(context, const RootPage("", isFullTime: true));
                isFullTime = true;
                context.go(MyRoute.workerJobSearchFullTime);
              },
              child: Container(
                width: 300,
                height: 114,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'じっくり仕事を探す',
                    style: normalTextStyle.copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
