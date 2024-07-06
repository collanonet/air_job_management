import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/dateTime_Cal.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../helper/date_to_api.dart';
import '../models/entry_exit_history.dart';
import '../models/worker_model/shift.dart';

class CommonUtils {
  static Future<void> waiting([int mili = 1000]) async {
    await Future.delayed(Duration(milliseconds: mili));
  }

  static String normalize(String input) {
    input = input.toLowerCase().replaceAll('が', 'か゛').replaceAll('ぎ', 'き゛').replaceAll('ぐ', 'く゛').replaceAll('げ', 'け゛').replaceAll('ご', 'こ゛');
    // Normalize full-width characters to half-width
    input = input.replaceAllMapped(RegExp(r'[！-～]'), (match) {
      return String.fromCharCode(match.group(0)!.codeUnitAt(0) - 0xFEE0);
    });

    // Normalize full-width spaces to half-width spaces
    input = input.replaceAll('　', ' ');

    // Normalize Hiragana to Katakana
    input = input.replaceAllMapped(RegExp(r'[ぁ-ん]'), (match) {
      return String.fromCharCode(match.group(0)!.codeUnitAt(0) + 0x60);
    });

    // Lowercase the input for case-insensitive comparison
    print("Normalized Text ${input.toLowerCase()}");
    return input.toLowerCase();
  }

