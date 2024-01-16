import 'package:air_job_management/helper/date_to_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/worker_model/shift.dart';

String errorMessage = "";

class SearchJobApi {
  var jobcollection = FirebaseFirestore.instance.collection('job');

  Future<bool> createJobRequest(String jobId, String userId, String username, List<ShiftModel> shiftList) async {
    try {
      var doc = await jobcollection.where("job_id", isEqualTo: jobId).where("user_id", isEqualTo: userId).get();
      if (doc.size == 0) {
        await jobcollection.add({
          "job_id": jobId,
          "user_id": userId,
          "created_at": DateTime.now(),
          "username": username,
          "status": "pending",
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
        errorMessage = "You already apply this job! Please waiting company for accept to interview.";
        return false;
      }
    } catch (e) {
      debugPrint("Error createJobRequest $e");
      errorMessage = e.toString();
      return false;
    }
  }
}
