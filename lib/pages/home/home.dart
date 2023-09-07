import 'package:air_job_management/pages/home/widgets/air_job_management.dart';
import 'package:air_job_management/pages/home/widgets/tab_section.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

class HomePage extends StatefulWidget {
  final String? selectItem;
  final Widget? page;
  const HomePage({Key? key, this.selectItem, this.page}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterBuildMixin {
  late HomeProvider homeProvider;

  @override
  void afterBuild(BuildContext context) {
    if (widget.selectItem != null) {
      homeProvider.onChangeSelectItem(widget.selectItem ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xff8c8fa3),
      body: Container(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        color: Color(0xfff0f1fa),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSize.spaceHeight16,
            AirJobManagementWidget(onPress: () {
              homeProvider.onChangeSelectItem(homeProvider.menuList[0]);
            }),
            AppSize.spaceHeight16,
            for (int i = 0; i < homeProvider.menuList.length; i++)
              Column(
                children: [
                  TabSectionWidget(
                      title: homeProvider.menuList[i],
                      icon: homeProvider.menuIconList[i],
                      onPress: () {
                        homeProvider
                            .onChangeSelectItem(homeProvider.menuList[i]);
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
      ),
    );
  }

  rightWidget() {
    int selectedIndex =
        homeProvider.menuList.indexOf(homeProvider.selectedItem);
    return Expanded(
        child: widget.page != null
            ? widget.page!
            : homeProvider.menuPageList.elementAt(selectedIndex));
  }
}
