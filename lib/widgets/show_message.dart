import 'package:air_job_management/utils/app_color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageWidget {
  static show(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        webPosition: "center",
        textColor: AppColor.whiteColor,
        fontSize: 16.0);
  }
}
