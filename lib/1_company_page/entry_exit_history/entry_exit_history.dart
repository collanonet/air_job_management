import 'package:air_job_management/1_company_page/entry_exit_history/widget/filter.dart';
import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../helper/japan_date_time.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';

class EntryExitHistoryPage extends StatefulWidget {
  const EntryExitHistoryPage({super.key});

  @override
  State<EntryExitHistoryPage> createState() => _EntryExitHistoryPageState();
}

class _EntryExitHistoryPageState extends State<EntryExitHistoryPage> with AfterBuildMixin {
  late EntryExitHistoryProvider provider;
  late EntryExitHistoryDataSource entryExitHistoryDataSource;

  @override
  void initState() {
    Provider.of<EntryExitHistoryProvider>(context, listen: false).setLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<EntryExitHistoryProvider>(context);
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
                    buildMonthDisplay(),
                    AppSize.spaceHeight16,
                    buildData(),
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
    String id = Provider.of<AuthProvider>(context, listen: false).myCompany?.uid ?? "";
    await provider.getEntryData(id);
    entryExitHistoryDataSource = EntryExitHistoryDataSource(employeeData: provider.entryList);
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
