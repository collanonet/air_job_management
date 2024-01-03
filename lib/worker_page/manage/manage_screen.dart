import 'package:air_job_management/pages/register/register.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

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
            Image.asset('assets/svgs/img.png'),
            AppSize.spaceHeight50,
            GestureDetector(
              onTap: () {
                MyPageRoute.goTo(
                    context, const RegisterPage(isFullTime: false));
              },
              child: Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'すぐ働ける仕事を探す',
                    style: normalTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            AppSize.spaceHeight30,
            GestureDetector(
              onTap: () {
                MyPageRoute.goTo(context, const RegisterPage(isFullTime: true));
              },
              child: Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'じっくり仕事を探す',
                    style: normalTextStyle.copyWith(color: Colors.white),
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
