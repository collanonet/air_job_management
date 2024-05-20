import 'package:air_job_management/api/company/request.dart';
import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/shift_and_work_time.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:flutter/foundation.dart';

import '../../models/company/worker_management.dart';
import '../../models/entry_calendar_by_user.dart';
import '../../models/entry_exit_history.dart';
import '../../utils/japanese_text.dart';

class EntryExitHistoryProvider with ChangeNotifier {
  List<EntryExitHistory> entryList = [];
  bool isLoading = false;
  List<String> displayList = [JapaneseText.byMonth, JapaneseText.perWorker, "勤怠管理一覧", "所定労働時間外一覧"];
  String selectDisplay = JapaneseText.byMonth;

  List<String> tabMenu = ["勤怠", "シフト"];
  String selectedMenu = "勤怠";

  DateTime startDay = DateTime.now();
  DateTime endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  List<DateTime> dateList = [];
  List<EntryExitCalendarByUser> entryExitCalendarByUser = [];
  List<ShiftAndWorkTimeByUser> shiftAndWorkTimeByUserList = [];
  List<String> userNameList = [];
  String selectedUserName = "";
  List<String> rowHeaderTable = [
    "日付",
    "曜日",
    "シフト",
    "出勤",
    "退勤",
    "有休",
    "遅刻",
    "早退",
    "実働",
    "法定内",
    "法定外",
    "休日出勤",
    "所労外",
    "所労外累計",
    "総勤務時間",
  ];

  List<WorkerManagement> workManagementList = [];

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
      var date = DateTime(endDay.year, endDay.month, i);
      dateList.add(date);
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

  onChangeSelectMenu(String menu) {
    selectedMenu = menu;
    selectDisplay = displayList[0];
    notifyListeners();
  }

