import 'package:air_job_management/1_company_page/dashboard/chat.dart';
import 'package:air_job_management/api/job_posting.dart';
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
import '../../api/withraw.dart';
import '../../models/company.dart';
import '../../models/widthraw.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../shift_calendar/widget/shift_detail_dialog.dart';

class DashboardPageForCompany extends StatefulWidget {
  const DashboardPageForCompany({Key? key}) : super(key: key);

  @override
  State<DashboardPageForCompany> createState() => _DashboardPageForCompanyState();
}

class _DashboardPageForCompanyState extends State<DashboardPageForCompany> with AfterBuildMixin {
  late AuthProvider authProvider;
  late DashboardForCompanyProvider provider;
  late HomeProvider homeProvider;
  List<WithdrawModel> withdrawList = [];

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
        padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
        child: buildBody(),
      ),
    );
  }

  buildBody() {
    if (provider.isLoading) {
      return LoadingWidget(AppColor.primaryColor);
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildProfileCompany(),
            AppSize.spaceHeight16,
            buildSummaryApplicant(),
            AppSize.spaceHeight16,
            // buildSummaryMessage(),
            ChatPageAtDashboard(),
            AppSize.spaceHeight16,
            buildNotificationModelList()
          ],
        ),
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
          ),
          const Spacer(),
          const SizedBox(),
          IconButton(onPressed: () => getData(), icon: const Icon(Icons.refresh))
          // PopupMenuButton(
          //     icon: badges.Badge(
          //       badgeContent: Text(
          //         '${provider.notificationList.length}',
          //         style: kNormalText.copyWith(color: Colors.white, fontSize: 10),
          //       ),
          //       child: const Icon(
          //         Icons.notifications,
          //         size: 30,
          //       ),
          //     ),
          //     itemBuilder: (context) => provider.notificationList
          //         .map((e) => PopupMenuItem(
          //             onTap: () => context.go(MyRoute.companyShift),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 AppSize.spaceHeight8,
          //                 Text(
          //                   "${e.title}",
          //                   style: kTitleText,
          //                 ),
          //                 Text(
          //                   "${e.des}",
          //                   style: kNormalText,
          //                 ),
          //                 Align(
          //                   alignment: Alignment.centerRight,
          //                   child: Text(
          //                     "${toJapanDateTime(e.date!)}",
          //                     style: kNormalText,
          //                   ),
          //                 ),
          //               ],
          //             )))
          //         .toList())
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
                const TitleWidget(title: "ワーカー"),
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
                const TitleWidget(title: "掲載中のシフト枠"),
                AppSize.spaceHeight8,
                Text("${provider.jobPostingList.length}件",
                    style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
              ],
            ),
          ),
          verticalDivider(),
          InkWell(
            onTap: () => context.go(MyRoute.companyUsageDetail),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TitleWidget(title: "ご利用明細発行"),
                AppSize.spaceHeight8,
                Text("${withdrawList.length}件", style: kNormalText.copyWith(fontSize: 20, fontFamily: "Bold", color: AppColor.primaryColor))
              ],
            ),
          )
        ],
      ),
    );
  }

  buildSummaryMessage() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.only(top: 32, bottom: 32, right: 32),
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
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const TitleWidget(title: "お知らせ"),
          AppSize.spaceHeight16,
          ListView.builder(
              itemCount: provider.notificationList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var notification = provider.notificationList[index];
                return InkWell(
                  onTap: () async {
                    // context.go(MyRoute.companyShift);
                    showDialog(
                        context: context,
                        builder: (context) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceHeight(context) * 0.1, vertical: 32),
                              child: ShiftDetailDialogWidget(
                                isRequest: notification.isJobApply == true ? false : true,
                                startTime: "",
                                endTime: "",
                                jobId: notification.jobId!,
                                date: notification.applyDate!,
                                onSuccess: () => getData(),
                              ),
                            ));
                    await JobPostingApiService().updateNotificationToRead(notification.uid ?? "");
                    getData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 220,
                              height: 30,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 2, color: Color(0xff6DC9E5))),
                              child: Center(
                                child: Text(
                                  notification.title ?? "",
                                  style: kNormalText.copyWith(color: const Color(0xff6DC9E5), fontSize: 11),
                                ),
                              ),
                            ),
                            AppSize.spaceWidth32,
                            Expanded(
                                child: Text(
                              notification.shortDes ?? "",
                              style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                              overflow: TextOverflow.fade,
                              // maxLines: 3,
                            ))
                          ],
                        )),
                        AppSize.spaceWidth32,
                        Text(toJapanMonthAndYearDay(notification.date!), style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16)),
                        AppSize.spaceWidth32,
                        Text(
                          notification.isRead == true ? "既読" : "未読",
                          style: kNormalText,
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
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
        // Company? company = await UserApiServices().getProfileCompany(user.uid);
        var data = await Future.wait([UserApiServices().getProfileCompany(user.uid), WithdrawApiService().getAllWithdraw("")]);
        Company? company = data[0] as Company?;
        withdrawList = data[1] as List<WithdrawModel>;
        authProvider.onChangeCompany(company);
        await provider.onInit(company?.uid ?? "", authProvider.branch?.id ?? "");
        if (authProvider.branch == null) {
          authProvider.onChangeBranch(authProvider.myCompany!.branchList!.first);
        }
        provider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      await provider.onInit(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
      withdrawList = await WithdrawApiService().getAllWithdraw("");
      if (authProvider.branch == null) {
        authProvider.onChangeBranch(authProvider.myCompany!.branchList!.first);
      }
      provider.onChangeLoading(false);
    }
  }
}
