import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/dateTime_Cal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/date_to_api.dart';
import '../models/entry_exit_history.dart';
import '../utils/log.dart';

class EntryExitApiService {
  var entryRef = FirebaseFirestore.instance.collection("entry_exit_history");
  var userRef = FirebaseFirestore.instance.collection("user");
  var entryRefLog = FirebaseFirestore.instance.collection("entry_exit_history_log");

  Future<bool> updateEntryExitData(EntryExitHistory entryExitHistory, String workingTime, String status, MyUser? myUser) async {
    try {
      await entryRefLog.add({
        "created_at": DateTime.now(),
        "status": status,
        "entry_id": entryExitHistory.uid,
        "totalWage": entryExitHistory.totalWage,
        "overtime": entryExitHistory.overtime,
        "midnight_overtime": entryExitHistory.midnightOvertime,
        "breakTimeHour": entryExitHistory.breakingTimeHour,
        "breakTimeMinute": entryExitHistory.breakingTimeMinute,
        "WorkingTimeHour": entryExitHistory.workingHour,
        "WorkingTimeMinute": entryExitHistory.workingMinute,
        "workDate": entryExitHistory.workDate,
        "endWorkDate": entryExitHistory.endWorkDate,
        "correct_to": entryExitHistory.entryExitHistoryCorrection!.toJson()
      });
      await entryRef.doc(entryExitHistory.uid).update({
        "updated_at": DateTime.now(),
        "correctionStatus": status,
        "overtime": entryExitHistory.entryExitHistoryCorrection!.overtime,
        "midnightOvertime": entryExitHistory.entryExitHistoryCorrection!.midnightOverTime,
        "totalWage": entryExitHistory.entryExitHistoryCorrection!.totalWage,
        "startWorkingTime": entryExitHistory.entryExitHistoryCorrection!.startWorkingTime,
        "endWorkingTime": entryExitHistory.entryExitHistoryCorrection!.endWorkingTime,
        "workingHour": int.parse(workingTime.split(":")[0]),
        "workingMinute": int.parse(workingTime.split(":")[1]),
        "break_time_hour": int.parse(entryExitHistory.entryExitHistoryCorrection!.breakTime!.split(":")[0]),
        "break_time_minute": int.parse(entryExitHistory.entryExitHistoryCorrection!.breakTime!.split(":")[1]),
      });
      UserApiServices().updateUserWage(
          myUser: myUser!, totalWage: entryExitHistory.entryExitHistoryCorrection!.totalWage!, oldWage: entryExitHistory.totalWage ?? 0);
      UserApiServices().updateUserAField(uid: myUser.uid ?? "", value: myUser.balance ?? "0", field: "old_balance");
      return true;
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return false;
    }
  }

