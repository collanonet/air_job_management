extension StringExtend on String {
  removeSlash() {
    return replaceAll("/", "");
  }
}

extension DateTimeExtensions on DateTime {
  bool isAfterOrEqualTo(DateTime other) {
    return !isBefore(other) || isAtSameMomentAs(other);
  }

  bool isBeforeOrEqualTo(DateTime other) {
    return !isAfter(other) || isAtSameMomentAs(other);
  }
}
