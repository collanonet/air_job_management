import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static Future<void> waiting([int mili = 1000]) async {
    await Future.delayed(Duration(milliseconds: mili));
  }

  static List<DateTime> getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];

    // Iterate through the dates between start and end dates
    for (var i = startDate;
        i.isBefore(endDate) || i.isAtSameMomentAs(endDate);
        i = i.add(Duration(days: 1))) {
      dateRange.add(i);
    }

    return dateRange;
  }

  // static bool isDateInRange(
  //     DateTime date, DateTime startDate, DateTime endDate) {
  //   return date.isAfter(startDate) && date.isBefore(endDate);
  // }

  static bool isDateInRange(
      DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate) && date.isBefore(endDate) ||
        date.isAtSameMomentAs(startDate) ||
        date.isAtSameMomentAs(endDate);
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
        color: request.isHoliday == true
            ? const Color(0xff98A6B5)
            : AppColor.seaColor,
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
        decoration: BoxDecoration(
            color: backgroundColorStatusFromApiToLocal(status),
            border: Border.all(width: 1, color: const Color(0xff98A6B5))),
        child: Center(
          child: displayStatusText(status),
        ),
      );
    } else {
      return Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration:
            BoxDecoration(color: backgroundColorStatusFromApiToLocal(status)),
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
        style:
            kNormalText.copyWith(fontSize: 12, color: const Color(0xff98A6B5)),
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
}
