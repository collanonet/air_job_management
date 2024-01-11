import 'package:air_job_management/1_company_page/home/widgets/air_job_management.dart';
import 'package:air_job_management/1_company_page/home/widgets/tab_section.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

class HomePageForCompany extends StatefulWidget {
  final String? selectItem;
  final Widget? page;
  const HomePageForCompany({Key? key, this.selectItem, this.page})
      : super(key: key);

  @override
  State<HomePageForCompany> createState() => _HomePageForCompanyState();
}

class _HomePageForCompanyState extends State<HomePageForCompany>
    with AfterBuildMixin {
  late HomeProvider homeProvider;
  late AuthProvider authProvider;

  @override
  void afterBuild(BuildContext context) {
    if (widget.selectItem != null) {
      homeProvider.onChangeSelectItemForCompany(widget.selectItem ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xff8c8fa3),
      body: Container(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        color: const Color(0xfff0f1fa),
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
            AirJobManagementWidget(
                company: authProvider.myCompany,
                onPress: () {
                  homeProvider.onChangeSelectItemForCompany(
                      homeProvider.menuListForCompany[0]);
                }),
            AppSize.spaceHeight16,
            for (int i = 0; i < homeProvider.menuListForCompany.length; i++)
              Column(
                children: [
                  TabSectionWidget(
                      title: homeProvider.menuListForCompany[i],
                      icon: homeProvider.menuIconListForCompany[i],
                      onPress: () {
                        homeProvider.onChangeSelectItemForCompany(
                            homeProvider.menuListForCompany[i]);
                        var route =
                            homeProvider.checkRouteForCompany(homeProvider);
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
                  context.go(MyRoute.companyLogin);
                }),
          ],
        ),
      ),
    );
  }

  rightWidget() {
    int selectedIndex = homeProvider.menuListForCompany
        .indexOf(homeProvider.selectedItemForCompany);
    return Expanded(
        child: widget.page != null
            ? widget.page!
            : homeProvider.menuPageListForCompany.elementAt(selectedIndex));
  }
}
