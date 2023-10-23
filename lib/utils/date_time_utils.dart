import 'package:intl/intl.dart';

class MyDateTimeUtils {
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

extension DateTimeUtils on DateTime {
  String get getOnlyDate {
    return DateFormat("dd MMM, yyyy").format(this);
  }

  String get getOnlyTime {
    return DateFormat("hh:mm a").format(this);
  }

  String get getDateTimeFormat {
    return DateFormat("dd MMM, yyyy - hh:mm a").format(this);
  }
}
