import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:flutter/foundation.dart';

import '../api/withraw.dart';
import '../models/widthraw.dart';
import '../utils/japanese_text.dart';

class WithdrawProvider with ChangeNotifier {
  List<WithdrawModel> withdrawList = [];
  bool isLoading = true;
  List<String> userList = [JapaneseText.all];
  String selectUser = JapaneseText.all;

  DateTime? startDate;
  DateTime? endDate;

  set setLoading(bool loading) {
    isLoading = loading;
  }

  initData() {
    withdrawList = [];
    userList = [JapaneseText.all];
    selectUser = JapaneseText.all;
    startDate = null;
    endDate = null;
  }

  onChangeUser(String user, String branchId) {
    selectUser = user;
    filter(branchId);
    notifyListeners();
  }

  onChangeStartDate(DateTime? startDate, String branchId) {
    this.startDate = startDate;
    filter(branchId);
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate, String branchId) {
    this.endDate = endDate;
    filter(branchId);
    notifyListeners();
  }

  filter(String branchId) async {
    await onGetData(branchId);
    List<WithdrawModel> afterFilterStatus = [];
    if (selectUser != null && selectUser != JapaneseText.all) {
      for (var job in withdrawList) {
        if (job.workerName == selectUser) {
          afterFilterStatus.add(job);
        }
      }
    } else {
      afterFilterStatus = withdrawList;
    }
    List<WithdrawModel> afterFilterRangeDate = [];
    if (startDate != null && endDate != null) {
      for (var job in afterFilterStatus) {
        bool isWithin = CommonUtils.isDateInRange(job.createdAt!, startDate!, endDate!);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterStatus;
    }
    withdrawList = afterFilterRangeDate;
    notifyListeners();
  }

  bool isDateRangeWithin(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isAfterOrEqualTo(start2) && end1.isBeforeOrEqualTo(end2);
  }

  onGetData(String branchId) async {
    withdrawList = await WithdrawApiService().getAllWithdraw(branchId);
    List<String> userList = withdrawList.map((e) => e.workerName.toString()).toList().toSet().toList();
    this.userList = [JapaneseText.all];
    this.userList.addAll(userList);
    onChangeLoading(false);
  }

  onChangeLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
