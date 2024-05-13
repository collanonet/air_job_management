import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/job_posting.dart';
import '../../../providers/company/shift_calendar.dart';
import '../../../utils/app_color.dart';
import '../../../utils/style.dart';

class ShiftCalendarDataSourceByJobPosting extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  ShiftCalendarDataSourceByJobPosting(
      {required ShiftCalendarProvider provider, required this.onTap}) {
    for (var job in provider.jobPostingDataTableList) {
      _employeeData.add(DataGridRow(
          cells: job.countByDate.map((e) {
        return DataGridCell<CountByDate?>(
            columnName: e.date.toString(), value: e);
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
      CountByDate job = e.value;
      if (job.recruitNumber == null || job.recruitNumber == "") {
        job.recruitNumber = "5";
      }
      // print("Job ${job.date} ${job.count}/${job.recruitNumber}");
      return InkWell(
        onTap: () => onTap(job),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: int.parse(job.recruitNumber) <= job.count
                  ? Colors.green
                  : Colors.orange.withOpacity(0.2),
              border: Border.all(
                  width: int.parse(job.recruitNumber) <= job.count ? 0 : 2,
                  color: int.parse(job.recruitNumber) <= job.count
                      ? Colors.green
                      : AppColor.secondaryColor)),
          child: Text(
            "${job.count}/${job.recruitNumber}",
            textAlign: TextAlign.center,
            style: kNormalText.copyWith(
                fontSize: 11,
                color: int.parse(job.recruitNumber) <= job.count
                    ? Colors.white
                    : Colors.black,
                height: 1),
          ),
        ),
      );
    }).toList());
  }
}
