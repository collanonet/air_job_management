import 'package:air_job_management/1_company_page/shift_calendar/widget/copy_paste.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/filter.dart';
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
          buildMonthDisplay()
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