  onChangeUserName(String name) {
    selectedUserName = name;
    getUserShift(companyId, "");
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate, String branchId) {
    endWorkDate = endDate;
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  filterEntryExitHistory(String branchId) async {
    await getEntryData(companyId);

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
    entryList = afterFilterRangeDate;
    notifyListeners();
  }

  onChangeMonth(DateTime now) {
    startDay = DateTime(now.year, now.month, 1);
    endDay = DateTime(now.year, now.month + 1, 0);
    dateList.clear();
    for (int i = 1; i < endDay.day + 1; i++) {
      var date = DateTime(endDay.year, endDay.month, i);
      dateList.add(date);
    }
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
    userNameList = entryList.map((e) => e.myUser?.nameKanJi ?? "").toList().toSet().toList();
    if (selectedUserName == "" || selectedUserName == null) {
      selectedUserName = userNameList.first;
    }
    mapDataForCalendarByUser();
    jobTitleList = [JapaneseText.all];
    for (var job in entryList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();

    getUserShift(companyId, "");

    onChangeLoading(false);
  }

  mapDataForCalendarByUser() {
    List<EntryExitHistory> afterFilterRangeDate = [];
    if (startDay != null && endDay != null) {
      for (var job in entryList) {
        DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
        bool isWithin = CommonUtils.isDateInRange(workDate, startDay, endDay);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = entryList;
    }
    entryExitCalendarByUser.clear();
    List<String> nameList = [];
    for (var entry in afterFilterRangeDate) {
      nameList.add(entry.myUser!.nameKanJi!);
    }
    nameList = nameList.toSet().toList();
    for (var name in nameList) {
      var entryByUser = EntryExitCalendarByUser(userName: name, list: []);
      for (var date in dateList) {
        entryByUser.list.add(EntryCalendarByUserDate(date: date));
      }
      entryExitCalendarByUser.add(entryByUser);
    }
    //Map data
    for (var entryByUser in entryExitCalendarByUser) {
      for (var entry in afterFilterRangeDate) {
        if (entry.myUser!.nameKanJi == entryByUser.userName) {
          var workDate = DateToAPIHelper.fromApiToLocal(entry.workDate!);
          for (var entryDate in entryByUser.list) {
            if (CommonUtils.isTheSameDate(workDate, entryDate.date)) {
              entryDate.entry = Entry(
                  myUser: entry.myUser,
                  workingHour: "${entry.workingHour}:${entry.workingMinute}",
                  entryId: entry.uid,
                  holidayWork: "${entry.holidayWork}",
                  nonStatutoryOvertime: "${entry.nonStatutoryOvertime}",
                  totalOvertime: "${entry.overtime}",
                  userName: "${entry.myUser?.nameKanJi}",
                  withinLegal: "${entry.overtimeWithinLegalLimit}");
            }
          }
        }
      }
    }
  }

  mapDataForShiftAndWorkTime() {
    List<EntryExitHistory> afterFilterEntryRangeDate = [];
    if (startDay != null && endDay != null) {
      for (var job in entryList) {
        DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
        bool isWithin = CommonUtils.isDateInRange(workDate, startDay, endDay);
        if (isWithin) {
          afterFilterEntryRangeDate.add(job);
        }
      }
    } else {
      afterFilterEntryRangeDate = entryList;
    }

    List<WorkerManagement> afterFilterRangeDate = [];
    if (startDay != null && endDay != null) {
      for (var job in workManagementList) {
        List<DateTime> dateList = job.shiftList!.map((e) => e.date!).toList();
        bool isWithin = CommonUtils.containsAnyDate(dateList, dateList);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterRangeDate;
    }
    shiftAndWorkTimeByUserList.clear();
    List<String> nameList = [];
    for (var entry in afterFilterRangeDate) {
      nameList.add(entry.myUser!.nameKanJi!);
    }
    nameList = nameList.toSet().toList();
    for (var name in nameList) {
      var entryByUser = ShiftAndWorkTimeByUser(userName: name, list: []);
      for (var date in dateList) {
        entryByUser.list.add(ShiftAndWorkTimeByUserByDate(date: date));
      }
      shiftAndWorkTimeByUserList.add(entryByUser);
    }
    //Map data
    for (var entryByUser in shiftAndWorkTimeByUserList) {
      for (var entry in afterFilterRangeDate) {
        if (entry.myUser!.nameKanJi == entryByUser.userName) {
          for (var shift in entry.shiftList!) {
            for (var entryDate in entryByUser.list) {
              if (CommonUtils.isTheSameDate(shift.date, entryDate.date)) {
                entryDate.shiftAndWorkTime = ShiftAndWorkTime(
                    myUser: entry.myUser,
                    userName: entryByUser.userName,
                    endWorkTime: "",
                    startWorkTime: "",
                    paidHoliday: false,
                    scheduleEndWorkTime: "",
                    scheduleStartWorkTime: "",
                    workingTime: "");
                for (var entryExit in afterFilterEntryRangeDate) {
                  DateTime workDate = DateToAPIHelper.fromApiToLocal(entryExit.workDate!);
                  if (entryByUser.userName == entryExit.myUser?.nameKanJi && entryDate.date == workDate) {
                    entryDate.shiftAndWorkTime!.startWorkTime = entryExit.startWorkingTime ?? "09:00";
                    entryDate.shiftAndWorkTime!.endWorkTime = entryExit.endWorkingTime ?? "18:00";
                    entryDate.shiftAndWorkTime!.scheduleStartWorkTime = entryExit.scheduleStartWorkingTime ?? "09:00";
                    entryDate.shiftAndWorkTime!.scheduleEndWorkTime = entryExit.scheduleEndWorkingTime ?? "18:00";
                    entryDate.shiftAndWorkTime!.workingTime =
                        "${DateToAPIHelper.formatTimeTwoDigits(entryExit.actualWorkingHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(entryExit.actualWorkingMinute.toString())}";
                    break;
                  }
                }
                break;
              }
            }
          }
        }
      }
    }
  }

  calculateWorkingTime() {}

  List<ShiftModel> shiftList = [];
  int countDayOff = 0;

  getUserShift(String companyId, String branchId) async {
    String userId = "";
    shiftList = [];

    for (var entry in entryList) {
      if (entry.myUser?.nameKanJi == selectedUserName) {
        userId = entry.myUser?.uid ?? "";
        break;
      }
    }
    var getData = await Future.wait([
      RequestApiService()
          .getTotalHolidayLeaveRequest(userId, DateToAPIHelper.convertDateToString(startDay), DateToAPIHelper.convertDateToString(endDay)),
      WorkerManagementApiService().getAllJobApplyForAUSerWithoutBranch(companyId, userId)
    ]);
    countDayOff = getData[0] as int;
    workManagementList = getData[1] as List<WorkerManagement>;
    for (var apply in workManagementList) {
      for (var shift in apply.shiftList!) {
        if (shift.status == "approved") {
          shiftList.add(shift);
        }
      }
    }

    notifyListeners();
  }
}
