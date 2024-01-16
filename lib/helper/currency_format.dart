import 'package:intl/intl.dart';

class CurrencyFormatHelper {
  static String displayData(String? amount) {
    final oCcy = NumberFormat("#,##0", "en_US");
    if (amount == null || amount == "") {
      amount = "0";
    }
    return '￥${oCcy.format(int.parse(amount)).toString()}';
  }

  static String displayDataRightYen(String? amount) {
    final oCcy = NumberFormat("#,##0", "en_US");
    if (amount == null || amount == "") {
      amount = "0";
    }
    return '${oCcy.format(int.parse(amount)).toString()}円';
  }
}