  Future<List<EntryExitHistory>> getAllEntryList(String id) async {
    try {
      var doc = await entryRef.where("companyId", isEqualTo: id).get();
      List<EntryExitHistory> entryList = [];
      if (doc.size > 0) {
        for (var data in doc.docs) {
          EntryExitHistory entryExitHistory = EntryExitHistory.fromJson(data.data());
          entryExitHistory.uid = data.id;
          entryList.add(entryExitHistory);
        }
        entryList.sort((a, b) => b.workDateToDateTime!.compareTo(a.workDateToDateTime!));
        return entryList;
      } else {
        return [];
      }
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<EntryExitHistory>> getAllEntryListByBranch(String id) async {
    try {
      var doc = await entryRef.where("branch_id", isEqualTo: id).get();
      print("getAllEntryListByBranch $id ${doc.size}");
      List<EntryExitHistory> entryList = [];
      if (doc.size > 0) {
        for (var data in doc.docs) {
          EntryExitHistory entryExitHistory = EntryExitHistory.fromJson(data.data());
          entryExitHistory.uid = data.id;
          entryList.add(entryExitHistory);
        }
        entryList.sort((a, b) => b.workDateToDateTime!.compareTo(a.workDateToDateTime!));
        return entryList;
      } else {
        return [];
      }
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return [];
    }
  }

  Future<EntryExitHistory?> getEntryExitById(String id) async {
    try {
      var doc = await entryRef.doc(id).get();
      var data = doc.data();
      EntryExitHistory entryExitHistory = EntryExitHistory.fromJson(data as Map<String, dynamic>);
      return entryExitHistory;
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return null;
    }
  }

  Future<List<EntryExitHistory>> getAllEntryListByUser(String id) async {
    try {
      var doc = await entryRef.where("userId", isEqualTo: id).get();
      List<EntryExitHistory> entryList = [];
      if (doc.size > 0) {
        for (var data in doc.docs) {
          EntryExitHistory entryExitHistory = EntryExitHistory.fromJson(data.data());
          entryExitHistory.uid = data.id;
          entryList.add(entryExitHistory);
        }
        entryList.sort((a, b) => b.workDateToDateTime!.compareTo(a.workDateToDateTime!));
        return entryList;
      } else {
        return [];
      }
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return [];
    }
  }

  insertDataForTesting(List<EntryExitHistory> list) async {
    try {
      for (var entry in list) {
        ///Calculate Working Time
        entry.scheduleStartBreakTime = "12:00";
        entry.scheduleEndBreakTime = "13:00";
        entry.scheduleStartWorkingTime = "09:00";
        entry.scheduleEndWorkingTime = "17:00";
        entry.startWorkingTime = "09:00";
        entry.endWorkingTime = "19:00";
        var data = calculateWorkingTime(entry.startWorkingTime, entry.endWorkingTime, "01:00");
        entry.workingHour = data[0];
        entry.workingMinute = data[1];

        var actualWorkData = calculateWorkingTime(entry.scheduleStartWorkingTime, entry.scheduleEndWorkingTime, "01:00");
        entry.actualWorkingHour = actualWorkData[0];
        entry.actualWorkingMinute = actualWorkData[1];

        var breakTimeData = calculateBreakTime(entry.scheduleEndBreakTime, entry.scheduleStartBreakTime);
        entry.breakingTimeHour = breakTimeData[0];
        entry.breakingTimeMinute = breakTimeData[1];

        ///Calculate late data
        bool isLate = false;
        List<int> lateData = calculateLateTime(entry.scheduleStartWorkingTime, entry.startWorkingTime);
        int lateHour = lateData[0];
        int lateMinute = lateData[1];
        if (lateHour > 0 || lateMinute > 0) {
          isLate = true;
        }
        entry.latHour = lateHour;
        entry.lateMinute = lateMinute;
        entry.isLate = isLate;

        ///Calculate leave early data
        bool isLeaveEarly = false;
        int leaveEarlyHour = 0;
        int leaveEarlyMinute = 0;
        List<int> leaveData = calculateBreakTime(entry.endWorkingTime, entry.scheduleEndWorkingTime);
        leaveEarlyHour = leaveData[0];
        leaveEarlyMinute = leaveData[1];
        if (leaveEarlyMinute > 0 || leaveEarlyHour > 0) {
          isLeaveEarly = true;
        }
        entry.isLeaveEarly = isLeaveEarly;
        entry.leaveEarlyMinute = leaveEarlyMinute;
        entry.leaveEarlyHour = leaveEarlyHour;

        ///Calculate Overtime
        List<int> overTimeData = calculateOvertime(entry.scheduleEndWorkingTime, entry.endWorkingTime, "00:00");
        entry.overtime =
            "${DateToAPIHelper.formatTimeTwoDigits(overTimeData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(overTimeData[1].toString())}";

        ///within statutory
        var scheduleWorkingData = calculateWorkingTime(entry.scheduleStartWorkingTime, entry.scheduleEndWorkingTime, "01:00");
        List<int> withinStatutoryData =
            calculateWorkingTime("${scheduleWorkingData[0]}:${scheduleWorkingData[1]}", "$overTimeLegalLimit:00", "00:00");
        entry.overtimeWithinLegalLimit =
            "${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[1].toString())}";

        ///non statutory
        List<int> nonStatutoryData = calculateBreakTime(entry.overtime, entry.overtimeWithinLegalLimit);
        entry.nonStatutoryOvertime =
            "${DateToAPIHelper.formatTimeTwoDigits(nonStatutoryData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(nonStatutoryData[1].toString())}";

        await entryRef.doc(entry.uid).update(entry.toJson());
      }
      return true;
    } catch (e) {
      Logger.printLog("Error insertDataForTesting =>> ${e.toString()}");
      return false;
    }
  }

  insertEntryDataForPaidLeave(EntryExitHistory entry) async {
    try {
      ///Calculate Working Time
      entry.isPaidLeave = true;
      entry.scheduleStartBreakTime = "12:00";
      entry.scheduleEndBreakTime = "13:00";
      entry.scheduleStartWorkingTime = "09:00";
      entry.scheduleEndWorkingTime = "17:00";
      entry.startWorkingTime = "09:00";
      entry.endWorkingTime = "19:00";
      var data = calculateWorkingTime(entry.startWorkingTime, entry.endWorkingTime, "01:00");
      entry.workingHour = data[0];
      entry.workingMinute = data[1];

      var actualWorkData = calculateWorkingTime(entry.scheduleStartWorkingTime, entry.scheduleEndWorkingTime, "01:00");
      entry.actualWorkingHour = actualWorkData[0];
      entry.actualWorkingMinute = actualWorkData[1];

      var breakTimeData = calculateBreakTime(entry.scheduleEndBreakTime, entry.scheduleStartBreakTime);
      entry.breakingTimeHour = breakTimeData[0];
      entry.breakingTimeMinute = breakTimeData[1];

      ///Calculate late data
      bool isLate = false;
      List<int> lateData = calculateLateTime(entry.scheduleStartWorkingTime, entry.startWorkingTime);
      int lateHour = lateData[0];
      int lateMinute = lateData[1];
      if (lateHour > 0 || lateMinute > 0) {
        isLate = true;
      }
      entry.latHour = lateHour;
      entry.lateMinute = lateMinute;
      entry.isLate = isLate;

      ///Calculate leave early data
      bool isLeaveEarly = false;
      int leaveEarlyHour = 0;
      int leaveEarlyMinute = 0;
      List<int> leaveData = calculateBreakTime(entry.endWorkingTime, entry.scheduleEndWorkingTime);
      leaveEarlyHour = leaveData[0];
      leaveEarlyMinute = leaveData[1];
      if (leaveEarlyMinute > 0 || leaveEarlyHour > 0) {
        isLeaveEarly = true;
      }
      entry.isLeaveEarly = isLeaveEarly;
      entry.leaveEarlyMinute = leaveEarlyMinute;
      entry.leaveEarlyHour = leaveEarlyHour;

      ///Calculate Overtime
      List<int> overTimeData = calculateOvertime(entry.scheduleEndWorkingTime, entry.endWorkingTime, "00:00");
      entry.overtime =
          "${DateToAPIHelper.formatTimeTwoDigits(overTimeData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(overTimeData[1].toString())}";

      ///within statutory
      var scheduleWorkingData = calculateWorkingTime(entry.scheduleStartWorkingTime, entry.scheduleEndWorkingTime, "01:00");
      List<int> withinStatutoryData = calculateWorkingTime("${scheduleWorkingData[0]}:${scheduleWorkingData[1]}", "$overTimeLegalLimit:00", "00:00");
      entry.overtimeWithinLegalLimit =
          "${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(withinStatutoryData[1].toString())}";

      ///non statutory
      List<int> nonStatutoryData = calculateBreakTime(entry.overtime, entry.overtimeWithinLegalLimit);
      entry.nonStatutoryOvertime =
          "${DateToAPIHelper.formatTimeTwoDigits(nonStatutoryData[0].toString())}:${DateToAPIHelper.formatTimeTwoDigits(nonStatutoryData[1].toString())}";

      await entryRef.doc(entry.uid).update(entry.toJson());
      return true;
    } catch (e) {
      Logger.printLog("Error insertEntryDataForPaidLeave =>> ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateReview(String entryId, String userId, Review review) async {
    try {
      print("update review $userId, $entryId, ${review.rate}");
      await entryRef.doc(entryId).update({"review": review.toJson()});
      await userRef.doc(userId).update({
        "review": FieldValue.arrayUnion([review.toJson()])
      });
      return true;
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return false;
    }
  }
}
