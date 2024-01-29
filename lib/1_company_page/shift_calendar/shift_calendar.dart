import 'package:air_job_management/1_company_page/shift_calendar/widget/copy_paste.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/filter.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/shift_detail_dialog.dart';
import 'package:air_job_management/providers/company/shift_calendar.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../helper/japan_date_time.dart';
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
            child: Column(
              children: [const ShiftCalendarFilterDataWidgetForCompany(), CopyPasteShiftCalendarWidget(onClick: () {}), buildCalendarWidget()],
            ),
          ),
        ));
  }

  buildCalendarWidget() {
    return Expanded(
        child: Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "カレンダー表示",
            style: titleStyle,
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
          Expanded(
            child: Center(
              child: provider.rangeDateList.isEmpty
                  ? const SizedBox()
                  : Container(
                      width: AppSize.getDeviceWidth(context) * 0.6,
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(width: 0.4, color: AppColor.darkGrey),
                        left: BorderSide(width: 0.4, color: AppColor.darkGrey),
                        right: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      )),
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 16 / 8),
                          itemCount: 35,
                          itemBuilder: (BuildContext context, int i) {
                            if ((i + 1 == provider.firstDate.weekday || i + 1 >= provider.firstDate.weekday) && i < provider.rangeDateList.length) {
                              var date = provider.rangeDateList[(i + 1) - provider.firstDate.weekday];
                              var weekDay = date.date.weekday;
                              return Container(
                                decoration: BoxDecoration(
                                    color: weekDay == 6
                                        ? const Color(0xffEFFCFF)
                                        : weekDay == 7
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
                                            '${date.date.day}',
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
                                                color: AppColor.primaryColor,
                                                height: 20,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () => showDialog(
                                                        context: context,
                                                        builder: (context) => ShiftDetailDialogWidget(
                                                              jobId: date.jobId!,
                                                              date: date.date,
                                                            )),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5),
                                                      child: Text(
                                                        "${shift.startWorkTime} - ${shift.endWorkTime}",
                                                        style: kNormalText.copyWith(color: Colors.white, fontSize: 12),
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
            ),
          )
        ],
      ),
    ));
  }

  buildMonthDisplay() {
    return Center(
      child: Container(
        height: 54,
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
                onPressed: () => provider.onChangeMonth(DateTime(provider.month.year, provider.month.month - 1, provider.month.day)),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25,
                  color: AppColor.primaryColor,
                )),
            Text(
              "${toJapanMonthAndYear(provider.month)}",
              style: titleStyle,
            ),
            IconButton(
                onPressed: () => provider.onChangeMonth(DateTime(provider.month.year, provider.month.month + 1, provider.month.day)),
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
