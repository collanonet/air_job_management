// import 'package:air_job_management/models/entry_exit_history.dart';
//
// class DateCal {
//   static String internalStudentWorkType = "留学生";
//
//   static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
//     return dateTime.subtract(Duration(days: dateTime.weekday - 1));
//   }
//
//   static int findTotalWorkingHourOfTheWeek(List<EntryExitHistory> list) {
//     DateTime firstDayOfWeek = findFirstDateOfTheWeek(DateTime.now());
//     int totalWorking = 0;
//     List<DateTime> dateTimeList = [];
//     //Loop from first day of the week to last day of week
//     for (int i = firstDayOfWeek.day; i < firstDayOfWeek.day + 6; i++) {
//       dateTimeList.add(DateTime(firstDayOfWeek.year, firstDayOfWeek.month, i));
//     }
//     int minute = 0;
//     //Loop in entry exit history
//     for (int i = 0; i < list.length; i++) {
//       int year = int.parse(list[i].workDate!.split("/")[0]);
//       int month = int.parse(list[i].workDate!.split("/")[1]);
//       int day = int.parse(list[i].workDate!.split("/")[2]);
//       DateTime date = DateTime(year, month, day);
//       if (dateTimeList.contains(date)) {
//         totalWorking += int.parse(list[i].workingHours.toString());
//         minute += int.parse(list[i].workingMinute.toString());
//       }
//     }
//     // int moMinute = int.parse((minute / 60).toStringAsFixed(2).split(".")[1]);
//     totalWorking += int.parse((minute / 60).toString().split(".")[0]);
//     print("Total Working Hour $totalWorking");
//     return totalWorking;
//   }
//
//   static bool validateWorkType(String type, List<EntryExitHistory> list) {
//     print("Type $type");
//     if (type == internalStudentWorkType && findTotalWorkingHourOfTheWeek(list) >= 28) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   List<DateTime> getDatesBetween(DateTime startDate, DateTime endDate) {
//     List<DateTime> dates = [];
//     for (var date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
//       dates.add(date);
//     }
//     return dates;
//   }
// }
