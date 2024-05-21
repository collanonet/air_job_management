import 'package:air_job_management/models/shift_and_work_time.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/style.dart';

class EntryExitAndShiftDataByUser extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  EntryExitAndShiftDataByUser({required EntryExitHistoryProvider provider, required this.onTap}) {
    for (var entry in provider.shiftAndWorkTimeByUserList) {
      _employeeData.add(DataGridRow(
          cells: entry.list.map((e) {
                return DataGridCell<ShiftAndWorkTime>(columnName: e.date.toString(), value: e.shiftAndWorkTime);
              }).toList() +
              provider.moreMenuShiftAndWorkTimeByUserList
                  .map((e) => DataGridCell<ShiftAndWorkTime>(columnName: e, value: ShiftAndWorkTime(scheduleStartWorkTime: null)))
                  .toList()));
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
      ShiftAndWorkTime? entryByDate = e.value;
      return entryByDate != null
          ? entryByDate.scheduleStartWorkTime == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [displayDateWidget("0"), displayDateWidget("0")],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    displayDateWidget("${entryByDate.scheduleStartWorkTime}\n~\n${entryByDate.scheduleEndWorkTime}"),
                    displayDateWidget("${entryByDate.startWorkTime}\n~\n${entryByDate.endWorkTime}"),
                  ],
                )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                displayDateWidget("00:00"),
                displayDateWidget(
                  "00:00",
                ),
              ],
            );
    }).toList());
  }

  displayDateWidget(String data) {
    return Container(
      width: 48,
      height: 35,
      decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
      child: Center(
        child: Text(
          data,
          style: kNormalText.copyWith(fontSize: 10, height: 0.8),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
