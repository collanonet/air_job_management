import 'package:air_job_management/models/company/worker_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../helper/date_to_api.dart';

class WorkerManagementApiService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference jobRef = FirebaseFirestore.instance.collection('job');

  Future<List<WorkerManagement>> getAllJobApplyForAUSer(String companyId, String userId) async {
    try {
      var doc = await jobRef.where("company_id", isEqualTo: companyId).where("user_id", isEqualTo: userId).get();
      if (doc.docs.isNotEmpty) {
        List<WorkerManagement> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          WorkerManagement company = WorkerManagement.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          company.uid = doc.docs[i].id;
          list.add(company);
        }
        for (var job in list) {
          job.shiftList!.sort((a, b) => a.date!.compareTo(b.date!));
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print("Error getAllJobApply =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<WorkerManagement>> getAllJobApply(String companyId) async {
    try {
      var doc = await jobRef.where("company_id", isEqualTo: companyId).orderBy("created_at", descending: true).get();
      if (doc.docs.isNotEmpty) {
        List<WorkerManagement> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          WorkerManagement company = WorkerManagement.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          company.uid = doc.docs[i].id;
          list.add(company);
        }
        Map<String, int> userOrderCount = {};
        for (var job in list) {
          job.shiftList!.sort((a, b) => a.date!.compareTo(b.date!));
          if (job.userId != null) {
            if (userOrderCount.containsKey(job.userId)) {
              // Increment count for existing user
              userOrderCount[job.userId!] = userOrderCount[job.userId]! + 1;
              // Update order count in the Order instance
            } else {
              // Initialize count for new user
              userOrderCount[job.userId!] = 1;
            }
          }
        }
        for (var job in list) {
          if (userOrderCount.containsKey(job.userId)) {
            job.applyCount = userOrderCount[job.userId];
          } else {
            job.applyCount = 1;
          }
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print("Error getAllJobApply =>> ${e.toString()}");
      return [];
    }
  }

  Future<WorkerManagement?> getAJob(String uid) async {
    try {
      DocumentSnapshot doc = await jobRef.doc(uid).get();
      if (doc.exists) {
        WorkerManagement company = WorkerManagement.fromJson(doc.data() as Map<String, dynamic>);
        company.uid = doc.id;
        return company;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getAJob =>> ${e.toString()}");
      return null;
    }
  }

  Future<bool> updateJobStatus(String jobId, String status) async {
    try {
      await jobRef.doc(jobId).update({"status": status});
      return true;
    } catch (e) {
      debugPrint("Error updateJobStatus =>> ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateJobId(WorkerManagement job) async {
    try {
      await jobRef.doc(job.uid).update({
        "job_id": job.jobId,
        "job_title": job.jobTitle,
        "job_location": job.jobLocation,
        "shift": job.shiftList!
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
      debugPrint("Error updateJobId =>> ${e.toString()}");
      return false;
    }
  }

  Future<List<WorkerManagement>> getAllApplicantByJobId(String jobId) async {
    try {
      var doc = await jobRef.where("job_id", isEqualTo: jobId).get();
      if (doc.docs.isNotEmpty) {
        List<WorkerManagement> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          WorkerManagement company = WorkerManagement.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          company.uid = doc.docs[i].id;
          list.add(company);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getAllApplicantByJobId =>> ${e.toString()}");
      return [];
    }
  }
}
