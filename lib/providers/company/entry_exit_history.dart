import 'package:air_job_management/api/company/request.dart';
import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/entry_exit.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/models/shift_and_work_time.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';

import '../../api/job_posting.dart';
import '../../models/company/worker_management.dart';
import '../../models/entry_calendar_by_user.dart';
import '../../models/entry_exit_history.dart';
import '../../models/job_posting.dart';
import '../../utils/japanese_text.dart';

class EntryExitHistoryProvider with ChangeNotifier {
  List<EntryExitHistory> entryList = [];
  List<EntryExitHistory> entryListByBranch = [];
  bool isLoading = false;
  bool overlayLoadingFilter = false;
  List<String> displayList = [
    JapaneseText.byMonth,
    JapaneseText.perWorker,
    "勤怠管理一覧",
    "所定労働時間外一覧"
  ];
  String selectDisplay = JapaneseText.byMonth;

  List<String> tabMenu = ["勤怠", "シフト"];
  String selectedMenu = "勤怠";

  DateTime startDay = DateTime.now();
  DateTime endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  List<DateTime> dateList = [];
  List<String> moreMenuShiftAndWorkTimeByUserList = [
    "公休",
    "有休",
    "欠勤",
    "休出",
    "遅刻",
    "早退",
    "特休",
    "振休"
  ];
  List<EntryExitCalendarByUser> entryExitCalendarByUser = [];
  List<ShiftAndWorkTimeByUser> shiftAndWorkTimeByUserList = [];
  List<String> userNameList = [];
  String selectedUserName = "";
  List<String> rowHeaderTable = [
    "日付", //"Date", 1
    "曜日", //"Day of the week", 2
    "シフト", //"Shift", 3
    "出勤", //"Attend", 4
    "退勤", //"Leave", 5
    "休憩", //"Paid leave", 6
    // "遅刻", //"Late", 7
    // "早退", //"Leave early", 8
    "実働", //"Actual work", 9
    "法定内", //"Within legal limits", 10
    "法定外", //"Overtime",
    "休日出勤", //"Working on holidays",
    // "所労外", //"Outside legal limits",
    // "所労外累計", //"Cumulative total outside legal limits",
    "総勤務時間", //"Total working hours",
  ];

  List<String> rowHeaderForAttendanceManagementList = [
    "氏名", //Name
    "職種", //Type Of Work
    "実出勤日数", //Total of actual work day
    "総出勤日数", //Total number of day worked
    "有休消化", //Paid Leave
    "有休残数", // Remaining number of paid holidays
    "公休日数", // Public Holiday
    "休出日数", // Number of holiday work days (within statutory working hours）
    "欠勤日数", // Number of days absent
    "遅刻回数", //Number of late
    "法定内残業", // Within statutory working hours,
    "法定外残業", // Excess statutory working hours,
    // "基準残業", // Standard overtime
    "超過残業", // Excessive overtime
    "深夜時間", // Midnight
    "休出時間", // Number of holiday work times
    "実勤務時間", // Actual work hours
    "総勤務時間", // Total working hours
    "所定外計", // Total of overtime working hours
  ];

  List<WorkerManagement> workManagementList = [];

  String? selectedJobTitle;
  List<String> jobTitleList = [JapaneseText.all];

  String? selectedBranch;
  List<String> branchList = [JapaneseText.all];
  List<Branch> allBranchFromAuth = [];

  String? selectedUsernameForEntryExit;
  List<String> usernameListForEntryExit = [JapaneseText.all];

  DateTime? startWorkDate;
  DateTime? endWorkDate;

  String companyId = "";
  String branchId = "";

  List<Request> request = [];

  set setCompanyId(String id) {
    companyId = id;
  }

  set setBranchId(String id) {
    branchId = id;
  }

  set setLoading(bool loading) {
    isLoading = loading;
  }

  initData(BuildContext context) {
    selectedJobTitle = null;
    overlayLoadingFilter = false;
    dateList = [];
    startDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    for (int i = 1; i < endDay.day + 1; i++) {
      var date = DateTime(endDay.year, endDay.month, i);
      dateList.add(date);
    }
    var auth = AuthProvider.getProvider(context, listen: false);
    branchList = [JapaneseText.all];
    for (var branch in auth.myCompany!.branchList!) {
      branchList.add(branch.name.toString());
    }
    allBranchFromAuth = auth.myCompany!.branchList ?? [];
    selectedBranch = branchList.first;
  }

