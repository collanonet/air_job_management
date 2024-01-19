import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';
import '../../models/worker_model/shift.dart';

String errorMessage = "";

class SearchJobApi {
  var jobcollection = FirebaseFirestore.instance.collection('job');

  Future<bool> createJobRequest(SearchJob job, MyUser myUser, List<ShiftModel> shiftList) async {
    try {
      var doc =
          await jobcollection.where("job_id", isEqualTo: job.uid).where("user_id", isEqualTo: myUser.uid).where("status", isEqualTo: "pending").get();
      if (doc.size == 0) {
        await jobcollection.add({
          "job_id": job.uid,
          "company_id": job.companyId,
          "job_title": job.title,
          "job_location": job.jobLocation,
          "user_id": myUser.uid,
          "created_at": DateTime.now(),
          "username": "${myUser.nameKanJi} ${myUser.nameFu}",
          "status": "pending",
          "user": myUser.toJson(),
          "shift": shiftList
              .map((e) => {
                    "start_work_time": e.startWorkTime,
                    "end_work_time": e.endWorkTime,
                    "start_break_time": e.endBreakTime,
                    "end_break_time": e.endBreakTime,
                    "date": DateToAPIHelper.convertDateToString(e.date!),
                    "price": e.price.toString()
                  })
              .toList()
        });
        return true;
      } else {
        errorMessage = "あなたはすでにこの求人に応募しています! 企業が面接を受けるまでお待ちください。";
        return false;
      }
    } catch (e) {
      debugPrint("Error createJobRequest $e");
      errorMessage = e.toString();
      return false;
    }
  }
}
