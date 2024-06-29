import 'dart:ui';

import 'package:air_job_management/1_company_page/entry_exit_history/data_source/entry_exit_data_source_by_date.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/data_table_widget_fixed_width.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/filter.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/tab_selection.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/table_widget.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/user_basic_information.dart';
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
import '../../models/user.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/title.dart';
import '../entry_exit_history_list/data_source/entry_list_data_source.dart';
import '../entry_exit_history_list/widget/filter.dart';
import '../entry_exit_history_list/widget/ratting_dialog.dart';
import 'data_source/entry_exit_and_shift_data_source.dart';

class EntryExitHistoryPage extends StatefulWidget {
  const EntryExitHistoryPage({super.key});

  @override
  State<EntryExitHistoryPage> createState() => _EntryExitHistoryPageState();
}

class _EntryExitHistoryPageState extends State<EntryExitHistoryPage>
    with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late EntryExitHistoryDataSourceByDate entryExitHistoryDataSourceByDate;
  late EntryExitAndShiftDataByUser entryExitAndShiftDataByUser;
  late AuthProvider authProvider;
  Branch? branch;
  ScrollController scrollController22 = ScrollController();

  @override
  void initState() {
    Provider.of<EntryExitHistoryProvider>(context, listen: false).setLoading =
        true;
    Provider.of<EntryExitHistoryProvider>(context, listen: false)
        .initData(context);
    entryExitAndShiftDataByUser = EntryExitAndShiftDataByUser(
        provider: Provider.of<EntryExitHistoryProvider>(context, listen: false),
        onTap: () {});
    entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(
        provider: Provider.of<EntryExitHistoryProvider>(context, listen: false),
        onTap: () {});
    super.initState();
  }

  bool loadingOverlay = false;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryExitHistoryProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: loadingOverlay || provider.overlayLoadingFilter,
      child: SizedBox(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              controller: scrollController22,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController22,
                child: Column(
                  children: [
                    const EntryFilterWidget(),
                    AppSize.spaceHeight16,
                    const TabSelectionWidget(),
                    if (provider.selectedMenu == provider.tabMenu[0])
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
                            if (provider.selectDisplay ==
                                provider.displayList[0])
                              buildEntryExitList()
                            else if (provider.selectDisplay ==
                                provider.displayList[2])
                              buildAttendanceListByMonth()
                            else if (provider.selectDisplay ==
                                provider.displayList[3])
                              buildDataTableOvertimeByDay()
                            else
                              buildMonthDisplay(),
                          ],
                        ),
                      )
                    else
                      Container(
                        decoration: boxDecoration,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                buildTab(provider.displayList[0]),
                                buildTab(provider.displayList[1]),
                              ],
                            ),
                            AppSize.spaceHeight16,
                            if (provider.selectDisplay ==
                                provider.displayList[0])
                              buildDataTableListOfShiftByUser()
                            else
                              buildMonthDisplay(),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  int _pageSize = 10;

  buildEntryExitList() {
    return Column(
      children: [
        FilterEntryExitList(
          onRefreshData: () async {
            setState(() {
              provider.startWorkDate = null;
              provider.endWorkDate = null;
              provider.selectedUsernameForEntryExit = null;
              provider.selectedJobTitle = null;
            });
            await onGetData();
          },
        ),
        SizedBox(
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
                  "求人タイトル",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "スタッフ",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "シフト",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "出退勤(予定)",
                  style: kNormalText.copyWith(fontFamily: "Bold"),
                )),
                DataColumn(
                    label: Text(
                  "出退勤(実績)",
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
              source: EntryListDataSource(
                  context: context,
                  data: provider.entryList,
                  ratting: (entry) => showRatingDialog(entry),
                  onUserTap: (user) => onUserTapped(user)),
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
                Review review = Review(
                    rate: rate.toString(),
                    comment: comment,
                    id: entryExitHistory.companyId,
                    name: entryExitHistory.companyName);
                await EntryExitApiService().updateReview(entryExitHistory.uid!,
                    entryExitHistory.userId ?? "", review);
                onGetData();
              });
        });
  }

  buildTab(String title) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
          color: title == provider.selectDisplay
              ? AppColor.primaryColor
              : const Color(0xffFFF7E5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(
                  provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(
                  provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(
                  provider.selectDisplay == provider.displayList[1] ? 6 : 0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(
                  provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(
                  provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(
                  provider.selectDisplay == provider.displayList[1] ? 6 : 0)),
          onTap: () {
            entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(
                provider: provider, onTap: () {});
            entryExitAndShiftDataByUser =
                EntryExitAndShiftDataByUser(provider: provider, onTap: () {});
            provider.onChangeDisplay(title, authProvider.branch!.id.toString());
          },
          child: Center(
            child: Text(
              title,
              style: kNormalText.copyWith(
                  fontSize: 13,
                  fontFamily: "Bold",
                  color: title == provider.selectDisplay
                      ? Colors.white
                      : AppColor.primaryColor),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            provider.onChangeMonth(DateTime(
                                provider.startDay.year,
                                provider.startDay.month - 1,
                                provider.startDay.day));
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
                                style: titleStyle.copyWith(
                                    fontFamily: "Medium", fontSize: 10),
                              ),
                              Text(
                                "${toJapanMonthDayWeekday(provider.startDay)}",
                                style: titleStyle.copyWith(
                                    fontFamily: "Medium", fontSize: 14),
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
                                  style: titleStyle.copyWith(
                                      fontFamily: "Medium", fontSize: 10),
                                ),
                              ),
                              Text(
                                "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                                style: titleStyle.copyWith(
                                    fontFamily: "Medium", fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            provider.onChangeMonth(DateTime(
                                provider.startDay.year,
                                provider.startDay.month + 1,
                                provider.startDay.day));
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            int index = provider.userNameList
                                .indexOf(provider.selectedUserName);
                            if (index == 0) {
                              index = provider.userNameList.length - 1;
                            } else {
                              index--;
                            }
                            provider.onChangeUserName(
                                provider.userNameList[index],
                                authProvider.branch!.id.toString());
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 25,
                            color: AppColor.primaryColor,
                          )),
                      Text(
                        "     ${provider.selectedUserName}     ",
                        style:
                            kTitleText.copyWith(color: AppColor.primaryColor),
                      ),
                      IconButton(
                          onPressed: () async {
                            int index = provider.userNameList
                                .indexOf(provider.selectedUserName);
                            if (index + 1 == provider.userNameList.length) {
                              index = 0;
                            } else {
                              index++;
                            }
                            provider.onChangeUserName(
                                provider.userNameList[index],
                                authProvider.branch!.id.toString());
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
                        style: kNormalText.copyWith(
                            fontSize: 12, fontFamily: "Bold"),
                      ),
                    ),
                  ))
            ],
          ),
          if (provider.entryListByBranch.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: EmptyDataWidget(),
            )
          else
            ListView.builder(
                itemCount: provider.entryListByBranch.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  EntryExitHistory e = provider.entryListByBranch[index];
                  return provider.selectedUserName == e.myUser?.nameKanJi &&
                          provider.dateList.contains(e.workDateToDateTime)
                      ? Row(
                          children: [
                            DataTableWidget(data: e.workDate),
                            DataTableWidget(
                                data: toJapanWeekDayWithInt(
                                    DateToAPIHelper.fromApiToLocal(e.workDate!)
                                        .weekday)),
                            const DataTableWidget(data: "出"),
                            DataTableWidget(data: e.startWorkingTime),
                            DataTableWidget(data: e.endWorkingTime),
                            DataTableWidget(
                                data: e.isPaidLeave == true ? "" : ""),
                            DataTableWidget(
                                data:
                                    "${DateToAPIHelper.formatTimeTwoDigits(e.latHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.lateMinute.toString())}"),
                            DataTableWidget(
                                data:
                                    "${DateToAPIHelper.formatTimeTwoDigits(e.leaveEarlyHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.leaveEarlyMinute.toString())}"),
                            DataTableWidget(
                                data:
                                    "${DateToAPIHelper.formatTimeTwoDigits(e.workingHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(e.workingMinute.toString())}"),
                            DataTableWidget(
                                data: CommonUtils.calculateOvertimeInEntry(e,
                                    withInLimit: true)),
                            DataTableWidget(
                                data: CommonUtils.calculateOvertimeInEntry(e,
                                    nonSat: true)),
                            DataTableWidget(data: e.holidayWork),
                            const DataTableWidget(data: "00:00"),
                            DataTableWidget(
                                data: CommonUtils.calculateOvertimeInEntry(e,
                                    isOvertime: true)),
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

  ScrollController controllerIndex3 = ScrollController();

  buildAttendanceListByMonth() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      // height: AppSize.getDeviceHeight(context) * 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          provider.onChangeMonth(DateTime(
                              provider.startDay.year,
                              provider.startDay.month - 1,
                              provider.startDay.day));
                          await provider
                              .getEntryData(authProvider.myCompany?.uid ?? "");
                          provider.mapDataForShiftAndWorkTime();
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
                              style: titleStyle.copyWith(
                                  fontFamily: "Medium", fontSize: 10),
                            ),
                            Text(
                              "${toJapanMonthDayWeekday(provider.startDay)}",
                              style: titleStyle.copyWith(
                                  fontFamily: "Medium", fontSize: 14),
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
                                style: titleStyle.copyWith(
                                    fontFamily: "Medium", fontSize: 10),
                              ),
                            ),
                            Text(
                              "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                              style: titleStyle.copyWith(
                                  fontFamily: "Medium", fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          provider.onChangeMonth(DateTime(
                              provider.startDay.year,
                              provider.startDay.month + 1,
                              provider.startDay.day));
                          await provider
                              .getEntryData(authProvider.myCompany?.uid ?? "");
                          provider.mapDataForShiftAndWorkTime();
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
            // buildData()
            if (provider.shiftAndWorkTimeByUserList.isEmpty)
              SizedBox(
                height: 30,
                child: ListView.builder(
                    itemCount:
                        provider.rowHeaderForAttendanceManagementList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    controller: controllerIndex3,
                    itemBuilder: (context, index) {
                      var e =
                          provider.rowHeaderForAttendanceManagementList[index];
                      return Container(
                        height: 30,
                        width: index == 0 ? 130 : 70,
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        color: const Color(0xffF0F3F5),
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: kNormalText.copyWith(
                              fontSize: 12, fontFamily: "Bold"),
                        ),
                      );
                    }),
              )
            else
              const SizedBox(),
            if (provider.shiftAndWorkTimeByUserList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: EmptyDataWidget(),
              )
            else
              Scrollbar(
                controller: controllerIndex3,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  primary: false,
                  controller: controllerIndex3,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: AppSize.getDeviceWidth(context) * 1.3,
                    child: ListView.builder(
                        itemCount: provider.shiftAndWorkTimeByUserList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var data = provider.shiftAndWorkTimeByUserList[index];
                          return data.userName == ""
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    index == 0
                                        ? Row(
                                            children: [
                                              ...provider
                                                  .rowHeaderForAttendanceManagementList
                                                  .map((e) => Container(
                                                        height: 30,
                                                        width: provider
                                                                    .rowHeaderForAttendanceManagementList
                                                                    .indexOf(
                                                                        e) ==
                                                                0
                                                            ? 130
                                                            : 70,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 1),
                                                        color: const Color(
                                                            0xffF0F3F5),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          e,
                                                          style: kNormalText
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Bold"),
                                                        ),
                                                      ))
                                            ],
                                          )
                                        : SizedBox(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              onUserTapped(data.myUser),
                                          child: DataTableFixedWidthWidget(
                                            data: data.userName,
                                            width: 130,
                                            isName: true,
                                          ),
                                        ),
                                        const DataTableFixedWidthWidget(
                                            data: "パート"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalWorkDay(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalActualWorkDay(data.shiftList ?? [], provider.dateList)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalPaidHoliday(provider.request, data.myUser?.nameKanJi ?? "", provider.dateList)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.remainingPaidHoliday(provider.request, data.myUser?.nameKanJi ?? "", provider.dateList, data.myUser?.annualLeave ?? 18)}"),
                                        const DataTableFixedWidthWidget(
                                            data: "16"),
                                        // const DataTableFixedWidthWidget(data: ""),
                                        // const DataTableFixedWidthWidget(data: ""),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalWorkOnHoliday(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.calculateTotalAbsent(data.shiftList ?? [], provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalLateTime(provider.entryList, provider.dateList, data.userName!)}"),
                                        // DataTableFixedWidthWidget(data: "${CommonUtils.totalLeaveEarly(provider.entryList, provider.dateList, data.userName!)}"),
                                        // DataTableFixedWidthWidget(data: "${CommonUtils.totalUnWorkHour(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalOvertimeWithinLaw(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalOvertimeNonStatutory(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalOvertime(provider.entryList, provider.dateList, data.userName!, isStandard: true)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalOvertime(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalMidnightWork(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalWorkOnHoliday(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalActualWorkingTime(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalWorkingTime(provider.entryList, provider.dateList, data.userName!)}"),
                                        DataTableFixedWidthWidget(
                                            data:
                                                "${CommonUtils.totalOvertime(provider.entryList, provider.dateList, data.userName!)}"),
                                      ],
                                    ),
                                  ],
                                );
                        }),
                  ),
                ),
              ),
            AppSize.spaceHeight30,
          ],
        ),
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
            summaryCardWidget(
                title: "実出勤日数",
                data:
                    "${CommonUtils.totalWorkDay(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "総出勤日数",
                data:
                    "${CommonUtils.totalActualWorkDay(provider.shiftList, provider.dateList)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "有休消化",
                data:
                    "${CommonUtils.totalPaidHoliday(provider.request, provider.selectedUserName, provider.dateList)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "有休残数",
                data:
                    "${CommonUtils.remainingPaidHoliday(provider.request, provider.selectedUserName ?? "", provider.dateList, 18)}")
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     summaryCardWidget(title: "公休日数", data: "16.00"),
        //     // const SizedBox(
        //     //   height: 3,
        //     // ),
        //     // summaryCardWidget(title: "特別休暇", data: ""),
        //     // const SizedBox(
        //     //   height: 3,
        //     // ),
        //     // summaryCardWidget(title: "振替日数", data: ""),
        //     // const SizedBox(
        //     //   height: 3,
        //     // ),
        //     // summaryCardWidget(title: "休出日数", data: "${DateToAPIHelper.formatTimeTwoDigits(provider.countDayOff.toString())}.00")
        //   ],
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(
                title: "欠勤日数",
                data:
                    "${CommonUtils.calculateTotalAbsent(provider.shiftList, provider.entryListByBranch, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "遅刻回数",
                data:
                    "${CommonUtils.totalLateTime(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "早退回数",
                data:
                    "${CommonUtils.totalLeaveEarly(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}.00"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "休出日数",
                data:
                    "${DateToAPIHelper.formatTimeTwoDigits(provider.countDayOff.toString())}.00")
            // summaryCardWidget(title: "不労時間", data: "")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(
                title: "法定内",
                data:
                    "${CommonUtils.totalOvertimeWithinLaw(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "法定外",
                data:
                    "${CommonUtils.totalOvertimeNonStatutory(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "基準残業",
                data:
                    "${CommonUtils.totalOvertimeWithinLaw(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "超過残業",
                data:
                    "${CommonUtils.totalOvertime(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryCardWidget(
                title: "深夜",
                data:
                    "${CommonUtils.totalMidnightWork(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "休出時間",
                data:
                    "${CommonUtils.totalBreakTime(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "実勤務時間",
                data:
                    "${CommonUtils.totalActualWorkingTime(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}"),
            const SizedBox(
              height: 3,
            ),
            summaryCardWidget(
                title: "総勤務時間",
                data:
                    "${CommonUtils.totalWorkingTime(provider.entryListByBranch, provider.dateList, provider.selectedUserName)}")
          ],
        ),
        summaryCardWidget(title: "公休日数", data: "16.00"),
        // summaryCardWidget(title: "所定外計", data: ""),
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
          decoration: BoxDecoration(
              color: data == "" ? Colors.redAccent : Colors.transparent,
              border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
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
  buildDataTableOvertimeByDay() {
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
                      provider.onChangeMonth(DateTime(provider.startDay.year,
                          provider.startDay.month - 1, provider.startDay.day));
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
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 10),
                        ),
                        Text(
                          "${toJapanMonthDayWeekday(provider.startDay)}",
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 14),
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
                            style: titleStyle.copyWith(
                                fontFamily: "Medium", fontSize: 10),
                          ),
                        ),
                        Text(
                          "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.startDay.year,
                          provider.startDay.month + 1, provider.startDay.day));
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
                            InkWell(
                              onTap: () async {
                                MyUser? user;
                                for (var entry in provider.entryList) {
                                  if (entry.myUser!.nameKanJi!.contains(provider
                                      .entryExitCalendarByUser[index]
                                      .userName!)) {
                                    user = entry.myUser;
                                    break;
                                  }
                                }
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                onUserTapped(user);
                              },
                              child: Container(
                                height: 120,
                                width: 115,
                                color: const Color(0xffF0F3F5),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "${provider.entryExitCalendarByUser[index].userName}",
                                  style: kTitleText.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 14),
                                ),
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
              child: provider.entryExitCalendarByUser.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ...provider.dateList.map((e) {
                              return Container(
                                  width: 48,
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        color: const Color(0xffF0F3F5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          e.day.toString(),
                                          style: kNormalText.copyWith(
                                              fontSize: 12, fontFamily: "Bold"),
                                        ),
                                      ),
                                      Container(
                                        width: 48,
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        color: const Color(0xffF0F3F5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          toJapanWeekDayWithInt(e.weekday),
                                          style: kNormalText.copyWith(
                                              fontSize: 12, fontFamily: "Bold"),
                                        ),
                                      ),
                                    ],
                                  )));
                            }).toList(),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        const EmptyDataWidget()
                      ],
                    )
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(dragDevices: {
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
                              headerGridLinesVisibility:
                                  GridLinesVisibility.none,
                              horizontalScrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              verticalScrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              columns: provider.dateList.map((e) {
                                return GridColumn(
                                    width: 48,
                                    label: Center(
                                        child: Column(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          color: const Color(0xffF0F3F5),
                                          alignment: Alignment.center,
                                          child: Text(
                                            e.day.toString(),
                                            style: kNormalText.copyWith(
                                                fontSize: 12,
                                                fontFamily: "Bold"),
                                          ),
                                        ),
                                        Container(
                                          width: 48,
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          color: const Color(0xffF0F3F5),
                                          alignment: Alignment.center,
                                          child: Text(
                                            toJapanWeekDayWithInt(e.weekday),
                                            style: kNormalText.copyWith(
                                                fontSize: 12,
                                                fontFamily: "Bold"),
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

  buildDataTableListOfShiftByUser() {
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
                      provider.onChangeMonth(DateTime(provider.startDay.year,
                          provider.startDay.month - 1, provider.startDay.day));
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
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 10),
                        ),
                        Text(
                          "${toJapanMonthDayWeekday(provider.startDay)}",
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 14),
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
                            style: titleStyle.copyWith(
                                fontFamily: "Medium", fontSize: 10),
                          ),
                        ),
                        Text(
                          "〜　${toJapanMonthDayWeekday(provider.endDay)}",
                          style: titleStyle.copyWith(
                              fontFamily: "Medium", fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.startDay.year,
                          provider.startDay.month + 1, provider.startDay.day));
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
                height: provider.shiftAndWorkTimeByUserList.length * 75,
                child: ListView.builder(
                    itemCount: provider.shiftAndWorkTimeByUserList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        height: 75,
                        width: 180,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => onUserTapped(
                                provider
                                    .shiftAndWorkTimeByUserList[index].myUser,
                              ),
                              child: Container(
                                height: 70,
                                width: 115,
                                color: const Color(0xffF0F3F5),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "${provider.shiftAndWorkTimeByUserList[index].userName}",
                                  style: kTitleText.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            AppSize.spaceWidth5,
                            Column(
                              children: [
                                displayDateWidget("予定", width: 60, height: 35),
                                displayDateWidget("実績", width: 60, height: 35),
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
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
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
                        source: entryExitAndShiftDataByUser,
                        columnWidthMode: ColumnWidthMode.fill,
                        isScrollbarAlwaysShown: false,
                        rowHeight: 75,
                        headerRowHeight: 65,
                        shrinkWrapRows: true,
                        shrinkWrapColumns: true,
                        gridLinesVisibility: GridLinesVisibility.none,
                        headerGridLinesVisibility: GridLinesVisibility.none,
                        horizontalScrollPhysics:
                            const AlwaysScrollableScrollPhysics(),
                        verticalScrollPhysics:
                            const AlwaysScrollableScrollPhysics(),
                        columns: provider.dateList.map((e) {
                          return GridColumn(
                              width: 48,
                              label: Center(
                                  child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 30,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    color: const Color(0xffF0F3F5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      e.day.toString(),
                                      style: kNormalText.copyWith(
                                          fontSize: 12, fontFamily: "Bold"),
                                    ),
                                  ),
                                  Container(
                                    width: 48,
                                    height: 30,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    color: const Color(0xffF0F3F5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      toJapanWeekDayWithInt(e.weekday),
                                      style: kNormalText.copyWith(
                                          fontSize: 12, fontFamily: "Bold"),
                                    ),
                                  ),
                                ],
                              )),
                              columnName: e.toString());
                        }).toList()
                        // +
                        // provider.moreMenuShiftAndWorkTimeByUserList
                        //     .map((e) => GridColumn(
                        //         width: 48,
                        //         label: Center(
                        //             child: Column(
                        //           children: [
                        //             Container(
                        //               width: 48,
                        //               height: 30,
                        //               margin: const EdgeInsets.symmetric(vertical: 1),
                        //               color: Colors.transparent,
                        //               alignment: Alignment.center,
                        //               child: Text(
                        //                 "",
                        //                 style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                        //               ),
                        //             ),
                        //             Container(
                        //               width: 48,
                        //               height: 30,
                        //               margin: const EdgeInsets.symmetric(vertical: 1),
                        //               color: const Color(0xffF0F3F5),
                        //               alignment: Alignment.center,
                        //               child: Text(
                        //                 e,
                        //                 style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //         columnName: e.toString()))
                        //     .toList()
                        ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  onChangeOverlayLoading(bool loading) {
    setState(() {
      loadingOverlay = loading;
    });
  }

  onUserTapped(MyUser? user) async {
    if (user != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: JapaneseText.basicInformation),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ],
              ),
              content: SizedBox(
                height: AppSize.getDeviceHeight(context) * 0.7,
                width: AppSize.getDeviceWidth(context),
                child: Scaffold(
                  body: SizedBox(
                      height: AppSize.getDeviceHeight(context) * 0.7,
                      width: AppSize.getDeviceWidth(context),
                      child: UserBasicInformationPage(myUser: user)),
                ),
              )));
    } else {
      toastMessageError("Not found user", context);
    }
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
        provider.setBranchId = authProvider.branch?.id ?? "";
        await provider.getEntryData(company!.uid!);
        // provider.getUserShift(company.uid!, authProvider.branch!.id!);
        entryExitHistoryDataSourceByDate =
            EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
        entryExitAndShiftDataByUser =
            EntryExitAndShiftDataByUser(provider: provider, onTap: () {});
        if (authProvider.myCompany?.branchList != []) {
          branch = authProvider.myCompany?.branchList!.first;
        }
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      String id = authProvider.myCompany?.uid ?? "";
      provider.setBranchId = authProvider.branch?.id ?? "";
      await provider.getEntryData(id);
      entryExitHistoryDataSourceByDate =
          EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
      entryExitAndShiftDataByUser =
          EntryExitAndShiftDataByUser(provider: provider, onTap: () {});
      // provider.getUserShift(id, authProvider.branch!.id!);
      if (authProvider.myCompany?.branchList != []) {
        branch = authProvider.myCompany?.branchList!.first;
      }
    }
  }
}

class TwoDimensionalScrollWidget extends StatelessWidget {
  final Widget child;

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  TwoDimensionalScrollWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 12.0,
      trackVisibility: true,
      interactive: true,
      controller: _verticalController,
      scrollbarOrientation: ScrollbarOrientation.right,
      thumbVisibility: true,
      child: Scrollbar(
        thickness: 12.0,
        trackVisibility: true,
        interactive: true,
        controller: _horizontalController,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        thumbVisibility: true,
        notificationPredicate: (ScrollNotification notif) => notif.depth == 1,
        child: SingleChildScrollView(
          controller: _verticalController,
          child: SingleChildScrollView(
            primary: false,
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
