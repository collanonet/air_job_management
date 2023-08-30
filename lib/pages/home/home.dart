import 'package:air_job_management/pages/home/widgets/air_job_management.dart';
import 'package:air_job_management/pages/home/widgets/tab_section.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

class HomePage extends StatefulWidget {
  final String? selectItem;
  const HomePage({Key? key, this.selectItem}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterBuildMixin {
  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Container(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        color: AppColor.whiteColor,
        child: Row(
          children: [leftWidget(), rightWidget()],
        ),
      ),
    );
  }

  leftWidget() {
    double width = 120.0 + (AppSize.getDeviceWidth(context) * 0.02);
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppSize.spaceHeight16,
          AirJobManagementWidget(onPress: () {
            homeProvider.onChangeSelectItem(homeProvider.menuList[0]);
          }),
          AppSize.spaceHeight30,
          for (int i = 0; i < homeProvider.menuList.length; i++)
            Column(
              children: [
                TabSectionWidget(
                    title: homeProvider.menuList[i],
                    icon: homeProvider.menuIconList[i],
                    onPress: () {
                      homeProvider.onChangeSelectItem(homeProvider.menuList[i]);
                      var route = homeProvider.checkRoute(homeProvider);
                      context.go(route);
                    }),
                AppSize.spaceHeight8,
              ],
            ),
          TabSectionWidget(
              title: "Logout",
              icon: Icons.logout,
              onPress: () async {
                await FirebaseAuth.instance.signOut();
                context.go(MyRoute.login);
              }),
        ],
      ),
    );
  }

  rightWidget() {
    int selectedIndex = homeProvider.menuList.indexOf(homeProvider.selectedItem);
    return Expanded(child: homeProvider.menuPageList.elementAt(selectedIndex));
  }

  @override
  void afterBuild(BuildContext context) {
    if (widget.selectItem != null) {
      homeProvider.onChangeSelectItem(widget.selectItem ?? "");
    }
  }
}
