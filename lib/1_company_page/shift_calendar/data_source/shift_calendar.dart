import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/calendar.dart';
import '../../../models/worker_model/shift.dart';
import '../../../providers/company/shift_calendar.dart';
import '../../../utils/app_color.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/style.dart';

class ShiftCalendarDataSource extends DataGridSource {
  // ignore: non_constant_identifier_names
  /// Creates the employee data source class with required details.
  ShiftCalendarDataSource({required ShiftCalendarProvider provider}) {
    for (var job in provider.jobApplyPerDay) {
      _employeeData.add(DataGridRow(
          cells: provider.rangeDateList
              .map((e) => DataGridCell<GroupedCalendarModel>(
                  columnName: e.date.toString(),
                  value: GroupedCalendarModel(
                      applyName: job.myUser?.nameKanJi ?? "Empty", allShiftModels: job.shiftList, calendarModels: [], status: job.status)))
              .toList()));
    }
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      GroupedCalendarModel calendarModel = e.value;
      ShiftModel? shiftModel;
      for (var shift in calendarModel.allShiftModels!) {
        if (CommonUtils.isTheSameDate(shift.date, DateTime.parse(e.columnName))) {
          shiftModel = shift;
        }
      }
      return shiftModel == null
          ? Container(
              margin: const EdgeInsets.all(1),
              color: const Color(0xffF0F3F5),
            )
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: calendarModel.status == "approved" ? AppColor.primaryColor : Colors.orange.withOpacity(0.2),
                  border: Border.all(
                      width: calendarModel.status == "approved" ? 0 : 2,
                      color: calendarModel.status == "approved" ? Colors.white : AppColor.primaryColor)),
              child: Text(
                "${shiftModel.startWorkTime}\n~\n${shiftModel.endWorkTime}",
                textAlign: TextAlign.center,
                style: kNormalText.copyWith(fontSize: 11, color: calendarModel.status == "approved" ? Colors.white : Colors.black, height: 1),
              ),
            );
    }).toList());
  }
}
