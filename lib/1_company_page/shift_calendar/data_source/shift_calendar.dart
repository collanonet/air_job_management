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
    for (var job in provider.shiftBySeekerPerMonth) {
      _employeeData
          .add(DataGridRow(cells: job.calendarModels!.map((e) => DataGridCell<CalendarModel>(columnName: e.date.toString(), value: e)).toList()));
    }
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      CalendarModel calendarModel = e.value;
      ShiftModel? shiftModel;
      for (var shift in calendarModel.shiftModelList!) {
        if (CommonUtils.isTheSameDate(shift.date, DateTime.parse(e.columnName))) {
          ///Add more second shift, because there 2 shift a day, one is reject and one is approve
          if (shiftModel != null && shift.status == "approved") {
            shiftModel = shift;
          } else {
            shiftModel = shift;
          }
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
                  color: displayColor(shiftModel)[0],
                  border: Border.all(
                      width: shiftModel.status == "approved" ? 0 : 2,
                      color: shiftModel.status == "completed"
                          ? Colors.grey
                          : shiftModel.status == "approved"
                              ? Colors.white
                              : AppColor.primaryColor)),
              child: Text(
                "${shiftModel.startWorkTime}\n~\n${shiftModel.endWorkTime}",
                textAlign: TextAlign.center,
                style: kNormalText.copyWith(fontSize: 11, color: displayColor(shiftModel)[1], height: 1),
              ),
            );
    }).toList());
  }

  displayColor(ShiftModel shiftModel) {
    Color textColor = Colors.white;
    Color bgColor = Colors.white;
    if (shiftModel.status == "completed") {
      bgColor = Colors.grey;
      textColor = Colors.white;
    } else if (shiftModel.status == "approved") {
      bgColor = AppColor.primaryColor;
      textColor = Colors.white;
    } else if (shiftModel.status == "rejected") {
      bgColor = Colors.red;
      textColor = Colors.white;
    } else {
      bgColor = Colors.orange.withOpacity(0.2);
      textColor = Colors.black;
    }
    return [bgColor, textColor];
  }
}
