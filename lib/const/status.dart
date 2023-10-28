import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/japanese_text.dart';

class StatusUtils {
  static const String active = "active";
  static const String delete = "delete";

  static displayStatus(String? status) {
    if (status == null || status == "" || status == "null" || status == JapaneseText.free) {
      return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          JapaneseText.free,
          style: subTitle,
        ),
      );
    } else if (status == JapaneseText.duringCorrespondence) {
      return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          JapaneseText.duringCorrespondence,
          style: subTitle.copyWith(color: Colors.white),
        ),
      );
    } else if (status == JapaneseText.noContact) {
      return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.redColor,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          JapaneseText.noContact,
          style: subTitle.copyWith(color: Colors.white),
        ),
      );
    } else if (status == JapaneseText.contact) {
      return Container(
        width: 120,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.success,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          JapaneseText.contact,
          style: subTitle.copyWith(color: Colors.white),
        ),
      );
    } else if (status == JapaneseText.passedInterview) {
      return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.darkBlueColor,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          JapaneseText.passedInterview,
          style: subTitle.copyWith(color: Colors.white),
        ),
      );
    } else {
      return Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          JapaneseText.free,
          style: subTitle,
        ),
      );
    }
  }

  static displayStatusForJobPosting(String? status) {
    if (status == null || status == "" || status == "null" || status == JapaneseText.duringCorrespondence) {
      return Center(
        child: Container(
          width: 80,
          height: 35,
          decoration: BoxDecoration(
            color: AppColor.duringCorrespondingColor,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            JapaneseText.duringCorrespondence,
            style: subTitle.copyWith(color: Colors.white, fontSize: 13),
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          width: 70,
          height: 35,
          decoration: BoxDecoration(
            color: AppColor.endColor,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            JapaneseText.end,
            style: subTitle.copyWith(color: Colors.white, fontSize: 13),
          ),
        ),
      );
    }
  }
}
