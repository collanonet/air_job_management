import 'package:air_job_management/1_company_page/entry_exit_history_list/widget/filter.dart';
import 'package:air_job_management/1_company_page/entry_exit_history_list/widget/ratting_dialog.dart';
import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/models/job_posting.dart';
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
import 'data_source/entry_list_data_source.dart';

class EntryExitHistoryListPage extends StatefulWidget {
  const EntryExitHistoryListPage({super.key});

  @override
  State<EntryExitHistoryListPage> createState() => _EntryExitHistoryListPageState();
}

class _EntryExitHistoryListPageState extends State<EntryExitHistoryListPage> with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late AuthProvider authProvider;
  ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  int _pageSize = 10;

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
          FilterEntryExitList(
            onRefreshData: () {},
          ),
          AppSize.spaceHeight16,
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: boxDecoration,
                child: buildList(),
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Scrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          child: SizedBox(
            width: AppSize.getDeviceWidth(context),
            height: AppSize.getDeviceHeight(context) * 0.9,
            child: PaginatedDataTable(
              controller: scrollController,
              rowsPerPage: _pageSize,
              availableRowsPerPage: const [10, 25, 50],
              onRowsPerPageChanged: (value) {
                setState(() {
                  _pageSize = value!;
                });
              },
              columns: [
                DataColumn(
                    label: Text(
                  "日付",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "役職",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "勤務開始時間",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "勤務終了時間",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "遅い",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "シフト開始勤務時間",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "シフト終了勤務時間",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "状態",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "評価",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "フィードバック",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
              ],
              source:
                  EntryListDataSource(context: context, data: provider.entryList, ratting: (entry) => showRatingDialog(entry), onUserTap: (user) {}),
            ),
          ),
        ),
      );
    }
  }

  showRatingDialog(EntryExitHistory entryExitHistory) {
    showDialog(
        context: context,
        builder: (context) {
          return RattingWidgetPage(
              entryExitHistory: entryExitHistory,
              onRate: (rate, comment) async {
                Navigator.pop(context);
                Review review = Review(rate: rate.toString(), comment: comment, id: entryExitHistory.companyId, name: entryExitHistory.companyName);
                await EntryExitApiService().updateReview(entryExitHistory.uid!, entryExitHistory.userId ?? "", review);
                onGetData();
              });
        });
  }

  @override
  void afterBuild(BuildContext context) async {
    onGetData();
  }

  onGetData() async {
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
