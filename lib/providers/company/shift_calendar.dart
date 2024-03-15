import 'package:air_job_management/models/calendar.dart';
import 'package:air_job_management/models/item_select.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:flutter/cupertino.dart';

import '../../api/company/worker_managment.dart';
import '../../api/job_posting.dart';
import '../../models/company/worker_management.dart';
import '../../models/job_posting.dart';
import '../../utils/japanese_text.dart';

class ShiftCalendarProvider with ChangeNotifier {
  List<String> displayList = [JapaneseText.calendarDisplay, JapaneseText.listDisplay];
  String selectDisplay = JapaneseText.calendarDisplay;
  List<ItemSelectModel> jobTitleList = [ItemSelectModel(title: JapaneseText.all, id: "")];
  ItemSelectModel? selectedJobTitle = ItemSelectModel(title: JapaneseText.all, id: "");
  bool isLoading = false;
  DateTime? startWorkDate;
  DateTime? endWorkDate;
  DateTime month = DateTime.now();
  static DateTime now = DateTime.now();
  String companyId = "";
  List<CalendarModel> rangeDateList = [];
  DateTime firstDate = DateTime(now.year, now.month, 1);

  JobPosting? jobPosting;
  List<JobPosting> jobPostingList = [];

  set setCompanyId(String companyId) {
    this.companyId = companyId;
  }

  initData() {
    selectDisplay = JapaneseText.calendarDisplay;
    jobTitleList = [ItemSelectModel(title: JapaneseText.all, id: "")];
    selectedJobTitle = ItemSelectModel(title: JapaneseText.all, id: "");
    startWorkDate = null;
    endWorkDate = null;
  }

  refreshData() {
    initData();
    filterApplicantList();
  }

  initializeRangeDate() {
    initData();
    rangeDateList.clear();
    DateTime lastDate = DateTime(month.year, month.month + 1, 0);
    for (var i = 1; i <= lastDate.day; ++i) {
      rangeDateList.add(CalendarModel(date: DateTime(month.year, month.month, i), shiftModelList: []));
    }
  }

  onChangeMonth(DateTime month) {
    this.month = month;
    firstDate = DateTime(month.year, month.month, 1);
    initializeRangeDate();
    notifyListeners();
  }

  onChangeDisplay(String val) {
    selectDisplay = val;
    if (val == displayList[1]) {
      initializeJobPosting();
    }
    notifyListeners();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  onChangeTitle(ItemSelectModel? val) {
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
    if (selectedJobTitle != null && selectedJobTitle?.title != JapaneseText.all) {
      for (var job in jobApplyList) {
        if (job.jobId == selectedJobTitle?.id) {
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
        bool isWithin = isDateRangeWithin(job.shiftList!.first.date!, job.shiftList!.last.date!, startWorkDate!, endWorkDate!);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterSelectJobTitle;
    }
    print("afterFilterRangeDate ${afterFilterRangeDate.length}");
    jobApplyList = afterFilterRangeDate;
    calculateCalendarData();
    notifyListeners();
  }

  bool isDateRangeWithin(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isAfterOrEqualTo(start2) && end1.isBeforeOrEqualTo(end2);
  }

  List<WorkerManagement> jobApplyList = [];

  getApplicantList(String companyId) async {
    jobApplyList = await WorkerManagementApiService().getAllJobApply(companyId);
    jobTitleList = [ItemSelectModel(title: JapaneseText.all, id: "")];
    for (var job in jobApplyList) {
      jobTitleList.add(ItemSelectModel(title: job.jobTitle, id: job.jobId));
    }
    jobTitleList = jobTitleList.toSet().toList();

    ///Calendar
    calculateCalendarData();
    notifyListeners();
  }

  initializeJobPosting() async {
    onChangeLoading(true);
    jobPostingList.clear();
    var data = await Future.wait([for (var job in jobApplyList) JobPostingApiService().getAJobPosting(job.jobId!)]);
    jobPostingList = data.map((e) => e!).toList();
    onChangeLoading(false);
  }

  calculateCalendarData() {
    for (var date in rangeDateList) {
      date.shiftModelList!.clear();
    }
    for (var job in jobApplyList) {
      for (var shift in job.shiftList!) {
        for (var data in rangeDateList) {
          if (data.date == shift.date) {
            data.shiftModelList!.add(shift);
            data.jobId = job.uid;
            break;
          }
        }
      }
    }
    for (var data in rangeDateList) {
      data.shiftModelList = data.shiftModelList!.toSet().toList();
    }
  }
}
