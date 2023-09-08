class CommonUtils {
  static Future<void> waiting([int mili = 1000]) async {
    await Future.delayed(Duration(milliseconds: mili));
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
