import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class EntryListDataSource extends DataTableSource {
  final List<EntryExitHistory> data;

  EntryListDataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final entry = data[index];

    return DataRow(cells: [
      DataCell(Text(
        "${entry.workDate}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.jobTitle}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.startWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.endWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        entry.isLate == true ? "Late" : "No",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.scheduleStartWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.scheduleEndWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.endWorkingTime!.isEmpty ? "Working" : "Completed"}",
        style: kNormalText,
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
