import 'package:air_job_management/2_worker_page/viewprofile/setting/sub_account_setting/change_email.dart';
import 'package:air_job_management/2_worker_page/viewprofile/setting/sub_account_setting/change_password.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/page_route.dart';
import '../../../widgets/custom_back_button.dart';

class AccountSettingPage extends StatefulWidget {
  final MyUser? myUser;
  const AccountSettingPage({super.key, this.myUser});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('アカウント設定'),
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
              menuItem(
                  title: "メールアドレス",
                  val: widget.myUser?.email ?? "",
                  onTap: () => MyPageRoute.goTo(
                      context,
                      ChangeEmailPage(
                        myUser: widget.myUser,
                      ))),
              const Divider(),
              menuItem(
                  title: "パスワード",
                  val: "********",
                  onTap: () => MyPageRoute.goTo(
                      context,
                      ChangePasswordPage(
                        myUser: widget.myUser,
                      ))),
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
