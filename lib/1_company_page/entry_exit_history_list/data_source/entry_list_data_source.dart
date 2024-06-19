import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../../utils/style.dart';
import '../../job_posting/create_or_edit_job_posting.dart';

class EntryListDataSource extends DataTableSource {
  final List<EntryExitHistory> data;
  final Function ratting;
  final Function onUserTap;
  final BuildContext context;

  EntryListDataSource({required this.data, required this.ratting, required this.onUserTap, required this.context});

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
      DataCell(InkWell(
        onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: CreateOrEditJobPostingPageForCompany(
                    isView: true,
                    jobPosting: entry.jobID,
                  ),
                )),
        child: Text(
          "${entry.jobTitle}",
          style: kNormalText.copyWith(color: AppColor.primaryColor),
        ),
      )),
      DataCell(InkWell(
        onTap: () => onUserTap(entry.myUser),
        child: Text(
          "${entry.myUser?.nameKanJi}",
          style: kNormalText.copyWith(color: AppColor.primaryColor),
        ),
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
        entry.startWorkingTime.toString().isNotEmpty && (entry.endWorkingTime.toString().isEmpty || entry.endWorkingTime.toString() == "00:00")
            ? "仕事"
            : entry.startWorkingTime.toString().isEmpty
                ? "不在"
                : "勤務外",
        style: kNormalText.copyWith(
            color: entry.startWorkingTime.toString().isNotEmpty &&
                    (entry.endWorkingTime.toString().isEmpty || entry.endWorkingTime.toString() == "00:00")
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
