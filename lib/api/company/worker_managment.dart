import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../helper/date_to_api.dart';
import '../../models/worker_model/shift.dart';
import '../../services/send_email.dart';

class WorkerManagementApiService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference jobRef = FirebaseFirestore.instance.collection('job');

  Future<bool> updateAllSearchJob() async {
    List<String> idList = [
      "0FJSfIqGrcKqnZbKxAw6",
      "0SZJJBdO6CNgnPSOUuu0",
      "1l0S2oqx9Q3RPqGpXpH8",
      "1ziqNLVvFrOLmtMQ8Rwh",
      "23kgD5Ex9ouRw0xrjrRC",
      "2rHY4xVPnsDqt4z4OeKM",
      "34i8VLK3kHa6pbMzbV5Y",
      "3NLbwWnhoObucwGD08fM",
      "462OhCf8kN0KYBqGCaFJ",
      "4RjhbfVgW5CkruQ845kn",
      "4SFmf2d0PoAt4GzbNgyD",
      "7MD9WSZ5wpuVayjsiLXY",
      "7MiX3eTS8fGcg6BJMO3n",
      "7V3KZ7k3UKa8PZAQA5Tc",
      "7b32JkLrjWMnBTaqSF6k",
      "8M8UL5iFobMjEOhnTdXI",
      "8YzcHjgN8c3axUXWndPw",
      "966R8Ixq7i0lByxGUYS0",
      "ABzPT11GU7kaQ40cqrdk",
      "BEJpTJKVtXtNfaK5Eh1p",
      "BQQjEjvN0FHdUzmZ2q6V",
      "ChsrPdeS4PpyJ7qK2x5Y",
      "DQQiYUsH4sD53yigSfnD",
      "EgGDTon7BsTKQF69BPqM",
      "F74UfOvKV9kxyVx0Fk6I",
      "GGwOoCw74yQHT9au87DM",
      "H3JKbAtXyboXv5NFZH2a",
      "HrXbjag4CAVBv1586mw2",
      "IYDXCxafuwMRLuy06BI9",
      "JyERnw9V1bQVJXlrUOL7",
      "K8ttw5XAjYBtRExqtZvQ",
      "NwDhnR1cVLzPEtAU3i4M",
      "OhXl0bzTm9lRFwIgHTnM",
      "Oj4KzuZ4f9RDB3p6KHY5",
      "PC0KtRLjG5PLb77Ky2PV",
      "PSgYXm75qzuas2EqmO9h",
      "PpXnF4Bz72i9UEgDAl5d",
      "QcYbQsSQ7siGsX9eFIEl",
      "QtcqF7Z3BGhWvWcMjJ53",
      "SHc3cYWdwjcCWh4z3E0W",
      "SNy0MtoqVT9VvuG2aLG5",
      "SYtd5ii0xs8QD5m3pUOJ",
      "UCggyrYz3LtskEsDUJQ6",
      "UYKDlACCBQDnJCiCyh3o",
      "UZf3ejN0dNO5SrObLZxA",
      "V2XX8ZwbTZI7sMX77xWM",
      "WXAqNKEgVAANdk2SAbxk",
      "WYeLJuNRkuW9mOIDd0RZ",
      "Wzkhqdo1SPd0RRhdQVrM",
      "XcaYhYugg3qDoAQkO7MD",
      "YgDW7XxBMyDkOV3vq1oH",
      "Yr8esqvV0illWH5rhOOX",
      "ZJltbrjdXQhYkbYDUqyC",
      "ZgAnf0wEBJYCsw6QJs8p",
      "a5R6ZpRI1nUWAcsaUpop",
      "aZBo0jpwkBMLjQKhcnox",
      "chLn2jkCQayCcF7ZV41F",
      "cvR0LCd0EHs3FqcjX02T",
      "cySAapzGoyAB89XYoevY",
      "eGyaYHjahOTC4FmlR32U",
      "fBdhKzfjVpcvHGsLymuq",
      "fwYpsjMoI5hZCW2d5FX3",
      "gYgEUIdNg3s3EE4AFztE",
      "hGfbBeDlEbq9bC6klJ3x",
      "is1gze46q0r209m5eeeJ",
      "mIPMrpokFcpBmRNclj3P",
      "naAREe2GD8v9vbhMkza1",
      "reX7Ripg1tcB0FadAvKJ",
      "s0X0ZAZIah63ODFW4xHF",
      "s1gIw6yRkwCtLrjjVvq7",
      "tsGUyV27oAUh0i2hMBS1",
      "uD9wQaRiCBu49U77lwem",
      "vIJ78jKDZdtkNU1NEyEj",
      "vzmjK4a5vAHAgAQU1MA0",
      "vzmq9GMjPsbrUbJScUHk",
      "w98xGUpP3Q62O7yTyptn",
      "wMMi6nT9MolIfz6P9v8m",
      "wamgNdfrnMYRolOLV6YZ",
      "yEODGJTxwCnmqTtMmI6s",
      "zm8FBlVRKbOGd27tDmVH",
      "zvHx8DdjFEdkE9Gf5cB0",
    ];
    await Future.wait(idList.map((e) => jobRef.doc(e).update({"branch_id": "1714112463487"})));
    return true;
  }

  Future<List<WorkerManagement>> getAllJobApplyWithoutBranch(String companyId) async {
    try {
      var doc = await jobRef.where("company_id", isEqualTo: companyId).get();
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

  Future<List<WorkerManagement>> getAllJobApplyByJobPostingId(String jobPostingId) async {
    try {
      var doc = await jobRef.where("job_id", isEqualTo: jobPostingId).get();
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

  Future<List<WorkerManagement>> getAllJobApplyForAUSerWithoutBranch(String companyId, String userId) async {
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

  Future<List<WorkerManagement>> getAllJobApplyForAUSer(String companyId, String userId, String branchId) async {
    try {
      var doc;
      if(branchId == ""){
        doc = await jobRef
            .where("company_id", isEqualTo: companyId)
            .where("user_id", isEqualTo: userId)
            .get();
      }else{
        doc =
        await jobRef.where("company_id", isEqualTo: companyId).where("user_id", isEqualTo: userId).where("branch_id", isEqualTo: branchId).get();
      }
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

  Future<List<WorkerManagement>> getAllJobApply(String companyId, String branchId) async {
    try {
      var doc;
      if (branchId == "") {
        doc = await jobRef.where("company_id", isEqualTo: companyId).orderBy("created_at", descending: true).get();
      } else {
        doc = await jobRef
            .where("company_id", isEqualTo: companyId)
            .where("branch_id", isEqualTo: branchId)
            .orderBy("created_at", descending: true)
            .get();
      }
      if (doc.docs.isNotEmpty) {
        List<WorkerManagement> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          WorkerManagement company = WorkerManagement.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          company.uid = doc.docs[i].id;
          list.add(company);
        }
        Map<String, int> userOrderCount = {};
        var data = await Future.wait([for (var job in list) UserApiServices().getProfileUser(job.userId.toString())]);
        for (var job in list) {
          for (var u in data) {
            if (u != null && u.uid == job.userId) {
              job.myUser = u;
              break;
            }
          }
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
    print("Job id $uid");
    try {
      DocumentSnapshot doc = await jobRef.doc(uid).get();
      if (doc.exists) {
        WorkerManagement workerManagement = WorkerManagement.fromJson(doc.data() as Map<String, dynamic>);
        workerManagement.uid = doc.id;
        return workerManagement;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getAJob =>> ${e.toString()}");
      return null;
    }
  }

  Future<bool> updateShiftStatus(List<ShiftModel> shiftList, String jobId,
      {Branch? branch, Company? company, ShiftModel? shiftModel, MyUser? myUser, bool? isFromWorkerManagement}) async {
    try {
      if (isFromWorkerManagement == true) {
        shiftList = shiftList.toSet().toList();
      }
      await jobRef.doc(jobId).update({"shift": shiftList.map((e) => e.toJson())});
      if (company != null && myUser != null) {
        String managerName = "";
        if (company.manager!.isNotEmpty) {
          managerName = company.manager!.first.kanji ?? "";
        }
        await NotificationService.sendEmailApplyShift(
            token: myUser.fcmToken ?? "",
            startTime: shiftList.first.startWorkTime ?? "",
            endTime: shiftList.first.endWorkTime ?? "",
            branchName: branch?.name ?? "",
            managerName: managerName,
            email: myUser.email ?? "",
            msg: "Your Shift Apply",
            name: myUser.nameKanJi ?? "",
            userId: myUser.uid ?? "",
            companyId: company.uid ?? "",
            companyName: company.companyName ?? "",
            branchId: branch?.id ?? "",
            status: shiftModel!.status!,
            date: DateToAPIHelper.convertDateToString(shiftModel.date!));
      }
      return true;
    } catch (e) {
      debugPrint("Error updateJobStatus =>> ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateShiftStatusForMultipleShift(List<ShiftModel> shiftList, String jobId,
      {Branch? branch, Company? company, List<DateTime>? dateList, String? status, MyUser? myUser, bool? isFromWorkerManagement}) async {
    try {
      if (isFromWorkerManagement == true) {
        shiftList = shiftList.toSet().toList();
      }
      await jobRef.doc(jobId).update({"shift": shiftList.map((e) => e.toJson())});
      if (company != null && myUser != null) {
        String managerName = "";
        if (company.manager!.isNotEmpty) {
          managerName = company.manager!.first.kanji ?? "";
        }
        for (var date in dateList!) {
          await NotificationService.sendEmailApplyShift(
              token: myUser.fcmToken ?? "",
              startTime: shiftList.first.startWorkTime ?? "",
              endTime: shiftList.first.endWorkTime ?? "",
              branchName: branch?.name ?? "",
              managerName: managerName,
              email: myUser.email ?? "",
              msg: "Your Shift Apply",
              name: myUser.nameKanJi ?? "",
              userId: myUser.uid ?? "",
              companyId: company.uid ?? "",
              companyName: company.companyName ?? "",
              branchId: branch?.id ?? "",
              status: status!,
              date: DateToAPIHelper.convertDateToString(date));
        }
      }
      return true;
    } catch (e) {
      debugPrint("Error updateJobStatus =>> ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateShiftStatusForDelete(List<ShiftModel> shiftList, String jobId,
      {Branch? branch, Company? company, String? status, MyUser? myUser}) async {
    try {
      shiftList = shiftList.toSet().toList();
      await jobRef.doc(jobId).update({"shift": shiftList.isEmpty ? [] : shiftList.map((e) => e.toJson())});
      if (company != null && myUser != null) {
        String managerName = "";
        if (company.manager != []) {
          managerName = company.manager!.first.kanji ?? "";
        }
        await NotificationService.sendEmailApplyShift(
            token: myUser.fcmToken ?? "",
            startTime: shiftList.isEmpty ? "00" : shiftList.first.startWorkTime ?? "",
            endTime: shiftList.isEmpty ? "00" : shiftList.first.endWorkTime ?? "",
            branchName: branch?.name ?? "",
            managerName: managerName,
            email: myUser.email ?? "",
            msg: "Your Shift Apply",
            name: myUser.nameKanJi ?? "",
            userId: myUser.uid ?? "",
            companyId: company.uid ?? "",
            companyName: company.companyName ?? "",
            branchId: branch?.id ?? "",
            status: status!,
            date: DateToAPIHelper.convertDateToString(DateTime.now()));
      }
      return true;
    } catch (e) {
      debugPrint("Error updateJobStatus =>> ${e.toString()}");
      return false;
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

  Future<bool> deleteJobApply(String id) async {
    try {
      await jobRef.doc(id).delete();
      return true;
    } catch (e) {
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
        Map<String, int> userOrderCount = {};
        var data = await Future.wait([for (var job in list) UserApiServices().getProfileUser(job.userId.toString())]);
        for (var job in list) {
          for (var u in data) {
            if (u != null && u.uid == job.userId) {
              job.myUser = u;
              break;
            }
          }
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
      debugPrint("Error getAllApplicantByJobId =>> ${e.toString()}");
      return [];
    }
  }
}
