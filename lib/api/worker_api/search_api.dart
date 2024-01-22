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

  Future<bool> createJobRequestForOutsideUser(String? docId, SearchJob job, MyUser myUser, List<ShiftModel> shiftList, List<String> urlFile) async {
    try {
      if (docId == null) {
        var doc = await jobcollection
            .where("job_id", isEqualTo: job.uid)
            .where("username", isEqualTo: "${myUser.nameKanJi} ${myUser.nameFu}")
            .where("status", isEqualTo: "pending")
            .get();
        if (doc.size == 0) {
          await jobcollection.add({
            "job_id": "",
            "company_id": job.companyId,
            "job_title": "${myUser.affiliation}/${myUser.qualificationFields}",
            "job_location": job.jobLocation,
            "user_id": myUser.uid,
            "created_at": DateTime.now(),
            "username": "${myUser.nameKanJi} ${myUser.nameFu}",
            "status": "pending",
            "user": myUser.toJson(),
            "user_identification_url": urlFile.map((e) => e).toList(),
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
          errorMessage = "このユーザーはすでに存在します。";
          return false;
        }
      } else {
        await jobcollection.doc(docId).update({
          "job_id": "",
          "company_id": job.companyId,
          "job_title": "${myUser.affiliation}/${myUser.qualificationFields}",
          "job_location": job.jobLocation,
          "user_id": myUser.uid,
          "created_at": DateTime.now(),
          "username": "${myUser.nameKanJi} ${myUser.nameFu}",
          "status": "pending",
          "user": myUser.toJson(),
          "user_identification_url": urlFile.map((e) => e).toList(),
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
      }
    } catch (e) {
      debugPrint("Error createJobRequestForOutsideUser $e");
      errorMessage = e.toString();
      return false;
    }
  }
}
