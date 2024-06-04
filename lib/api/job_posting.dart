import 'package:air_job_management/models/job_posting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../const/const.dart';
import '../models/notification.dart';
import '../models/worker_model/search_job.dart';

class JobPostingApiService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference jobPostingRef = FirebaseFirestore.instance.collection('search_job');
  final CollectionReference notificationRef = FirebaseFirestore.instance.collection('mail');

  Future<bool> updateAllJobPosting() async {
    List<String> idList = [
      "2vvw0DVxrTwgFlHlrcBA",
      "56JV5kYAya41IwObyTBx",
      "58ly9QJH6iCRXjBNnbYv",
      "5dRZ7RsqKlFIDgVkmMTN",
      "7cyTqlOX2xGq8k7p5nDv",
      "9j9JQDKPIYXlQfJe87qd",
      "DxS92898ljbEYQbNAIRX",
      "MUgAiMB7IKAEIKE6mYsg",
      "QLdQt8mgGfX6cpJb9FeC",
      "TCsdZxtdo97FQocxmwoZ",
      "crXD1FOy1h0xtr66s00y",
      "isJ0OeU7dBmCPlWXUM80",
      "pc0yka60FF9UV3Br4RPL",
      "qtlty2iTz2ATqwVWfDm4",
      "yboXYWJaiEXzUkBsohxj",
      "yyknsz0kHr083k1xUAlO",
    ];
    await Future.wait(idList.map((e) => jobPostingRef.doc(e).update({"is_delete": false})));
    return true;
  }

  Future<bool> restorePosting(List<String> restoreId) async {
    try {
      await Future.wait(restoreId.map((e) => jobPostingRef.doc(e).update({"is_delete": false})));
      return true;
    } catch (e) {
      debugPrint("Error restorePosting =>> ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteJobPosting(String uid) async {
    try {
      await jobPostingRef.doc(uid).update({"is_delete": true});
      return true;
    } catch (e) {
      debugPrint("Error deleteJobPosting =>> ${e.toString()}");
      return false;
    }
  }

  Future<List<NotificationModel>> getAllNotification(String companyId) async {
    try {
      var doc = await notificationRef.where("company_id", isEqualTo: companyId).get();
      if (doc.docs.isNotEmpty) {
        List<NotificationModel> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          NotificationModel jobPosting = NotificationModel.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          jobPosting.uid = doc.docs[i].id;
          list.add(jobPosting);
        }
        list.sort((a, b) => b.date!.compareTo(a.date!));
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllNotification =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<JobPosting>> getAllJobPostByCompany(String companyId, String branchId) async {
    try {
      print("Get all job post $companyId, $branchId");
      var doc = await jobPostingRef
          .where("company_id", isEqualTo: companyId)
          .where("branch_id", isEqualTo: branchId)
          .where("is_delete", isEqualTo: false)
          .get();
      if (doc.docs.isNotEmpty) {
        List<JobPosting> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          JobPosting jobPosting = JobPosting.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          jobPosting.uid = doc.docs[i].id;
          list.add(jobPosting);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllJobPost =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<JobPosting>> getAllDeletedJobPostByCompany(String companyId, String branchId) async {
    try {
      var doc = await jobPostingRef
          .where("company_id", isEqualTo: companyId)
          .where("branch_id", isEqualTo: branchId)
          .where("is_delete", isEqualTo: true)
          .get();
      if (doc.docs.isNotEmpty) {
        List<JobPosting> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          JobPosting jobPosting = JobPosting.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          jobPosting.uid = doc.docs[i].id;
          list.add(jobPosting);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllJobPost =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<JobPosting>> getAllJobPost() async {
    try {
      var doc = await jobPostingRef.get();
      if (doc.docs.isNotEmpty) {
        List<JobPosting> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          JobPosting jobPosting = JobPosting.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          jobPosting.uid = doc.docs[i].id;
          list.add(jobPosting);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllJobPost =>> ${e.toString()}");
      return [];
    }
  }

  Future<JobPosting?> getAJobPosting(String uid) async {
    print("Get a job posting $uid");
    try {
      DocumentSnapshot doc = await jobPostingRef.doc(uid).get();
      if (doc.exists) {
        JobPosting jobPosting = JobPosting.fromJson(doc.data() as Map<String, dynamic>);
        jobPosting.uid = uid;
        return jobPosting;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getAJobPosting =>> ${e.toString()}");
      return null;
    }
  }

  Future<SearchJob?> getASearchJob(String uid) async {
    try {
      DocumentSnapshot doc = await jobPostingRef.doc(uid).get();
      if (doc.exists) {
        SearchJob jobPosting = SearchJob.fromJson(doc.data() as Map<String, dynamic>);
        jobPosting.uid = uid;
        return jobPosting;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getASearchJob =>> ${e.toString()}");
      return null;
    }
  }

  Future<String?> createJob(JobPosting? jobPosting) async {
    try {
      await jobPostingRef.add(jobPosting!.toJson());
      return ConstValue.success;
    } catch (e) {
      debugPrint("Error createJob =>> ${e.toString()}");
      return "$e";
    }
  }

  Future<String?> updateJobPostingInfo(JobPosting? jobPosting) async {
    print("UID is ${jobPosting?.uid}");
    try {
      await jobPostingRef.doc(jobPosting!.uid).update(jobPosting.toJson());
      return ConstValue.success;
    } catch (e) {
      debugPrint("Error updateJobPostingInfo =>> ${e.toString()}");
      return "$e";
    }
  }

  Future<String?> updateShift(
      {required String jobPostingId,
      required String startDate,
      required String endDate,
      required String endPostDate,
      required String startPostDate,
      required String startWorkTime,
      required String endWorkTime,
      required String startBreakTime,
      required String endBreakTime,
      required String recruit,
      required String dateline,
      required String privacy,
      required String hourlyWage,
      required String transportExp,
      required String telephone,
      required String selectSmokingInDoor,
      required bool isAllowSmokingInArea,
      required List<String> selectedDate}) async {
    print("updateShift $jobPostingId");
    try {
      await jobPostingRef.doc(jobPostingId).update({
        "selectedDate": selectedDate.map((e) => e).toList(),
        "applicationDateline": dateline,
        "selectedPublicSetting": privacy,
        "transportExpenseFee": transportExp,
        "emergencyContact": telephone,
        "hourlyWag": hourlyWage,
        "start_break_time_hour": startBreakTime,
        "end_break_time_hour": endBreakTime,
        "start_date": startDate,
        "end_date": endDate,
        "postedStartDate": startPostDate,
        "postedEndDate": endPostDate,
        "smoking_allow": isAllowSmokingInArea,
        "smoking_options": selectSmokingInDoor,
        "start_time_hour": startWorkTime,
        "end_time_hour": endWorkTime,
        "number_of_recruit": recruit,
      });
      return ConstValue.success;
    } catch (e) {
      debugPrint("Error updateShift =>> ${e.toString()}");
      return "$e";
    }
  }
}
