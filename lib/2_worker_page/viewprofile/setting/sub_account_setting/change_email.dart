import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/custom_back_button.dart';

class ChangeEmailPage extends StatefulWidget {
  final MyUser? myUser;
  const ChangeEmailPage({super.key, this.myUser});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('メールアドレス変更'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: AppSize.getDeviceWidth(context),
          padding: const EdgeInsets.all(16),
          decoration: boxDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSize.spaceHeight16,
              const Divider(),
              menuItem(title: "メールアドレス", val: widget.myUser?.email ?? "", onTap: () {}),
              const Divider(),
              menuItem(title: "パスワード", val: "********", onTap: () {}),
              const Divider(),
              AppSize.spaceHeight16,
            ],
          ),
        ),
      ),
    );
  }

  menuItem({required String title, required String val, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              title,
              style: kNormalText.copyWith(fontSize: 16),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  val,
                  style: kNormalText.copyWith(fontSize: 12),
                ),
                AppSize.spaceWidth8,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.primaryColor,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
