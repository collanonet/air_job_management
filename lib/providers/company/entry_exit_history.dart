import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:flutter/foundation.dart';

import '../../models/entry_calendar_by_user.dart';
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
  List<EntryCalendarByUserList> entryCalendarList = [];

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
    entryCalendarList.clear();
    for (int i = 1; i < endDay.day + 1; i++) {
      var date = DateTime(endDay.year, endDay.month, i);
      dateList.add(date);
      entryCalendarList.add(EntryCalendarByUserList(date: date));
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
        bool isWithin = CommonUtils.isDateInRange(workDate, startWorkDate!, endWorkDate!);
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
    List<String> userIdList = entryList.map((e) => e.userId!).toList().toSet().toList();
    var userData = await Future.wait([for (var id in userIdList) UserApiServices().getProfileUser(id)]);
    for (var entry in entryList) {
      for (var user in userData) {
        if (user!.uid == entry.userId) {
          entry.myUser = user;
          break;
        }
      }
    }
    jobTitleList = [JapaneseText.all];
    for (var job in entryList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();
    onChangeLoading(false);
  }

  mapDataForCalendarByUser() {
    for (var calendar in entryCalendarList) {
      for (var entry in entryList) {
        var workDate = DateToAPIHelper.fromApiToLocal(entry.workDate!);
        if (CommonUtils.isTheSameDate(workDate, calendar.date)) {
          calendar.list!.add(EntryCalendarByUser(
              date: workDate,
              myUser: entry.myUser,
              workingHour: "${entry.workingHour}:${entry.workingMinute}",
              entryId: entry.uid,
              holidayWork: "${entry.holidayWork}",
              nonStatutoryOvertime: "${entry.nonStatutoryOvertime}",
              totalOvertime: "${entry.overtime}",
              userName: "${entry.myUser?.nameKanJi}",
              withinLegal: "${entry.overtimeWithinLegalLimit}"));
        }
      }
    }
  }
}
