import 'package:air_job_management/1_company_page/entry_exit_history/widget/filter.dart';
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
  late EntryExitHistoryDataSourceByDay entryExitHistoryDataSourceByDay;
  late AuthProvider authProvider;
  Branch? branch;

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
    return SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const EntryFilterWidget(),
              AppSize.spaceHeight16,
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
            entryExitHistoryDataSourceByDay = EntryExitHistoryDataSourceByDay(provider: provider);
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
        SfDataGrid(
            source: entryExitHistoryDataSourceByDay,
            columnWidthMode: ColumnWidthMode.fill,
            isScrollbarAlwaysShown: false,
            rowHeight: 45,
            headerRowHeight: 45,
            shrinkWrapRows: true,
            shrinkWrapColumns: true,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            // horizontalScrollController: scrollController1,
            horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
            columns:
                provider.dateList.map((e) => GridColumn(width: 45, label: Center(child: Text("${e.day.toString()}")), columnName: '$e')).toList())
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
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'index',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        '日付',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'date',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '曜日',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'start_work_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        'シフト',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'end_working_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '出勤',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '退勤',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'index',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '有休',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'date',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '遅刻',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'start_work_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '早退',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'end_working_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '実働',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '法定内',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'index',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '法定外',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'date',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '休日出勤',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'start_work_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '所労外',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'end_working_time',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '所労外累計',
                        style: kNormalText,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        '総勤務時間',
                        style: kNormalText,
                        overflow: TextOverflow.ellipsis,
                      ))),
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
        entryExitHistoryDataSource = EntryExitHistoryDataSource(employeeData: provider.entryList);
        entryExitHistoryDataSourceByDay = EntryExitHistoryDataSourceByDay(provider: provider);
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
      entryExitHistoryDataSourceByDay = EntryExitHistoryDataSourceByDay(provider: provider);
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

class EntryExitHistoryDataSourceByDay extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  EntryExitHistoryDataSourceByDay({required EntryExitHistoryProvider provider}) {
    _employeeData = [
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
      DataGridRow(cells: provider.dateList.map((e) => DataGridCell<String>(columnName: '$e', value: "07:00")).toList()),
    ];
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
        child: Text(
          e.value.toString(),
          style: kNormalText.copyWith(fontSize: 11),
        ),
      );
    }).toList());
  }
}
