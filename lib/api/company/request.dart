import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/company/request.dart';
import '../../utils/log.dart';

class RequestApiService {
  final CollectionReference requestRef = FirebaseFirestore.instance.collection('request');

  Future<List<Request>> getRequestByDate(String date, String jobPostingId) async {
    try {
      print("getRequestByDate $date, $jobPostingId");
      var doc = await requestRef.where("date", isEqualTo: date).where("jobId", isEqualTo: jobPostingId).get();
      if (doc.docs.isEmpty) {
        return [];
      } else {
        List<Request> requestList = [];
        for (var data in doc.docs) {
          Request request = Request.fromJson(data.data() as Map<String, dynamic>);
          request.myUser = await UserApiServices().getProfileUser(request.userId!);
          request.uid = data.id;
          requestList.add(request);
        }
        return requestList;
      }
    } catch (e) {
      Logger.printLog("Error requestLeave =>> ${e.toString()}");
      return [];
    }
  }

  Future<bool> updateRequestStatus(Request request, String status) async {
    try {
      WorkerManagement? workerManagement = await WorkerManagementApiService().getAJob(request.applyJobId!);
      if (workerManagement != null) {
        for (var shift in workerManagement.shiftList!) {
          bool isDateEqual = DateToAPIHelper.convertDateToString(shift.date!) == request.date;
          bool isStartTimeEqual = shift.startWorkTime == request.shiftModel!.startWorkTime;
          bool isEndTimeEqual = shift.endWorkTime == request.shiftModel!.endWorkTime;
          if (isDateEqual && isStartTimeEqual && isEndTimeEqual) {
            if (status == "approved") {
              shift.startWorkTime = request.fromTime.toString();
              shift.endWorkTime = request.toTime.toString();
            } else {
              shift.startWorkTime = request.shiftModel!.startWorkTime.toString();
              shift.endWorkTime = request.shiftModel!.endWorkTime.toString();
            }
            break;
          }
        }
        await WorkerManagementApiService().updateShiftStatus(workerManagement.shiftList!, request.applyJobId!);
        await requestRef.doc(request.uid).update({"status": status});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger.printLog("Error requestLeave =>> ${e.toString()}");
      return false;
    }
  }
}
