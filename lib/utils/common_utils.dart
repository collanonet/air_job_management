class CommonUtils {
  static Future<void> waiting([int mili = 1000]) async {
    await Future.delayed(Duration(milliseconds: mili));
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
}
