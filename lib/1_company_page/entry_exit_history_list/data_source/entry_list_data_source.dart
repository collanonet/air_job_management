import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class EntryListDataSource extends DataTableSource {
  final List<EntryExitHistory> data;
  final Function ratting;

  EntryListDataSource({required this.data, required this.ratting});

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
        "${entry.myUser?.nameKanJi}",
        style: kNormalText,
      )),
      DataCell(Text(
        "パート",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.scheduleStartWorkingTime} ~ ${entry.scheduleEndWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        "${entry.startWorkingTime} ~ ${entry.endWorkingTime}",
        style: kNormalText,
      )),
      DataCell(Text(
        entry.startWorkingTime.toString().isNotEmpty && entry.endWorkingTime.toString().isEmpty
            ? "仕事"
            : entry.startWorkingTime.toString().isEmpty
                ? "不在"
                : "勤務外",
        style: kNormalText.copyWith(
            color: entry.startWorkingTime.toString().isNotEmpty && entry.endWorkingTime.toString().isEmpty
                ? Colors.orangeAccent
                : entry.startWorkingTime.toString().isEmpty
                    ? Colors.red
                    : Colors.green),
      )),
      DataCell(InkWell(
        onTap: () => ratting(entry),
        child: Text(
          entry.review != null ? "${entry.review?.rate}🌟" : "今の評価",
          style: kNormalText,
        ),
      )),
      DataCell(InkWell(
        onTap: () => ratting(entry),
        child: Text(
          entry.review != null ? entry.review?.comment ?? "" : "",
          style: kNormalText,
        ),
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
