import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class StatusHelper {
  displayStatus(String? status) {
    return Container(
      height: 40,
      width: 110,
      decoration: BoxDecoration(
        color: checkRequestColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          englishToJapan(status),
          style: kNormalText.copyWith(fontSize: 14, fontFamily: "Bold", color: Colors.white),
        ),
      ),
    );
  }

  static checkRequestColor(String? status) {
    if (status == "approved") {
      return const Color(0xff6DC9E5);
    } else if (status == "canceled" || status == "rejected") {
      return Colors.redAccent;
    } else {
      return AppColor.primaryColor;
    }
  }

  static englishToJapan(String? status) {
    if (status == "approved") {
      return JapaneseText.hired;
    } else if (status == "canceled") {
      return JapaneseText.canceled;
    } else if (status == "pending") {
      return JapaneseText.pending;
    } else {
      return JapaneseText.pending;
    }
  }

  static japanToEnglish(String? status) {
    if (status == JapaneseText.hired) {
      return "approved";
    } else if (status == JapaneseText.canceled) {
      return "canceled";
    } else if (status == JapaneseText.pending) {
      return "pending";
    } else {
      return "pending";
    }
  }
}
