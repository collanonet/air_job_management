import 'package:air_job_management/1_company_page/entry_exit_history_list/widget/filter.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../providers/company/entry_exit_history.dart';
import '../../utils/my_route.dart';

class EntryExitHistoryListPage extends StatefulWidget {
  const EntryExitHistoryListPage({super.key});

  @override
  State<EntryExitHistoryListPage> createState() => _EntryExitHistoryListPageState();
}

class _EntryExitHistoryListPageState extends State<EntryExitHistoryListPage> with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late AuthProvider authProvider;

  @override
  void initState() {
    Provider.of<EntryExitHistoryProvider>(context, listen: false).setLoading = true;
    Provider.of<EntryExitHistoryProvider>(context, listen: false).initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryExitHistoryProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const FilterEntryExitList(),
          AppSize.spaceHeight16,
          Expanded(
            child: Container(
              decoration: boxDecoration,
              child: buildList(),
            ),
          )
        ],
      ),
    );
  }

  buildList() {
    if (provider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "日付",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      "役職",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "勤務開始時間",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "勤務終了時間",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "遅い",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "シフト開始勤務時間",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "シフト終了勤務時間",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "状態",
                      style: kNormalText.copyWith(fontFamily: "Bold"),
                    )),
              ],
            ),
            AppSize.spaceHeight16,
            ListView.builder(
                shrinkWrap: true,
                itemCount: provider.entryList.length,
                itemBuilder: (context, index) {
                  var entry = provider.entryList[index];
                  return Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "${entry.workDate}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "${entry.jobTitle}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "${entry.startWorkingTime}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "${entry.endWorkingTime}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            entry.isLate == true ? "Late" : "No",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "${entry.scheduleStartWorkingTime}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "${entry.scheduleEndWorkingTime}",
                            style: kNormalText,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "",
                            style: kNormalText,
                          )),
                    ],
                  );
                }),
          ],
        ),
      );
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    onGetData();
  }

  onGetData() async {
    print("Get data");
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        await provider.getEntryData(company!.uid!);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      String id = authProvider.myCompany?.uid ?? "";
      await provider.getEntryData(id);
    }
  }
}
