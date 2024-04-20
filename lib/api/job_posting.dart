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
  final CollectionReference notificationRef = FirebaseFirestore.instance.collection('notification');

  Future<List<NotificationModel>> getAllNotification(String companyId) async {
    try {
      var doc = await notificationRef.get();
      if (doc.docs.isNotEmpty) {
        List<NotificationModel> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          NotificationModel jobPosting = NotificationModel.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          jobPosting.uid = doc.docs[i].id;
          list.add(jobPosting);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllNotification =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<JobPosting>> getAllJobPostByCompany(String companyId) async {
    try {
      var doc = await jobPostingRef.where("company_id", isEqualTo: companyId).get();
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
