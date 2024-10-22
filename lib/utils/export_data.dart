import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../helper/date_to_api.dart';
import '../models/entry_exit_history.dart';
import 'common_utils.dart';

class ExportData {
  void generateWorkRecordCSV(List<EntryExitHistory> entryExitList3, String staffId, List<DateTime> dateTimeList) {
    // we will declare the list of headers that we want
    List<String> rowHeader = [
      "社員番号",
      // "氏名",
      "対象年月日",
      "始業時刻",
      "就業時刻",
      "休憩開始",
      "休憩終了",
      // JapaneseText.workGroup,
      // JapaneseText.groupId,
    ];
    // here we will make a 2D array to handle a row
    List<List<dynamic>> rows = [];
    //First add entire row header into our first row
    rows.add(rowHeader);
    //Now lets add 5 data rows
    for (var data in dateTimeList) {
      List<dynamic> dataRow = [];
      EntryExitHistory? entryExit;
      for (var entry in entryExitList3) {
        int year = int.parse(entry.workDate!.split("/")[0]);
        int month = int.parse(entry.workDate!.split("/")[1]);
        int day = int.parse(entry.workDate!.split("/")[2]);
        DateTime date = DateTime(year, month, day);
        if (CommonUtils.isTheSameDate(date, data) && staffId.contains(entry.myUser?.nameKanJi ?? "")) {
          entryExit = entry;
          break;
        }
      }
      dataRow.add(staffId);
      // dataRow.add(staffName);
      dataRow.add(_convertDateToString(data));
      if (entryExit != null) {
        String userStartWorkingTime = entryExit.startWorkingTime ?? "09:00";
        String userEndWorkingTime = entryExit.endWorkingTime == "" || entryExit.endWorkingTime == null ? "18:00" : entryExit.endWorkingTime!;
        dataRow.add(
            " ${DateToAPIHelper.formatTimeTwoDigits(userStartWorkingTime.split(":")[0])}:${DateToAPIHelper.formatTimeTwoDigits(userStartWorkingTime.split(":")[1])}");
        dataRow.add(
            "${DateToAPIHelper.formatTimeTwoDigits(userEndWorkingTime.split(":")[0])}:${DateToAPIHelper.formatTimeTwoDigits(userEndWorkingTime.split(":")[1])}");
        if (entryExit.scheduleStartBreakTime == null || entryExit.scheduleStartBreakTime == "00:00" || entryExit.scheduleEndBreakTime == "null") {
          dataRow.add("12:00");
          dataRow.add("13:00");
        } else {
          dataRow.add("${entryExit.scheduleStartBreakTime}");
          dataRow.add("${entryExit.scheduleEndBreakTime}");
        }
        rows.add(dataRow);
      } else {
        dataRow.add("");
        dataRow.add("");
        dataRow.add("");
        dataRow.add("");
        dataRow.add("");
        dataRow.add("");
        rows.add(dataRow);
      }
    }
    String url = "";
    if (defaultTargetPlatform != TargetPlatform.macOS) {
      String csv = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);
      List<int> excelCsvBytes = [0xEF, 0xBB, 0xBF]..addAll(utf8.encode(csv));
      String base64ExcelCsvBytes = base64Encode(excelCsvBytes);
      url = "data:text/plain;charset=utf-8;base64,$base64ExcelCsvBytes";
    } else {
      String csv = const ListToCsvConverter().convert(rows);
      List<int> excelCsvBytes = [0xEF, 0xBB, 0xBF]..addAll(utf8.encode(csv));
      String base64ExcelCsvBytes = base64Encode(excelCsvBytes);
      url = "data:text/plain;charset=utf-8;base64,$base64ExcelCsvBytes";
    }
//It will create anchor to download the file
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '勤務実績.csv';
//finally add the csv anchor to body
    html.document.body!.children.add(anchor);
// Cause download by calling this function
    anchor.click();
//revoke the object
    html.Url.revokeObjectUrl(url);
  }

  String _convertDateToString(DateTime now) {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return " " + formattedDate;
    //return formattedDate.split('-').join('/');
  }
}
