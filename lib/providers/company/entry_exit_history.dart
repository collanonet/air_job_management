import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:flutter/foundation.dart';

import '../../models/entry_exit_history.dart';
import '../../utils/japanese_text.dart';

class EntryExitHistoryProvider with ChangeNotifier {
  List<EntryExitHistory> entryList = [];
  bool isLoading = false;
  List<String> displayList = [JapaneseText.byMonth, JapaneseText.perWorker];
  String selectDisplay = JapaneseText.byMonth;
  DateTime startDay = DateTime.now();
  DateTime endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  List<DateTime> dateList = [];

  String? selectedJobTitle;
  List<String> jobTitleList = [JapaneseText.all];

  DateTime? startWorkDate;
  DateTime? endWorkDate;

  String companyId = "";

  set setCompanyId(String id) {
    companyId = id;
  }

  set setLoading(bool loading) {
    isLoading = loading;
  }

  initData() {
    dateList = [];
    startDay = DateTime.now();
    endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    for (int i = 1; i < endDay.day + 1; i++) {
      dateList.add(DateTime(endDay.year, endDay.month, i));
    }
  }

  onChangeTitle(String? val, String branchId) {
    selectedJobTitle = val;
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  onChangeStartDate(DateTime? startDate, String branchId) {
    startWorkDate = startDate;
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate, String branchId) {
    endWorkDate = endDate;
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  filterEntryExitHistory(String branchId) async {
    await getEntryData(companyId);
    print("Entry data $companyId ${entryList.length}");

    ///Filter application by job title
    List<EntryExitHistory> afterFilterSelectJobTitle = [];
    if (selectedJobTitle != null && selectedJobTitle != JapaneseText.all) {
      for (var job in entryList) {
        if (job.jobTitle.toString().contains(selectedJobTitle.toString())) {
          afterFilterSelectJobTitle.add(job);
        }
      }
    } else {
      afterFilterSelectJobTitle = entryList;
    }
    print("afterFilterSelectJobTitle ${afterFilterSelectJobTitle.length}");
    List<EntryExitHistory> afterFilterRangeDate = [];
    if (startWorkDate != null && endWorkDate != null) {
      for (var job in afterFilterSelectJobTitle) {
        DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
        bool isWithin =
            CommonUtils.isDateInRange(workDate, startWorkDate!, endWorkDate!);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterSelectJobTitle;
    }
    print("afterFilterRangeDate ${afterFilterRangeDate.length}");
    entryList = afterFilterRangeDate;
    notifyListeners();
  }

  onChangeMonth(DateTime now) {
    startDay = DateTime(now.year, now.month, 1);
    endDay = DateTime(now.year, now.month + 1, 0);
    notifyListeners();
  }

  onChangeDisplay(String title) {
    selectDisplay = title;
    notifyListeners();
  }

  onChangeLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  getEntryData(String id) async {
    companyId = id;
    entryList = await EntryExitApiService().getAllEntryList(id);
    jobTitleList = [JapaneseText.all];
    for (var job in entryList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();
    onChangeLoading(false);
  }
}
