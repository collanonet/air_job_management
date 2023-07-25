import 'package:flutter/material.dart';

class StatusHelper {
  static checkRequest(String status) {
    if (status == "approved") {
      return Colors.green;
    } else if (status == "canceled" || status == "rejected") {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  static englishToJapan(String status) {
    if (status == "approved") {
      return "承認済み";
    } else if (status == "canceled") {
      return "キャンセル";
    } else if (status == "rejected") {
      return "却下済み";
    } else if (status == "pending") {
      return "未承認";
    } else {
      return "";
    }
  }
}
