import 'package:flutter/material.dart';

class MyPageRoute {
  static void goTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static void goToReplace(context, child) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => child));
  }

  static void goAndRemoveAll(context, child) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => child), (Route<dynamic> route) => false);
  }
}