  static List<DateTime> getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];

    // Iterate through the dates between start and end dates
    for (var i = startDate; i.isBefore(endDate) || i.isAtSameMomentAs(endDate); i = i.add(Duration(days: 1))) {
      dateRange.add(i);
    }

    return dateRange;
  }

  // static bool isDateInRange(
  //     DateTime date, DateTime startDate, DateTime endDate) {
  //   return date.isAfter(startDate) && date.isBefore(endDate);
  // }

  static bool isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate) && date.isBefore(endDate) || date.isAtSameMomentAs(startDate) || date.isAtSameMomentAs(endDate);
  }

  static isTheSameDate(DateTime? d, DateTime? d2) {
    if (d == null || d2 == null) {
      return false;
    } else {
      if (d.day == d2.day && d.month == d2.month && d.year == d2.year) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool containsAny(List<String> array1, List<String> array2) {
    for (var item in array1) {
      if (array2.contains(item)) {
        return true;
      }
    }
    return false;
  }

  static bool containsAnyDate(List<DateTime> array1, List<DateTime> array2) {
    for (var item in array1) {
      if (array2.contains(item)) {
        return true;
      }
    }
    return false;
  }

  static isArrayOfDateContainDate(List<DateTime> dateList, DateTime date) {
    return dateList.contains(date);
  }

  convertStringToDoubleOrInt(String day) {
    if (day.contains(".")) {
      return num.parse(day);
    }
    return int.parse(day);
  }

  static check(array) {
    if (array.contains(true)) {
      return true;
    }
    return false;
  }

  static checkContainComplete(array, status) {
    if (array.contains(status)) {
      return true;
    }
    return false;
  }

  static getStatusOfRequest(Request request) {
    String title = "";
    if (request.isLeaveEarly == true) {
      title = "早退申請";
    } else if (request.isHoliday == true) {
      title = "休日申請";
    } else {
      title = "就業開始時間変更";
    }
    return title;
  }

  static displayRequestType(Request request) {
    String title = "";
    if (request.isLeaveEarly == true) {
      title = "早退申請";
    } else if (request.isHoliday == true) {
      title = "休日申請";
    } else {
      title = "就業開始時間変更";
    }
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: request.isHoliday == true ? const Color(0xff98A6B5) : AppColor.seaColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          title,
          style: kNormalText.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static Widget displayStatusForSeeker(String status) {
    if (status == "canceled" || status == "rejected") {
      return Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(color: backgroundColorStatusFromApiToLocal(status), border: Border.all(width: 1, color: const Color(0xff98A6B5))),
        child: Center(
          child: displayStatusText(status),
        ),
      );
    } else {
      return Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(color: backgroundColorStatusFromApiToLocal(status)),
        child: Center(
          child: displayStatusText(status),
        ),
      );
    }
  }

  static Widget displayStatusText(String status) {
    if (status == "canceled" || status == "rejected") {
      return Text(
        statusFromApiToLocal(status),
        style: kNormalText.copyWith(fontSize: 12, color: const Color(0xff98A6B5)),
      );
    } else {
      return Text(
        statusFromApiToLocal(status),
        style: kNormalText.copyWith(fontSize: 12, color: Colors.white),
      );
    }
  }

  static Color backgroundColorStatusFromApiToLocal(String status) {
    if (status == "approved") {
      return const Color(0xff7DC338);
    } else if (status == "canceled" || status == "rejected") {
      return AppColor.whiteColor;
    } else if (status == "pending") {
      return const Color(0xff6DC9E5);
    } else {
      return const Color(0xff98A6B5);
    }
  }

  static String statusFromApiToLocal(String status) {
    if (status == "approved") {
      return JapaneseText.jobStatusSeekerApproved;
    } else if (status == "canceled") {
      return JapaneseText.jobStatusSeekerCanceled;
    } else if (status == "rejected") {
      return JapaneseText.jobStatusSeekerRejected;
    } else if (status == "pending") {
      return JapaneseText.jobStatusSeekerPending;
    } else {
      return JapaneseText.jobStatusSeekerCompleted;
    }
  }

  static calculateOvertimeInEntry(EntryExitHistory entry, {bool? isOvertime, bool? withInLimit, bool? nonSat}) {
    ///Calculate break time
    var breakTime = calculateBreakTime(entry.scheduleEndBreakTime, entry.scheduleStartBreakTime);

    ///Schedule Working
    var scheduleWorking = calculateWorkingTime(entry.scheduleStartWorkingTime, entry.scheduleEndWorkingTime, "${breakTime[0]}:${breakTime[1]}");

    print("Date ${entry.workDate} - $scheduleWorking x ${entry.scheduleStartWorkingTime} x ${entry.scheduleEndWorkingTime}");

    ///Non Sat normally equal to overtimes
    entry.nonStatutoryOvertime = entry.overtime;

    double workHours = convertTimeStringToHours("${entry.workingHour}:${entry.workingMinute}");
    if (workHours >= 8) {
      workHours = 8;
    }
    String workingToString = convertToHoursAndMinutes(workHours);

    ///within statutory
    List<int> withinStatutoryData = calculateBreakTime(workingToString, "${scheduleWorking[0]}:${scheduleWorking[1]}");
    print("withinStatutoryData is $withinStatutoryData");
    if (withinStatutoryData[0] >= 8) {
      entry.overtimeWithinLegalLimit = "00:00";
    } else {
      entry.overtimeWithinLegalLimit =
          "${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[1].toString())}";
    }

    if (isOvertime == true) {
      return entry.overtime;
    } else if (withInLimit == true) {
      return entry.overtimeWithinLegalLimit;
    } else {
      return entry.nonStatutoryOvertime;
    }
  }

  static String displayWorkingWithBreakTime(EntryExitHistory entry) {
    var data = calculateBreakTime(entry.endWorkingTime, entry.startWorkingTime);
    return "${DateToAPIHelper.formatTimeTwoDigits(data[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(data[1].toString())}";
  }

  static String convertToHoursAndMinutes(double totalHours) {
    int hours = totalHours.floor();
    int minutes = ((totalHours - hours) * 60).round();
    return "${DateToAPIHelper.formatTimeTwoDigits(hours.toString())}:${DateToAPIHelper.formatTimeTwoDigits(minutes.toString())}";
  }

  static List<int> convertToHoursAndMinutesAsInt(double totalHours) {
    int hours = totalHours.floor();
    int minutes = ((totalHours - hours) * 60).round();
    return [hours, minutes];
  }

  static double convertTimeStringToHours(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return hours + (minutes / 60.0);
  }

  static totalPaidHoliday(List<Request> requestList, String username, List<DateTime> dateList) {
    int size = 0;
    for (var request in requestList) {
      DateTime date = DateToAPIHelper.fromApiToLocal(request.date!);
      DateTime start = dateList.first;
      DateTime end = dateList.last;
      if (request.isHoliday == true && CommonUtils.isDateInRange(date, start, end) && request.username == username) {
        size++;
      }
    }
    return size.toString();
  }

  static remainingPaidHoliday(List<Request> requestList, String username, List<DateTime> dateList, int paidHoliday) {
    int size = 0;
    for (var request in requestList) {
      DateTime date = DateToAPIHelper.fromApiToLocal(request.date!);
      DateTime start = dateList.first;
      DateTime end = dateList.last;
      if (request.isHoliday == true && CommonUtils.isDateInRange(date, start, end) && request.username == username) {
        size++;
      }
    }
    paidHoliday = paidHoliday - size;
    return paidHoliday.toString();
  }

  static totalWorkOnHoliday(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    List<String> workDateList = [];
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name && (d.weekday == 6 || d.weekday == 7)) {
        workDateList.add(entryList[i].workDate!);
      }
    }
    workDateList = workDateList.toSet().toList();
    return workDateList.length.toString();
  }

  static totalWorkDay(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    List<String> workDateList = [];
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi! == name) {
        workDateList.add(entryList[i].workDate!);
      }
    }
    workDateList = workDateList.toSet().toList();
    return workDateList.length.toString();
  }

  static totalActualWorkDay(List<ShiftModel> shiftList, List<DateTime> dateTimeList) {
    List<String> workDateList = [];
    for (int i = 0; i < shiftList.length; i++) {
      DateTime d = shiftList[i].date!;
      if (dateTimeList.contains(d)) {
        workDateList.add(shiftList[i].date.toString());
      }
    }
    workDateList = workDateList.toSet().toList();
    return workDateList.length.toString();
  }

  static calculateTotalAbsent(List<ShiftModel> shiftList, List<EntryExitHistory> entryList, List<DateTime> dateList, String name) {
    DateTime now = DateTime.now();
    List<DateTime> dateTimeList = [];
    for (var date in dateList) {
      if (CommonUtils.isDateInRange(date, dateList.first, now)) {
        dateTimeList.add(date);
      }
    }
    List<ShiftModel> scheduleList = shiftList;
    List<ShiftModel> scheduleList2 = [];
    scheduleList2 = [];
    for (var s in scheduleList) {
      if (dateTimeList.contains(s.date) && s.status == "approved") {
        scheduleList2.add(s);
      }
    }
    for (int i = 0; i < scheduleList2.length; i++) {
      DateTime scheduleDate = scheduleList2[i].date!;
      bool isAbsent = true;
      for (var entry in entryList) {
        if (entry.workDate != null && name == entry.myUser?.nameKanJi) {
          int year = int.parse(entry.workDate!.split("/")[0]);
          int month = int.parse(entry.workDate!.split("/")[1]);
          int day = int.parse(entry.workDate!.split("/")[2]);
          DateTime workDate = DateTime(year, month, day, 0, 0, 0);
          if (workDate == scheduleDate) {
            isAbsent = false;
            break;
          }
        }
      }
      if (isAbsent) {
        scheduleList2[i].isAbsent = "TRUE";
      } else {
        scheduleList2[i].isAbsent = "FALSE";
      }
    }
    scheduleList2 = scheduleList2.toSet().toList();
    List<ShiftModel> returnSchedule = [];
    for (var s in scheduleList2) {
      if (s.isAbsent == "TRUE") {
        returnSchedule.add(s);
      }
    }
    return returnSchedule.length.toString();
  }

  static totalLeaveEarly(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    List<String> workDateList = [];
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].isLeaveEarly == true && entryList[i].myUser!.nameKanJi == name) {
        workDateList.add(entryList[i].workDate!);
      }
    }
    workDateList = workDateList.toSet().toList();
    return workDateList.length.toString();
  }

  static totalLateTime(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    List<String> workDateList = [];
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].isLate == true && entryList[i].myUser!.nameKanJi == name) {
        workDateList.add(entryList[i].workDate!);
      }
    }
    workDateList = workDateList.toSet().toList();
    return workDateList.length.toString();
  }

  static totalOvertime(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name, {bool? isStandard}) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        entryList[i].overtime = calculateOvertimeInEntry(entryList[i], isOvertime: true);
        List<int> overTimeData = [int.parse(entryList[i].overtime!.split(":")[0]), int.parse(entryList[i].overtime!.split(":")[1])];
        hour += overTimeData[0];
        minute += overTimeData[1];
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    if (isStandard == true) {
      const int limitHours = 32;
      const int limitMinutes = 25;
      const Duration overtimeLimit = Duration(hours: limitHours, minutes: limitMinutes);
      // Example overtime to check
      Duration overtimeWorked = Duration(hours: totalHour, minutes: totalMinute); // You can change these values to test
      var testVal = overTimeLegalLimit - overTimeLegalLimit;
      // Check if the overtime exceeds the set limit
      if (overtimeWorked > overtimeLimit) {
        totalHour = 32;
        totalMinute = 25;
      }
    }
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalOvertimeWithinLaw(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      entryList[i].overtimeWithinLegalLimit = calculateOvertimeInEntry(entryList[i], withInLimit: true);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        hour += int.parse(entryList[i].overtimeWithinLegalLimit!.split(":")[0]);
        minute += int.parse(entryList[i].overtimeWithinLegalLimit!.split(":")[1]);
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalOvertimeNonStatutory(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      entryList[i].nonStatutoryOvertime = calculateOvertimeInEntry(entryList[i], nonSat: true);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        hour += int.parse(entryList[i].nonStatutoryOvertime!.split(":")[0]);
        minute += int.parse(entryList[i].nonStatutoryOvertime!.split(":")[1]);
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalOfWorkedDayCount(List<ShiftModel> shiftList, List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    ///Working days count - absence days count
    int count = 0;
    String absent = calculateTotalAbsent(shiftList, entryList, dateTimeList, name);
    String workDay = totalWorkDay(entryList, dateTimeList, name);
    int workDayCount = int.parse(workDay);
    int absentCount = int.parse(workDay);
    count = workDayCount - absentCount;
    return count.toString();
  }

  static totalWorkingWithBreakTime(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        var data = calculateWorkingTime(entryList[i].startWorkingTime, entryList[i].endWorkingTime, "00:00");
        hour += data[0];
        minute += data[1];
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalWorkingTimeCutBreakTime(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        hour += entryList[i].workingHour!;
        minute += entryList[i].workingMinute!;
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalBreakTime(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        hour += entryList[i].breakingTimeHour!;
        minute += entryList[i].breakingTimeMinute!;
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalUnWorkHour(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        hour += entryList[i].latHour!;
        minute += entryList[i].latHour!;
        hour += entryList[i].leaveEarlyHour!;
        minute += entryList[i].leaveEarlyMinute!;
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static totalMidnightWork(List<EntryExitHistory> entryList, List<DateTime> dateTimeList, String name) {
    int hour = 0;
    int minute = 0;
    for (int i = 0; i < entryList.length; i++) {
      DateTime d = DateToAPIHelper.fromApiToLocal(entryList[i].workDate!);
      // DateTime endWorkDate = DateToAPIHelper.fromApiToLocal(
      //     entryList[i].endWorkDate ?? entryList[i].workDate!);
      // int startWorkHour =
      //     int.parse(entryList[i].startWorkingTime!.split(":")[0]);
      // int startWorkMin =
      //     int.parse(entryList[i].startWorkingTime!.split(":")[1]);
      // int endWorkHour = 0;
      // int endWorkMinute = 0;
      // if (entryList[i].endWorkingTime != null &&
      //     entryList[i].startWorkingTime != "") {
      //   endWorkHour = int.parse(entryList[i].endWorkingTime!.split(":")[0]);
      //   endWorkMinute = int.parse(entryList[i].endWorkingTime!.split(":")[1]);
      // }
      if (dateTimeList.contains(d) && entryList[i].myUser!.nameKanJi == name) {
        // DateTime startDate =
        //     DateTime(d.year, d.month, d.day, startWorkHour, startWorkMin);
        // DateTime endDate = DateTime(endWorkDate.year, endWorkDate.month,
        //     endWorkDate.day, endWorkHour, endWorkMinute);
        // hour += calculateMidnightWork(startDate, endDate)[0] as int;
        // minute += calculateMidnightWork(startDate, endDate)[1] as int;
        hour += int.parse(entryList[i].midnightOvertime!.split(":")[0]);
        minute += int.parse(entryList[i].midnightOvertime!.split(":")[1]);
      }
    }
    int totalHour = hour + (minute ~/ 60);
    int totalMinute = minute % 60;
    return "${DateToAPIHelper.formatTimeTwoDigits(totalHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(totalMinute.toString())}";
  }

  static calculateMidnightWork(DateTime workStart, DateTime workEnd) {
    final DateTime midnightStart = DateTime(workStart.year, workStart.month, workStart.day, 22, 0); // 10 p.m.
    final DateTime midnightEnd = DateTime(workStart.year, workStart.month, workEnd.day, 5, 0); // 5 a.m. (next day)

    // Calculate the duration of midnight work
    Duration midnightWorkDuration = calculateMidnightWorkAsDuration(workStart, workEnd, midnightStart, midnightEnd);

    // Print the result
    // print(
    //     "$midnightStart $midnightEnd xxx Midnight work duration: ${midnightWorkDuration.inHours} hours and ${midnightWorkDuration.inMinutes % 60} minutes");
    return [midnightWorkDuration.inHours, midnightWorkDuration.inMinutes % 60];
  }

  static Duration calculateMidnightWorkAsDuration(DateTime workStart, DateTime workEnd, DateTime midnightStart, DateTime midnightEnd) {
    // Ensure the work period does not start after it ends
    if (workEnd.isBefore(workStart)) {
      workEnd = workStart;
      // throw ArgumentError("Work end time cannot be before work start time.");
    }

    // Calculate the overlap between work period and midnight period
    final overlapStart = workStart.isAfter(midnightStart) ? workStart : midnightStart;
    final overlapEnd = workEnd.isBefore(midnightEnd) ? workEnd : midnightEnd;

    if (overlapStart.isBefore(overlapEnd)) {
      return overlapEnd.difference(overlapStart);
    } else {
      // No overlap
      return Duration.zero;
    }
  }
}
