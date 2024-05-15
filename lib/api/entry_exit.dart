import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/dateTime_Cal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/date_to_api.dart';
import '../models/entry_exit_history.dart';
import '../utils/log.dart';

class EntryExitApiService {
  var entryRef = FirebaseFirestore.instance.collection("entry_exit_history");
  var userRef = FirebaseFirestore.instance.collection("user");
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
        List<int> leaveData = calculateBreakTime(entry.scheduleEndWorkingTime, entry.endWorkingTime);
        leaveEarlyHour = leaveData[0];
        leaveEarlyMinute = leaveData[1];
        if (leaveEarlyMinute > 0 || leaveEarlyHour > 0) {
          isLeaveEarly = true;
        }
        entry.isLeaveEarly = isLeaveEarly;
        entry.leaveEarlyMinute = leaveEarlyMinute;

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
