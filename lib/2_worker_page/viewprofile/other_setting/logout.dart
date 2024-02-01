import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/my_route.dart';
import '../../../utils/respnsive.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('ログアウト'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
                width: AppSize.getDeviceWidth(context),
                decoration: boxDecoration,
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 50,
                        color: AppColor.primaryColor,
                      ),
                      AppSize.spaceHeight30,
                      Text("ログアウトしますか。", style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal", color: AppColor.darkGrey)),
                    ],
                  ),
                )),
            AppSize.spaceHeight30,
            Center(
              child: SizedBox(
                width: AppSize.getDeviceWidth(context) * (Responsive.isMobile(context) ? 0.8 : 0.25),
                child: ButtonWidget(
                  title: "ログアウトする",
                  onPress: () async {
                    await FirebaseAuth.instance.signOut();
                    context.go(MyRoute.login);
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

  List<String> selected = [];

  Widget item(String title) {
    return Card(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColor.secondaryColor,
        checkColor: Colors.white,
        title: Text(title),
        value: selected.contains(title),
        onChanged: (bool? value) {
          if (selected.contains(title)) {
            selected.remove(title);
          } else {
            selected.add(title);
          }
          setState(() {});
        },
      ),
    );
  }
}
