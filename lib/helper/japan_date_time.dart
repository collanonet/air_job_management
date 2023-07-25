import 'package:intl/intl.dart';

toJapanDateTime(DateTime dateTime) {
  return "${dateTime.year}/${dateTime.month}/${dateTime.day}（${toJapanWeekDay(DateFormat('EEEE').format(dateTime).toString())}） ${DateFormat.Hm().format(dateTime)}";
}

toJapanDate(DateTime? dateTime) {
  if (dateTime != null) {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}（${toJapanWeekDay(DateFormat('EEEE').format(dateTime).toString())}）";
  } else {
    return "";
  }
}

toJapanDateWithoutWeekDay(DateTime dateTime) {
  return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
}

toJapanMonthAndYear(DateTime dateTime) {
  return "${dateTime.year}年${dateTime.month}月";
}

toJapanMonthAndYearDay(DateTime dateTime) {
  return "${dateTime.year}年${dateTime.month}月${dateTime.day}日";
}

dateTimeToHourAndMinute(DateTime? dateTime) {
  return dateTime != null ? DateFormat.Hm().format(dateTime).toString() : "";
}

String toJapanWeekDay(String day) {
  if (day == "Monday") {
    return "月";
  }
  if (day == "Tuesday") {
    return "火";
  }
  if (day == "Wednesday") {
    return "水";
  }
  if (day == "Thursday") {
    return "木";
  }
  if (day == "Friday") {
    return "金";
  }
  if (day == "Saturday") {
    return "土";
  } else {
    return "日";
  }
}

String toJapanWeekDayWithInt(int day) {
  if (day == 1) {
    return "月";
  }
  if (day == 2) {
    return "火";
  }
  if (day == 3) {
    return "水";
  }
  if (day == 4) {
    return "木";
  }
  if (day == 5) {
    return "金";
  }
  if (day == 6) {
    return "土";
  } else {
    return "日";
  }
}
