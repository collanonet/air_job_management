import 'package:intl/intl.dart';

class DateToAPIHelper {
  static var formatter = DateFormat('yyyy-MM-dd');

  static String convertDateToString(DateTime now) {
    String formattedDate = formatter.format(now);
    return formattedDate.split('-').join('/');
  }

  static DateTime fromApiToLocal(String date) {
    if (date.isEmpty) {
      return DateTime(5000);
    }
    String dateTime = date.split('/').join('-');
    return DateTime.parse(dateTime);
  }

  static DateTime timeToDateTime(String date, {DateTime? dateTime}) {
    if (date.isEmpty || !date.contains(":")) {
      return DateTime(5000);
    }
    DateTime now = DateTime.now();
    if (dateTime != null) {
      now = dateTime;
    }
    return DateTime(now.year, now.month, now.day, int.parse(date.split(":")[0]), int.parse(date.split(":")[1]));
  }

  static String timeFormat(DateTime? dateTime) {
    if (dateTime == null) {
      return "00:00";
    } else {
      return DateFormat.Hm().format(dateTime).toString();
    }
  }

  static String formatTimeTwoDigits(String time) {
    if (time == null || time == "null" || time.isEmpty) {
      return "";
    } else if (time.length == 1) {
      return "0" + time;
    }
    return time;
  }
}
