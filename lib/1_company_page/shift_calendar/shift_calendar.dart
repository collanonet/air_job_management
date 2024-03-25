import 'package:air_job_management/1_company_page/shift_calendar/widget/copy_paste.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/filter.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/job_card_display.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/shift_detail_dialog.dart';
import 'package:air_job_management/providers/company/shift_calendar.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../helper/japan_date_time.dart';
import '../../models/calendar.dart';
import '../../models/company.dart';
import '../../providers/auth.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../widgets/custom_loading_overlay.dart';

class ShiftCalendarPage extends StatefulWidget {
  const ShiftCalendarPage({super.key});

  @override
  State<ShiftCalendarPage> createState() => _ShiftCalendarPageState();
}

class _ShiftCalendarPageState extends State<ShiftCalendarPage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late ShiftCalendarProvider provider;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ShiftCalendarProvider>(context, listen: false).initializeRangeDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<ShiftCalendarProvider>(context);
    return CustomLoadingOverlay(
        isLoading: provider.isLoading,
        child: SizedBox(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const ShiftCalendarFilterDataWidgetForCompany(),
                    Row(
                      children: [
                        buildTab(provider.displayList[0]),
                        buildTab(provider.displayList[1]),
                        Expanded(child: CopyPasteShiftCalendarWidget(onClick: () {}))
                      ],
                    ),
                    if (provider.selectDisplay == provider.displayList[0]) buildCalendarWidget() else buildList()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  buildTab(String title) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
          color: title == provider.selectDisplay ? AppColor.primaryColor : const Color(0xffFFF7E5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0)),
          onTap: () => provider.onChangeDisplay(title),
          child: Center(
            child: Text(
              title,
              style: kNormalText.copyWith(
                  fontSize: 13, fontFamily: "Bold", color: title == provider.selectDisplay ? Colors.white : AppColor.primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  buildCalendarWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "カレンダー表示",
                style: titleStyle,
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 30,
                    color: const Color(0xff7DC338),
                    child: Center(
                      child: Text(
                        "満枠",
                        style: kNormalText.copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  AppSize.spaceWidth8,
                  Container(
                    width: 80,
                    height: 30,
                    color: AppColor.primaryColor,
                    child: Center(
                      child: Text(
                        "空き",
                        style: kNormalText.copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          buildMonthDisplay(),
          AppSize.spaceHeight8,
          Center(
            child: SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "月",
                    style: kNormalText,
                  ),
                  Text(
                    "火",
                    style: kNormalText,
                  ),
                  Text(
                    "水",
                    style: kNormalText,
                  ),
                  Text(
                    "木",
                    style: kNormalText,
                  ),
                  Text(
                    "金",
                    style: kNormalText,
                  ),
                  Text(
                    "土",
                    style: kNormalText,
                  ),
                  Text(
                    "日",
                    style: kNormalText,
                  ),
                ],
              ),
            ),
          ),
          AppSize.spaceHeight8,
          Center(
            child: provider.rangeDateList.isEmpty
                ? const SizedBox()
                : Container(
                    width: AppSize.getDeviceWidth(context) * 0.6,
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      left: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      right: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      bottom: BorderSide(width: 0.4, color: AppColor.darkGrey),
                    )),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 12 / 8),
                        itemCount: 42,
                        itemBuilder: (BuildContext context, int i) {
                          if (i + 1 >= provider.firstDate.weekday) {
                            int index = (i + 1) - provider.firstDate.weekday;
                            var date = index < provider.rangeDateList.length
                                ? provider.rangeDateList[(i + 1) - provider.firstDate.weekday]
                                : CalendarModel(date: DateTime(2000), shiftModelList: [], jobId: "");
                            var weekDay = date.date.weekday;
                            return Container(
                              decoration: BoxDecoration(
                                  color: weekDay == 6 && date.date.year != 2000
                                      ? const Color(0xffEFFCFF)
                                      : weekDay == 7 && date.date.year != 2000
                                          ? const Color(0xffFFF2F2)
                                          : Colors.white,
                                  border: Border.all(width: 0.2, color: AppColor.darkGrey)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          date.date.year == 2000 ? "" : '${date.date.day}',
                                          style: kTitleText.copyWith(color: AppColor.midGrey, fontSize: 16),
                                        )),
                                  ),
                                  Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: date.shiftModelList!.length,
                                          itemBuilder: (context, ind) {
                                            var shift = date.shiftModelList![ind];
                                            return Container(
                                              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 4),
                                              width: 400,
                                              color: shift.applicantCount.toString() == shift.recruitmentCount.toString()
                                                  ? const Color(0xff7DC338)
                                                  : AppColor.primaryColor,
                                              height: 20,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: AppSize.getDeviceHeight(context) * 0.1, vertical: 32),
                                                              child: ShiftDetailDialogWidget(
                                                                jobId: shift.jobId!,
                                                                date: date.date,
                                                              ),
                                                            ));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${shift.startWorkTime} - ${shift.endWorkTime} ",
                                                            style: kNormalText.copyWith(color: Colors.white, fontSize: 12),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                        AppSize.spaceWidth5,
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 1),
                                                          child: Text(
                                                            "${shift.applicantCount}/${shift.recruitmentCount}",
                                                            style: kNormalText.copyWith(color: Colors.white, fontSize: 11),
                                                          ),
                                                        ),
                                                        AppSize.spaceWidth5,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                  color: i == 33 || i == 5
                                      ? const Color(0xffEFFCFF)
                                      : i == 34
                                          ? const Color(0xffFFF2F2)
                                          : Colors.white,
                                  border: Border.all(width: 0.2, color: AppColor.darkGrey)),
                            );
                          }
                        }),
                  ),
          )
        ],
      ),
    );
  }

  buildMonthDisplay() {
    return Center(
      child: Container(
        height: 45,
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: AppColor.primaryColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  provider.onChangeMonth(DateTime(provider.month.year, provider.month.month - 1, provider.month.day));
                  await getData();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25,
                  color: AppColor.primaryColor,
                )),
            Text(
              "${toJapanMonthAndYear(provider.month)}",
              style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
            ),
            IconButton(
                onPressed: () async {
                  provider.onChangeMonth(DateTime(provider.month.year, provider.month.month + 1, provider.month.day));
                  await getData();
                },
                icon: Icon(
                  color: AppColor.primaryColor,
                  Icons.arrow_forward_ios_rounded,
                  size: 25,
                )),
          ],
        ),
      ),
    );
  }

  buildList() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          TitleWidget(title: provider.displayList[0]),
          AppSize.spaceHeight16,
          Row(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Text(
                        "求人タイトル",
                        style: normalTextStyle.copyWith(fontSize: 13),
                      ),
                    )),
                flex: 3,
              ),
              Expanded(
                child: Center(
                  child: Text("稼働期間", style: normalTextStyle.copyWith(fontSize: 13)),
                ),
                flex: 2,
              ),
              Expanded(
                child: Center(
                  child: Text("募集人数", style: normalTextStyle.copyWith(fontSize: 13)),
                ),
                flex: 1,
              ),
              Expanded(
                child: Center(
                  child: Text("応募人数", style: normalTextStyle.copyWith(fontSize: 13)),
                ),
                flex: 1,
              ),
              SizedBox(
                  width: 100,
                  child: Center(
                    child: Text("掲載状況", style: normalTextStyle.copyWith(fontSize: 13)),
                  ))
            ],
          ),
          AppSize.spaceHeight16,
          ListView.builder(
              shrinkWrap: true,
              itemCount: provider.jobPostingList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var job = provider.jobPostingList[index];
                return JobCardDisplay(
                  title: job.title!,
                  shiftFrame: job,
                  onClick: () {
                    // setState(() {
                    //   provider.jobPosting = job;
                    // });
                  },
                  selectShiftFrame: provider.jobPosting,
                );
              })
        ],
      ),
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
        provider.setCompanyId = authProvider.myCompany?.uid ?? "";
        await provider.getApplicantList(authProvider.myCompany?.uid ?? "");
        provider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      provider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await provider.getApplicantList(authProvider.myCompany?.uid ?? "");
      provider.onChangeLoading(false);
    }
  }
}
