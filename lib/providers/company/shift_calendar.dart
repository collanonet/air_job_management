import 'package:air_job_management/utils/extension.dart';
import 'package:flutter/cupertino.dart';

import '../../api/company/worker_managment.dart';
import '../../models/company/worker_management.dart';
import '../../utils/japanese_text.dart';

class ShiftCalendarProvider with ChangeNotifier {
  List<String> jobTitleList = [JapaneseText.all];
  String? selectedJobTitle = JapaneseText.all;
  bool isLoading = false;
  DateTime? startWorkDate;
  DateTime? endWorkDate;
  DateTime month = DateTime.now();
  static DateTime now = DateTime.now();
  String companyId = "";
  List<DateTime> rangeDateList = [];
  DateTime firstDate = DateTime(now.year, now.month, 1);

  set setCompanyId(String companyId) {
    this.companyId = companyId;
  }

  initializeRangeDate() {
    rangeDateList.clear();
    DateTime lastDate = DateTime(month.year, month.month + 1, 0);
    for (var i = 1; i <= lastDate.day; ++i) {
      rangeDateList.add(DateTime(month.year, month.month, i));
    }
  }

  onChangeMonth(DateTime month) {
    this.month = month;
    firstDate = DateTime(month.year, month.month, 1);
    initializeRangeDate();
    notifyListeners();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  onChangeTitle(String? val) {
    selectedJobTitle = val;
    filterApplicantList();
    notifyListeners();
  }

  onChangeStartDate(DateTime? startDate) {
    startWorkDate = startDate;
    filterApplicantList();
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate) {
    endWorkDate = endDate;
    filterApplicantList();
    notifyListeners();
  }

  filterApplicantList() async {
    await getApplicantList(companyId);

    ///Filter application by job title
    List<WorkerManagement> afterFilterSelectJobTitle = [];
    if (selectedJobTitle != null && selectedJobTitle != JapaneseText.all) {
      for (var job in jobApplyList) {
        if (job.jobTitle.toString().contains(selectedJobTitle.toString())) {
          afterFilterSelectJobTitle.add(job);
        }
      }
    } else {
      afterFilterSelectJobTitle = jobApplyList;
    }
    print("afterFilterSelectJobTitle ${afterFilterSelectJobTitle.length}");
    List<WorkerManagement> afterFilterRangeDate = [];
    if (startWorkDate != null && endWorkDate != null) {
      for (var job in afterFilterSelectJobTitle) {
        bool isWithin = isDateRangeWithin(job.shiftList!.first.date!,
            job.shiftList!.last.date!, startWorkDate!, endWorkDate!);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterSelectJobTitle;
    }
    print("afterFilterRangeDate ${afterFilterRangeDate.length}");
    jobApplyList = afterFilterRangeDate;
    notifyListeners();
  }

  bool isDateRangeWithin(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isAfterOrEqualTo(start2) && end1.isBeforeOrEqualTo(end2);
  }

  List<WorkerManagement> jobApplyList = [];

  getApplicantList(String companyId) async {
    jobTitleList = [JapaneseText.all];
    jobApplyList = await WorkerManagementApiService().getAllJobApply(companyId);
    for (var job in jobApplyList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();
    notifyListeners();
  }
}
