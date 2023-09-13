import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class StatusUtils {
  displayStatus(String? status) {
    if (status == null || status == "") {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Free",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    } else if (status == "applying") {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Applying",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    } else if (status == "Interview") {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Interview",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    } else if (status == "working") {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.deepOrange, borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Working",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    } else if (status == "completed") {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Completed",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    } else {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)),
        child: Center(
            child: Text(
          "Free",
          style: normalTextStyle.copyWith(color: Colors.white),
        )),
      );
    }
  }
}
