import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';
import '../../models/worker_model/shift.dart';
import '../../utils/common_utils.dart';

String errorMessage = "";

class SearchJobApi {
  var jobcollection = FirebaseFirestore.instance.collection('job');
  var search = FirebaseFirestore.instance.collection('search_job');

  Future<SearchJob?> getASearchJob(String id) async {
    try {
      var doc = await search.doc(id).get();
      if (doc.exists) {
        return SearchJob.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getASearchJob $e");
      return null;
    }
  }

  Future<bool> createJobRequest(SearchJob job, MyUser myUser, List<ShiftModel> shiftList) async {
    try {
      var doc = await jobcollection.where("user_id", isEqualTo: myUser.uid).where("status", isEqualTo: "pending").get();
      List<String> dateList = shiftList.map((e) => DateToAPIHelper.convertDateToString(e.date!)).toList();
      if (doc.size > 0) {
        for (var data in doc.docs) {
          var d = data.data()["shift"] as List;
          List<String> dateFromDB = d.map((e) => e["date"] as String).toList();
          bool isContain = CommonUtils().containsAny(dateList, dateFromDB);
          if (isContain) {
            errorMessage = "他のジョブリクエストとスケジュールが重複している。";
            return false;
          }
        }
      }
      await jobcollection.add({
        "job_id": job.uid,
        "company_id": job.companyId,
        "job_title": job.title,
        "job_location": job.jobLocation,
        "image_job_url": job.image,
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
    } catch (e) {
      debugPrint("Error createJobRequest $e");
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> createJobRequestForOutsideUser(
      String? branchId, String? docId, SearchJob job, MyUser myUser, List<ShiftModel> shiftList, List<String> urlFile) async {
    try {
      if (docId == null) {
        var doc = await jobcollection
            .where("job_id", isEqualTo: job.uid)
            .where("username", isEqualTo: "${myUser.nameKanJi} ${myUser.nameFu}")
            .where("status", isEqualTo: "pending")
            .where("branch_id", isEqualTo: branchId)
            .get();
        if (doc.size == 0) {
          await jobcollection.add({
            "branch_id": branchId,
            "job_id": "",
            "company_id": job.companyId,
            "job_title": "${myUser.affiliation}/${myUser.qualificationFields}",
            "job_location": job.jobLocation,
            "user_id": myUser.uid,
            "created_at": DateTime.now(),
            "username": "${myUser.nameKanJi} ${myUser.nameFu}",
            "status": "approved",
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
          "branch_id": branchId,
          "job_id": "",
          "company_id": job.companyId,
          "job_title": "${myUser.affiliation}/${myUser.qualificationFields}",
          "job_location": job.jobLocation,
          "user_id": myUser.uid,
          "created_at": DateTime.now(),
          "username": "${myUser.nameKanJi} ${myUser.nameFu}",
          "status": "approved",
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
