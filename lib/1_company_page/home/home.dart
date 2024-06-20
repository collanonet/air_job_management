import 'package:air_job_management/1_company_page/dashboard/dashboard.dart';
import 'package:air_job_management/1_company_page/home/widgets/air_job_management.dart';
import 'package:air_job_management/1_company_page/home/widgets/choose_branch.dart';
import 'package:air_job_management/1_company_page/home/widgets/tab_section.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/dashboard.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/withraw.dart';

class HomePageForCompany extends StatefulWidget {
  final String? selectItem;
  final Widget? page;
  const HomePageForCompany({Key? key, this.selectItem, this.page}) : super(key: key);

  @override
  State<HomePageForCompany> createState() => _HomePageForCompanyState();
}

class _HomePageForCompanyState extends State<HomePageForCompany> with AfterBuildMixin {
  late HomeProvider homeProvider;
  late AuthProvider authProvider;
  late DashboardForCompanyProvider dashboardPageForCompany;

  @override
  void afterBuild(BuildContext context) {
    if (widget.selectItem != null) {
      homeProvider.onChangeSelectItemForCompany(widget.selectItem ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    dashboardPageForCompany = Provider.of<DashboardForCompanyProvider>(context);
    homeProvider = Provider.of<HomeProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F5),
      body: Container(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        color: const Color(0xffF0F3F5),
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
              branch: authProvider.branch,
              company: authProvider.myCompany,
              onPress: () {
                homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompany[0]);
              },
              onChooseBranch: () => showChooseBranchDialog(),
            ),
            AppSize.spaceHeight16,
            if (authProvider.branch?.name == "企業")
              for (int i = 0; i < homeProvider.menuListForCompanyMainBranch.length; i++)
                Column(
                  children: [
                    TabSectionWidget(
                        title: homeProvider.menuListForCompanyMainBranch[i],
                        icon: homeProvider.menuIconListForCompanyMainBranch[i],
                        onPress: () {
                          homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompanyMainBranch[i]);
                          var route = homeProvider.checkRouteForCompany(homeProvider);
                          context.go(route);
                        }),
                    AppSize.spaceHeight8,
                  ],
                )
            else
              for (int i = 0; i < homeProvider.menuListForCompany.length; i++)
                Column(
                  children: [
                    TabSectionWidget(
                        title: homeProvider.menuListForCompany[i],
                        icon: homeProvider.menuIconListForCompany[i],
                        onPress: () {
                          homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompany[i]);
                          var route = homeProvider.checkRouteForCompany(homeProvider);
                          context.go(route);
                        }),
                    AppSize.spaceHeight8,
                  ],
                ),
            TabSectionWidget(
                title: "ログアウト",
                icon: Icons.logout,
                onPress: () async {
                  CustomDialog.confirmDialog(
                      title: "アカウントをログアウトしてもよろしいですか?",
                      titleText: "ログアウトの確認",
                      context: context,
                      onApprove: () async {
                        Navigator.pop(context);
                        authProvider.onChangeBranch(null);
                        await FirebaseAuth.instance.signOut();
                        context.go(MyRoute.companyLogin);
                      });
                }),
          ],
        ),
      ),
    );
  }

  showChooseBranchDialog() {
    showDialog(
        context: context,
        builder: (context) => ChooseBranchWidget(
              onRefresh: () async {
                if (authProvider.branch?.name == "企業") {
                  homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompanyMainBranch[0]);
                }
                dashboardPageForCompany.onChangeLoading(true);
                await dashboardPageForCompany.onInit(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
                withdrawList = await WithdrawApiService().getAllWithdraw("");
                dashboardPageForCompany.onChangeLoading(false);
              },
            ));
  }

  rightWidget() {
    int selectedIndex = 0;
    if (authProvider.branch?.name == "企業") {
      selectedIndex = homeProvider.menuListForCompanyMainBranch.indexOf(homeProvider.selectedItemForCompany);
    } else {
      selectedIndex = homeProvider.menuListForCompany.indexOf(homeProvider.selectedItemForCompany);
    }
    return Expanded(
        child: widget.page != null
            ? widget.page!
            : authProvider.branch?.name == "企業"
                ? homeProvider.menuPageListForCompanyMainBranch.elementAt(selectedIndex == -1 ? 0 : selectedIndex)
                : homeProvider.menuPageListForCompany.elementAt(selectedIndex == -1 ? 0 : selectedIndex));
  }
}