  onChangeTitle(String? val, String branchId) {
    if (branchId.isEmpty) {
      selectedBranch = val;
    } else {
      selectedJobTitle = val;
    }
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  onChangeUsernameForEntryExit(String? val, String branchId) {
    selectedUsernameForEntryExit = val;
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

  onChangeUserName(String name, String branchId) {
    selectedUserName = name;
    getUserShift(companyId, branchId);
    notifyListeners();
  }

  onChangeOverlayLoading(bool loading) {
    overlayLoadingFilter = loading;
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate, String branchId) {
    endWorkDate = endDate;
    filterEntryExitHistory(branchId);
    notifyListeners();
  }

  getBranch(String title) {
    Branch? b;
    for (var branch in allBranchFromAuth) {
      if (title == branch.name) {
        b = branch;
        break;
      }
    }
    return b;
  }

  filterEntryExitHistory(String branchId) async {
    await getEntryData(companyId);
    var jobPostingList = [];
    if (branchId == "") {
      jobPostingList = await JobPostingApiService()
          .getAllJobPostByCompany(companyId, branchId);
    }

    ///Filter application by job title
    List<EntryExitHistory> afterFilterSelectJobTitle = [];
    if (branchId == "") {
      //for main branch
      if (selectedBranch != null &&
          selectedBranch != "企業" &&
          selectedBranch != JapaneseText.all) {
        for (var entry in entryList) {
          JobPosting? jobPost;
          for (var job in jobPostingList) {
            if (job.uid == entry.jobID) {
              jobPost = job;
              break;
            }
          }
          if (jobPost != null) {
            Branch? branch = getBranch(selectedBranch!);
            if (branch?.id == jobPost.branchId) {
              afterFilterSelectJobTitle.add(entry);
            }
          }
        }
      } else {
        afterFilterSelectJobTitle = entryList;
      }
    } else {
      //for branch
      if (selectedJobTitle != null && selectedJobTitle != jobTitleList[0]) {
        for (var job in entryListByBranch) {
          if (job.jobTitle == selectedJobTitle) {
            afterFilterSelectJobTitle.add(job);
          }
        }
      } else {
        afterFilterSelectJobTitle = entryListByBranch;
      }
    }

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

    List<EntryExitHistory> afterFilterUsername = [];
    if (selectedUsernameForEntryExit != null &&
        selectedUsernameForEntryExit != JapaneseText.all) {
      for (var job in afterFilterRangeDate) {
        if (job.myUser!.nameKanJi
            .toString()
            .contains(selectedUsernameForEntryExit.toString())) {
          afterFilterUsername.add(job);
        }
      }
    } else {
      afterFilterUsername = afterFilterRangeDate;
    }
    if (branchId == "") {
      entryList = afterFilterUsername;
    } else {
      entryListByBranch = afterFilterUsername;
    }
    onChangeOverlayLoading(false);
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

  onChangeDisplay(String title, String branchId) {
    selectDisplay = title;
    notifyListeners();
  }

  onChangeLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  getEntryData(String id, {bool shiftAndWork = false}) async {
    onChangeOverlayLoading(true);
    companyId = id;
    branchId = branchId;
    entryList = await EntryExitApiService().getAllEntryList(id);
    List<String> userIdList =
        entryList.map((e) => e.userId!).toList().toSet().toList();
    var userData = await Future.wait(
        [for (var id in userIdList) UserApiServices().getProfileUser(id)]);
    for (var entry in entryList) {
      for (var user in userData) {
        if (user!.uid == entry.userId) {
          entry.myUser = user;
          break;
        }
      }
    }
    await mapDataForEntryByBranch();
    if (branchId == "") {
      userNameList = entryList
          .map((e) => e.myUser?.nameKanJi ?? "")
          .toList()
          .toSet()
          .toList();
    } else {
      userNameList = entryListByBranch
          .map((e) => e.myUser?.nameKanJi ?? "")
          .toList()
          .toSet()
          .toList();
    }
    if (selectedUserName == "" || selectedUserName == null) {
      selectedUserName = userNameList.first;
    }
    mapDataForCalendarByUser();

    ///Improve performance
    if (shiftAndWork) {
      await mapDataForShiftAndWorkTime();
    }
    jobTitleList = [JapaneseText.all];
    usernameListForEntryExit = [JapaneseText.all];
    if (branchId == "") {
      for (var job in entryList) {
        jobTitleList.add(job.jobTitle.toString());
        usernameListForEntryExit.add(job.myUser?.nameKanJi ?? "");
      }
    } else {
      for (var job in entryListByBranch) {
        jobTitleList.add(job.jobTitle.toString());
        usernameListForEntryExit.add(job.myUser?.nameKanJi ?? "");
      }
    }
    jobTitleList = jobTitleList.toSet().toList();
    usernameListForEntryExit = usernameListForEntryExit.toSet().toList();
    getUserShift(companyId, branchId);
    onChangeOverlayLoading(false);
  }

  mapDataForEntryByBranch() async {
    entryListByBranch = [];
    if (branchId == "") {
      entryListByBranch = entryList;
    } else {
      var jobPostingList = await JobPostingApiService()
          .getAllJobPostByCompany(companyId, branchId);
      for (var entry in entryList) {
        for (var jobPost in jobPostingList) {
          if (jobPost.uid == entry.jobID) {
            entryListByBranch.add(entry);
            break;
          }
        }
      }
    }
    entryListByBranch = entryListByBranch.toSet().toList();
    print("Entry by branch ${entryListByBranch.length}");
  }

  mapDataForCalendarByUser() {
    entryExitCalendarByUser.clear();
    List<EntryExitHistory> afterFilterRangeDate = [];
    if (branchId == "") {
      for (var job in entryList) {
        DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
        bool isWithin = CommonUtils.isDateInRange(workDate, startDay, endDay);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      for (var job in entryListByBranch) {
        DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
        bool isWithin = CommonUtils.isDateInRange(workDate, startDay, endDay);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    }
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
                  nonStatutoryOvertime:
                      "${CommonUtils.calculateOvertimeInEntry(entry, nonSat: true)}",
                  totalOvertime:
                      "${CommonUtils.calculateOvertimeInEntry(entry, isOvertime: true)}",
                  userName: "${entry.myUser?.nameKanJi}",
                  withinLegal:
                      "${CommonUtils.calculateOvertimeInEntry(entry, withInLimit: true)}");
            }
          }
        }
      }
    }
    entryExitCalendarByUser = entryExitCalendarByUser.toSet().toList();
  }

  mapDataForShiftAndWorkTime() async {
    shiftAndWorkTimeByUserList.clear();
    request.clear();
    var data = await Future.wait([
      WorkerManagementApiService().getAllJobApply(companyId, branchId),
      RequestApiService().getRequestBetweenDate(
          DateToAPIHelper.convertDateToString(startDay),
          DateToAPIHelper.convertDateToString(endDay))
    ]);
    List<WorkerManagement> workManagementList =
        data[0] as List<WorkerManagement>;
    request = data[1] as List<Request>;
    // print("Request between $startDay x $endDay ${request.length}");
    List<EntryExitHistory> afterFilterEntryRangeDate = [];
    for (var job in entryListByBranch) {
      DateTime workDate = DateToAPIHelper.fromApiToLocal(job.workDate!);
      bool isWithin = CommonUtils.isDateInRange(workDate, startDay, endDay);
      if (isWithin) {
        afterFilterEntryRangeDate.add(job);
      }
    }

    List<WorkerManagement> afterFilterRangeDate = [];
    for (var job in workManagementList) {
      List<DateTime> dateList = job.shiftList!.map((e) => e.date!).toList();
      bool isWithin = CommonUtils.containsAnyDate(dateList, this.dateList);
      bool approved = false;
      if (job.shiftList!
              .map((e) => e.status)
              .toList()
              .toString()
              .contains("approved") ||
          job.shiftList!
              .map((e) => e.status)
              .toList()
              .toString()
              .contains("completed")) {
        approved = true;
      }
      if (isWithin && approved) {
        afterFilterRangeDate.add(job);
      }
    }

    List<String> nameList = [];
    for (var entry in afterFilterRangeDate) {
      nameList.add(entry.myUser!.nameKanJi!);
    }
    nameList = nameList.toSet().toList();

    ///Map data for name list
    for (var name in nameList) {
      var entryByUser =
          ShiftAndWorkTimeByUser(userName: name, list: [], shiftList: []);
      for (var date in dateList) {
        entryByUser.list.add(ShiftAndWorkTimeByUserByDate(date: date));
      }
      shiftAndWorkTimeByUserList.add(entryByUser);
    }

    ///Map data for shift display at S3
    for (var entryByUser in shiftAndWorkTimeByUserList) {
      //Map data for add shift
      for (var job in afterFilterRangeDate) {
        List<DateTime> dateList = job.shiftList!.map((e) => e.date!).toList();
        bool isWithin = CommonUtils.containsAnyDate(dateList, this.dateList);
        bool isTheSameUser = false;
        if (job.myUser?.nameKanJi == entryByUser.userName) {
          entryByUser.myUser = job.myUser;
          isTheSameUser = true;
        }
        if (isWithin && isTheSameUser) {
          for (var shift in job.shiftList!) {
            if (CommonUtils.isArrayOfDateContainDate(dateList, shift.date!) &&
                (shift.status == "approved" || shift.status == "completed")) {
              entryByUser.shiftList!.add(shift);
            }
          }
        }
      }
    }

    ///Map data for working time and shift
    for (var entryByUser in shiftAndWorkTimeByUserList) {
      for (var entryDate in entryByUser.list) {
        entryDate.shiftAndWorkTime = ShiftAndWorkTime(
            userName: entryByUser.userName,
            endWorkTime: "",
            startWorkTime: "",
            paidHoliday: false,
            scheduleEndWorkTime: "",
            scheduleStartWorkTime: "",
            workingTime: "");
        for (var entry in afterFilterRangeDate) {
          if (entry.myUser!.nameKanJi == entryByUser.userName) {
            entryDate.shiftAndWorkTime!.myUser = entry.myUser;
            print(
                "Name ${entry.myUser!.nameKanJi} x ${entryByUser.userName} x ${entry.shiftList!.map((e) => e.date)}");
            for (var shift in entry.shiftList!) {
              if (CommonUtils.isTheSameDate(shift.date, entryDate.date) &&
                  (shift.status == "approved" || shift.status == "completed")) {
                entryDate.shiftAndWorkTime!.scheduleStartWorkTime =
                    shift.startWorkTime ?? "09:00";
                entryDate.shiftAndWorkTime!.scheduleEndWorkTime =
                    shift.endWorkTime ?? "18:00";
                for (var entryExit in afterFilterEntryRangeDate) {
                  DateTime workDate =
                      DateToAPIHelper.fromApiToLocal(entryExit.workDate!);
                  if (entryByUser.userName == entryExit.myUser?.nameKanJi &&
                      CommonUtils.isTheSameDate(entryDate.date, workDate)) {
                    entryDate.shiftAndWorkTime!.startWorkTime =
                        entryExit.startWorkingTime ?? "09:00";
                    entryDate.shiftAndWorkTime!.endWorkTime =
                        entryExit.endWorkingTime ?? "18:00";

                    entryDate.shiftAndWorkTime!.workingTime =
                        "${DateToAPIHelper.formatTimeTwoDigits(entryExit.workingHour.toString())}:${DateToAPIHelper.formatTimeTwoDigits(entryExit.workingMinute.toString())}";
                  }
                }
              }
            }
          }
        }
      }
    }
    shiftAndWorkTimeByUserList = shiftAndWorkTimeByUserList.toSet().toList();
    onChangeOverlayLoading(false);
  }

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
      RequestApiService().getTotalHolidayLeaveRequest(
          userId,
          DateToAPIHelper.convertDateToString(startDay),
          DateToAPIHelper.convertDateToString(endDay)),
      WorkerManagementApiService()
          .getAllJobApplyForAUSer(companyId, userId, branchId)
    ]);
    countDayOff = 0;
    List<Request> requestList = getData[0] as List<Request>;
    workManagementList = getData[1] as List<WorkerManagement>;
    for (var apply in workManagementList) {
      for (var shift in apply.shiftList!) {
        if (shift.status == "approved" || shift.status == "completed") {
          shiftList.add(shift);
        }
      }
      for (var request in requestList) {
        if (request.applyJobId == apply.uid) {
          if (request.status == "approved") {
            countDayOff++;
          }
        }
      }
    }
    // print("Get shift list $userId ${shiftList.length}");
    notifyListeners();
  }
}
