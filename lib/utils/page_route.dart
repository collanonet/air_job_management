import 'package:flutter/material.dart';

class MyPageRoute {
  static void goTo(Widget widget, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static void goToWithReplacement(Widget widget, BuildContext context, {Function? onBack}) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  }

  static void goToAndRemoveAllPages(Widget widget, BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (Route<dynamic> route) => false);
  }
}
