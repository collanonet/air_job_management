import 'package:air_job_management/models/entry_calendar_by_user.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/style.dart';

class EntryExitHistoryDataSourceByDate extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  EntryExitHistoryDataSourceByDate({required EntryExitHistoryProvider provider, required this.onTap}) {
    _employeeData.add(DataGridRow(
        cells: provider.entryCalendarList.map((e) {
      return DataGridCell<EntryCalendarByUserList>(columnName: e.date.toString(), value: e);
    }).toList()));
  }
  final Function onTap;
  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      EntryCalendarByUserList list = e.value as EntryCalendarByUserList;
      var entryByDate = list.list!.length > 0 ? list.list![0] : null;
      return entryByDate == null
          ? SizedBox()
          : Column(
              children: [
                Text(
                  "${entryByDate.totalOvertime}",
                  style: kNormalText,
                ),
                Text(
                  "${entryByDate.nonStatutoryOvertime}",
                  style: kNormalText,
                ),
                Text(
                  "${entryByDate.withinLegal}",
                  style: kNormalText,
                ),
                Text(
                  "${entryByDate.holidayWork}",
                  style: kNormalText,
                ),
              ],
            );
    }).toList());
  }
}
