import 'package:air_job_management/models/entry_calendar_by_user.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/style.dart';

class EntryExitHistoryDataSourceByDate extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  EntryExitHistoryDataSourceByDate(
      {required EntryExitHistoryProvider provider, required this.onTap}) {
    for (var entry in provider.entryExitCalendarByUser) {
      _employeeData.add(DataGridRow(
          cells: entry.list.map((e) {
        return DataGridCell<Entry>(
            columnName: e.date.toString(), value: e.entry);
      }).toList()));
    }
  }
  final Function onTap;
  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      Entry? entryByDate = e.value;
      return entryByDate != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                displayDateWidget(
                  "${entryByDate.totalOvertime}",
                ),
                displayDateWidget(
                  "${entryByDate.nonStatutoryOvertime}",
                ),
                displayDateWidget(
                  "${entryByDate.withinLegal}",
                ),
                displayDateWidget(
                  "${entryByDate.holidayWork}",
                ),
              ],
            )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          displayDateWidget(
            "",
          ),
          displayDateWidget(
            "",
          ),
          displayDateWidget(
            "",
          ),
          displayDateWidget(
            "",
          ),
        ],
      );
    }).toList());
  }
}

displayDateWidget(String data, {double? width, double? height}) {
  return Container(
    width: width ?? 48,
    height: height ?? 30,
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
    child: Center(
      child: Text(
        data,
        style: kNormalText.copyWith(fontSize: 12),
      ),
    ),
  );
}
