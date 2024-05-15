import 'dart:ui';

import 'package:air_job_management/1_company_page/entry_exit_history/data_source/entry_exit_data_source_by_date.dart';
import 'package:air_job_management/1_company_page/entry_exit_history/widget/filter.dart';
import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../api/user_api.dart';
import '../../helper/japan_date_time.dart';
import '../../models/company.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';

class EntryExitHistoryPage extends StatefulWidget {
  const EntryExitHistoryPage({super.key});

  @override
  State<EntryExitHistoryPage> createState() => _EntryExitHistoryPageState();
}

class _EntryExitHistoryPageState extends State<EntryExitHistoryPage> with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late EntryExitHistoryDataSource entryExitHistoryDataSource;
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
          child: Column(
            children: [
              const EntryFilterWidget(),
              AppSize.spaceHeight16,
              IconButton(
                  onPressed: () {
                    EntryExitApiService().insertDataForTesting(provider.entryList);
                  },
                  icon: const Icon(Icons.refresh)),
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
                    if (provider.selectDisplay == provider.displayList[0]) buildDataTableByDay() else buildMonthDisplay(),
                  ],
                ),
              )
            ],
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
          onTap: () {
            entryExitHistoryDataSource = EntryExitHistoryDataSource(employeeData: provider.entryList);
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
                      onPressed: () async {},
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 25,
                        color: AppColor.primaryColor,
                      )),
                  Text(
                    "     ${branch?.name}     ",
                    style: kTitleText.copyWith(color: AppColor.primaryColor),
                  ),
                  IconButton(
                      onPressed: () async {},
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
          buildData()
        ],
      ),
    );
  }

  ScrollController horizontalScroll1 = ScrollController();

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

  buildData() {
    return provider.isLoading
        ? const SizedBox()
        : SfDataGrid(
            source: entryExitHistoryDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            shrinkWrapRows: true,
            shrinkWrapColumns: true,
            headerRowHeight: 30,
            rowHeight: 35,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            columns: provider.rowHeaderTable.map((e) {
              return GridColumn(
                  width: 100,
                  label: Container(
                    width: 100,
                    height: 30,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    color: const Color(0xffF0F3F5),
                    alignment: Alignment.center,
                    child: Text(
                      e,
                      style: kNormalText.copyWith(fontSize: 12, fontFamily: "Bold"),
                    ),
                  ),
                  columnName: e.toString());
            }).toList());
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
        entryExitHistoryDataSource = EntryExitHistoryDataSource(employeeData: provider.entryList);
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
      entryExitHistoryDataSource = EntryExitHistoryDataSource(employeeData: provider.entryList);
      entryExitHistoryDataSourceByDate = EntryExitHistoryDataSourceByDate(provider: provider, onTap: () {});
      if (authProvider.myCompany?.branchList != []) {
        branch = authProvider.myCompany?.branchList!.first;
      }
    }
  }
}

class EntryExitHistoryDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EntryExitHistoryDataSource({required List<EntryExitHistory> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'index', value: employeeData.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'date', value: e.workDate),
              DataGridCell<String>(columnName: 'start_work_time', value: e.startWorkingTime),
              DataGridCell<String>(columnName: 'end_working_time', value: e.endWorkingTime),
              DataGridCell<String>(columnName: 'salary', value: e.amount.toString()),
              DataGridCell<int>(columnName: 'index', value: employeeData.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'date', value: e.workDate),
              DataGridCell<String>(columnName: 'start_work_time', value: e.startWorkingTime),
              DataGridCell<String>(columnName: 'end_working_time', value: e.endWorkingTime),
              DataGridCell<String>(columnName: 'salary', value: e.amount.toString()),
              DataGridCell<int>(columnName: 'index', value: employeeData.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'date', value: e.workDate),
              DataGridCell<String>(columnName: 'start_work_time', value: e.startWorkingTime),
              DataGridCell<String>(columnName: 'end_working_time', value: e.endWorkingTime),
              DataGridCell<String>(columnName: 'salary', value: e.amount.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
