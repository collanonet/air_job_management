import 'dart:ui';

import 'package:air_job_management/1_company_page/entry_exit_history/data_source/entry_exit_data_source_by_date.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/filter.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/tab_selection.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/table_widget.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../api/entry_exit.dart';
import '../../api/user_api.dart';
import '../../helper/japan_date_time.dart';
import '../../models/company.dart';
import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../entry_exit_history_list/data_source/entry_list_data_source.dart';
import '../entry_exit_history_list/widget/filter.dart';
import '../entry_exit_history_list/widget/ratting_dialog.dart';

class EntryExitHistoryPage extends StatefulWidget {
  const EntryExitHistoryPage({super.key});

  @override
  State<EntryExitHistoryPage> createState() => _EntryExitHistoryPageState();
}

class _EntryExitHistoryPageState extends State<EntryExitHistoryPage> with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late EntryExitHistoryDataSourceByDate entryExitHistoryDataSourceByDate;
  late AuthProvider authProvider;
  Branch? branch;

  @override
  void initState() {
    Provider.of<EntryExitHistoryProvider>(context, listen: false).setLoading = true;
    Provider.of<EntryExitHistoryProvider>(context, listen: false).initData();
    entryExitHistoryDataSourceByDate =
        EntryExitHistoryDataSourceByDate(provider: Provider.of<EntryExitHistoryProvider>(context, listen: false), onTap: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryExitHistoryProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const EntryFilterWidget(),
                AppSize.spaceHeight16,
                IconButton(
                    onPressed: () {
                      EntryExitApiService().insertDataForTesting(provider.entryList);
                    },
                    icon: const Icon(Icons.refresh)),
                const TabSelectionWidget(),
                Container(
                  decoration: boxDecoration,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildTab(provider.displayList[0]),
                          buildTab(provider.displayList[1]),
                          buildTab(provider.displayList[2]),
                          buildTab(provider.displayList[3]),
                        ],
                      ),
                      AppSize.spaceHeight16,
                      // if (provider.selectDisplay == provider.displayList[0]) buildDataTableByDay() else buildMonthDisplay(),
                      if (provider.selectDisplay == provider.displayList[0]) buildEntryExitList() else buildMonthDisplay(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  int _pageSize = 10;

  buildEntryExitList() {
    return Column(
      children: [
        const FilterEntryExitList(),
        SizedBox(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context) * 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
              source: EntryListDataSource(data: provider.entryList, ratting: (entry) {}),
            ),
          ),
        ),
      ],
    );
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
          onTap: () {
            entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
            provider.onChangeDisplay(title);
          },
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

  buildMonthDisplay() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            provider.onChangeMonth(DateTime(provider.startDay.year, provider.startDay.month - 1, provider.startDay.day));
                            onGetData();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 25,
                            color: AppColor.primaryColor,
                          )),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${provider.startDay.year}年",
                                style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 10),
                              ),
                              Text(
                                "${toJapanMonthDayWeekday(provider.startDay)}",
                                style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  "${provider.startDay.year}年",
                                  style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 10),
                                ),
                              ),
                              Text(
                                "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                                style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            provider.onChangeMonth(DateTime(provider.startDay.year, provider.startDay.month + 1, provider.startDay.day));
                            onGetData();
                          },
                          icon: Icon(
                            color: AppColor.primaryColor,
                            Icons.arrow_forward_ios_rounded,
                            size: 25,
                          )),
                    ],
                  ),
                ),
                AppSize.spaceWidth32,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            int index = provider.userNameList.indexOf(provider.selectedUserName);
                            if (index == 0) {
                              index = provider.userNameList.length - 1;
                            } else {
                              index--;
                            }
                            provider.onChangeUserName(provider.userNameList[index]);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 25,
                            color: AppColor.primaryColor,
                          )),
                      Text(
                        "     ${provider.selectedUserName}     ",
                        style: kTitleText.copyWith(color: AppColor.primaryColor),
                      ),
                      IconButton(
                          onPressed: () async {
                            int index = provider.userNameList.indexOf(provider.selectedUserName);
                            if (index + 1 == provider.userNameList.length) {
                              index = 0;
                            } else {
                              index++;
                            }
                            provider.onChangeUserName(provider.userNameList[index]);
                          },
                          icon: Icon(
                            color: AppColor.primaryColor,
                            Icons.arrow_forward_ios_rounded,
                            size: 25,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSize.spaceHeight16,
          // buildData()
          Row(
            children: [
              ...provider.rowHeaderTable.map((e) => Expanded(
                    flex: 1,
                    child: Container(
                      height: 30,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      color: const Color(0xffF0F3F5),
                      alignment: Alignment.center,
                      child: Text(
                        e,
                        style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                      ),
                    ),
                  ))
            ],
          ),
          ListView.builder(
              itemCount: provider.entryList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                EntryExitHistory e = provider.entryList[index];
                return provider.selectedUserName == e.myUser?.nameKanJi && provider.dateList.contains(e.workDateToDateTime)
                    ? Row(
                        children: [
                          DataTableWidget(data: e.workDate),
                          DataTableWidget(data: toJapanWeekDayWithInt(DateToAPIHelper.fromApiToLocal(e.workDate!).weekday)),
                          DataTableWidget(data: "出勤"),
                          DataTableWidget(data: e.startWorkingTime),
                          DataTableWidget(data: e.endWorkingTime),
                          DataTableWidget(data: "00:00"),
                          DataTableWidget(data: "00:00"),
                          DataTableWidget(
                              data:
                                  "${DateToAPIHelper.formatTimeTwoDigits(e.leaveEarlyHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.leaveEarlyMinute.toString())}"),
                          DataTableWidget(
                              data:
                                  "${DateToAPIHelper.formatTimeTwoDigits(e.actualWorkingHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.actualWorkingMinute.toString())}"),
                          DataTableWidget(data: e.overtimeWithinLegalLimit),
                          DataTableWidget(data: e.nonStatutoryOvertime),
                          DataTableWidget(data: e.holidayWork),
                          DataTableWidget(data: "00:00"),
                          DataTableWidget(data: e.overtime),
                          DataTableWidget(
                              data:
                                  "${DateToAPIHelper.formatTimeTwoDigits(e.workingHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.workingMinute.toString())}"),
                        ],
                      )
                    : const SizedBox();
              }),
          AppSize.spaceHeight30,
          summaryWidget(),
          AppSize.spaceHeight30,
        ],
      ),
    );
  }

  summaryWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(title: "実出勤日数", data: "${CommonUtils.totalActualWorkDay(provider.shiftList, provider.dateList)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "総出勤日数", data: "${CommonUtils.totalWorkDay(provider.entryList, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "有休消化", data: "00.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "有休残数", data: "00.00")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(title: "公休日数", data: "00.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "特別休暇", data: "00.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "振替日数", data: "00.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "休出日数", data: "${DateToAPIHelper.formatTimeTwoDigits(provider.countDayOff.toString())}.00")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(title: "欠勤日数", data: "20.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "遅刻回数", data: "${CommonUtils.totalLateTime(provider.entryList, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "早退回数", data: "${CommonUtils.totalLeaveEarly(provider.entryList, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "不労時間", data: "20.00")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(
                title: "法定内", data: "${CommonUtils.totalOvertimeWithinLaw(provider.entryList, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "法定外", data: "${CommonUtils.totalOvertimeNonStatutory(provider.entryList, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "基準残業", data: "${CommonUtils.totalOvertimeWithinLaw(provider.entryList, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "超過残業", data: "${CommonUtils.totalOvertime(provider.entryList, provider.dateList, provider.selectedUserName)}")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(title: "深夜", data: "00:00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(title: "休出時間", data: "${CommonUtils.totalBreakTime(provider.entryList, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "実勤務時間", data: "${CommonUtils.totalActualWorkingTime(provider.entryList, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "総勤務時間", data: "${CommonUtils.totalWorkingTime(provider.entryList, provider.dateList, provider.selectedUserName)}")
          ],
        ),
        AppSize.spaceWidth32,
        summaryCardWidget(title: "所定外計", data: "00:00"),
      ],
    );
  }

  summaryCardWidget({String? title, String? data}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 30,
          color: const Color(0xffF0F3F5),
          child: Center(
            child: Text(
              title ?? "",
              style: kNormalText,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
          child: Center(
            child: Text(
              data ?? "",
              style: kNormalText,
            ),
          ),
        )
      ],
    );
  }

  ScrollController horizontalScroll1 = ScrollController();

  //Hide K1 page
  buildDataTableByDay() {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1, color: AppColor.primaryColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.startDay.year, provider.startDay.month - 1, provider.startDay.day));
                      onGetData();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                      color: AppColor.primaryColor,
                    )),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${provider.startDay.year}年",
                          style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 10),
                        ),
                        Text(
                          "${toJapanMonthDayWeekday(provider.startDay)}",
                          style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Text(
                            "${provider.startDay.year}年",
                            style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 10),
                          ),
                        ),
                        Text(
                          "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                          style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.startDay.year, provider.startDay.month + 1, provider.startDay.day));
                      onGetData();
                    },
                    icon: Icon(
                      color: AppColor.primaryColor,
                      Icons.arrow_forward_ios_rounded,
                      size: 25,
                    )),
              ],
            ),
          ),
        ),
        AppSize.spaceHeight16,
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 65),
              child: SizedBox(
                width: 180,
                height: provider.entryExitCalendarByUser.length * 125,
                child: ListView.builder(
                    itemCount: provider.entryExitCalendarByUser.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        height: 125,
                        width: 180,
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 115,
                              color: const Color(0xffF0F3F5),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${provider.entryExitCalendarByUser[index].userName}",
                                style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 14),
                              ),
                            ),
                            AppSize.spaceWidth5,
                            Column(
                              children: [
                                displayDateWidget("所定外", width: 60),
                                displayDateWidget("法定外", width: 60),
                                displayDateWidget("法定内", width: 60),
                                displayDateWidget("休日出勤", width: 60)
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }),
                child: Scrollbar(
                  controller: horizontalScroll1,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: horizontalScroll1,
                    child: SfDataGrid(
                        source: entryExitHistoryDataSourceByDate,
                        columnWidthMode: ColumnWidthMode.fill,
                        isScrollbarAlwaysShown: false,
                        rowHeight: 125,
                        headerRowHeight: 65,
                        shrinkWrapRows: true,
                        shrinkWrapColumns: true,
                        gridLinesVisibility: GridLinesVisibility.none,
                        headerGridLinesVisibility: GridLinesVisibility.none,
                        horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                        verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                        columns: provider.dateList.map((e) {
                          return GridColumn(
                              width: 48,
                              label: Center(
                                  child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(vertical: 1),
                                    color: const Color(0xffF0F3F5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      e.day.toString(),
                                      style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                                    ),
                                  ),
                                  Container(
                                    width: 48,
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(vertical: 1),
                                    color: const Color(0xffF0F3F5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      toJapanWeekDayWithInt(e.weekday),
                                      style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                                    ),
                                  ),
                                ],
                              )),
                              columnName: e.toString());
                        }).toList()),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
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
        // provider.getUserShift(company.uid!, authProvider.branch!.id!);
        entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
        if (authProvider.myCompany?.branchList != []) {
          branch = authProvider.myCompany?.branchList!.first;
        }
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      String id = authProvider.myCompany?.uid ?? "";
      await provider.getEntryData(id);
      entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
      // provider.getUserShift(id, authProvider.branch!.id!);
      if (authProvider.myCompany?.branchList != []) {
        branch = authProvider.myCompany?.branchList!.first;
      }
    }
  }
}
