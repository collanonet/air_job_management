import 'package:flutter/material.dart';

class Logger {
  static printLog(msg) {
    debugPrint("Logger =>> ${msg.toString()}");
  }
}
