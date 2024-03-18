import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/dashboard.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';

class DashboardPageForCompany extends StatefulWidget {
  const DashboardPageForCompany({Key? key}) : super(key: key);

  @override
  State<DashboardPageForCompany> createState() => _DashboardPageForCompanyState();
}

class _DashboardPageForCompanyState extends State<DashboardPageForCompany> with AfterBuildMixin {
  late AuthProvider authProvider;
  late DashboardForCompanyProvider provider;
  late HomeProvider homeProvider;

  @override
  void initState() {
    Provider.of<DashboardForCompanyProvider>(context, listen: false).setLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<DashboardForCompanyProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildBody(),
      ),
    );
  }

  buildBody() {
    if (provider.isLoading) {
      return LoadingWidget(AppColor.primaryColor);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildProfileCompany(),
          AppSize.spaceHeight16,
          buildSummaryApplicant(),
          AppSize.spaceHeight16,
          // buildSummaryMessage(),
          // AppSize.spaceHeight16,
          buildNotificationModelList()
        ],
      );
    }
  }

  buildProfileCompany() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColor.primaryColor),
              child: authProvider.myCompany!.companyProfile != null && authProvider.myCompany!.companyProfile != ""
                  ? Image.network(
                      authProvider.myCompany!.companyProfile!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.person,
                        color: AppColor.whiteColor,
                        size: 35,
                      ),
                    ),
            ),
          ),
          AppSize.spaceWidth32,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${authProvider.myCompany?.companyName}",
                style: normalTextStyle.copyWith(fontSize: 20, color: AppColor.blackColor, fontFamily: "Bold"),
              ),
              AppSize.spaceHeight5,
              Text(
                "${authProvider.myCompany?.location}",
                style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.blackColor, fontFamily: "Normal"),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildSummaryApplicant() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompany[3]);
              var route = homeProvider.checkRouteForCompany(homeProvider);
              context.go(route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleWidget(title: "応募者"),
                AppSize.spaceHeight8,
                Text(
                  "${provider.applicantList.length}名",
                  style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor),
                )
              ],
            ),
          ),
          verticalDivider(),
          InkWell(
            onTap: () {
              homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompany[4]);
              var route = homeProvider.checkRouteForCompany(homeProvider);
              context.go(route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleWidget(title: "ワーカー"),
                AppSize.spaceHeight8,
                Text("${provider.workerCount}名", style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
              ],
            ),
          ),
          verticalDivider(),
          InkWell(
            onTap: () {
              homeProvider.onChangeSelectItemForCompany(homeProvider.menuListForCompany[1]);
              var route = homeProvider.checkRouteForCompany(homeProvider);
              context.go(route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleWidget(title: "掲載中のシフト枠"),
                AppSize.spaceHeight8,
                Text("${provider.jobPostingList.length}件",
                    style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
              ],
            ),
          ),
          verticalDivider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleWidget(title: "ご利用明細発行"),
              AppSize.spaceHeight8,
              Text("0件", style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
            ],
          )
        ],
      ),
    );
  }

  buildSummaryMessage() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleWidget(title: "メッセージ"),
              AppSize.spaceHeight8,
              Text(
                "${provider.applicantList.length}件",
                style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor),
              )
            ],
          ),
          verticalDivider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleWidget(title: "ご利用明細発行"),
              AppSize.spaceHeight8,
              Text("${provider.notificationList.length}件",
                  style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
            ],
          ),
        ],
      ),
    );
  }

  buildNotificationModelList() {
    return Expanded(
        child: Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const TitleWidget(title: "お知らせ"),
          AppSize.spaceHeight16,
          Expanded(
            child: ListView.builder(
                itemCount: provider.notificationList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var notification = provider.notificationList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Container(
                              width: 150,
                              height: 30,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 2, color: Color(0xff6DC9E5))),
                              child: Center(
                                child: Text(
                                  notification.title ?? "",
                                  style: kNormalText.copyWith(color: Color(0xff6DC9E5), fontSize: 16),
                                ),
                              ),
                            ),
                            AppSize.spaceWidth32,
                            Expanded(
                                child: Text(
                              notification.des ?? "",
                              style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                              overflow: TextOverflow.fade,
                            ))
                          ],
                        )),
                        Text(toJapanMonthAndYearDay(notification.date!), style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }

  verticalDivider() {
    return Container(
      width: 1,
      height: 60,
      // padding: const EdgeInsets.symmetric(horizontal: 32),
      color: AppColor.secondaryColor,
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        await provider.onInit(company?.uid ?? "");
        provider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      await provider.onInit(authProvider.myCompany?.uid ?? "");
      provider.onChangeLoading(false);
    }
  }
}
