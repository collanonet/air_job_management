import 'dart:collection';

import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/calendar.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/item_select.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../api/company/worker_managment.dart';
import '../../api/job_posting.dart';
import '../../models/company/worker_management.dart';
import '../../models/job_posting.dart';
import '../../models/worker_model/shift.dart';
import '../../utils/japanese_text.dart';

class ShiftCalendarProvider with ChangeNotifier {
  List<String> displayList = [JapaneseText.perWorker, JapaneseText.perShift, JapaneseText.calendarDisplay];
  String selectDisplay = JapaneseText.perWorker;
  List<ItemSelectModel> jobTitleList = [ItemSelectModel(title: JapaneseText.all, id: "")];
  ItemSelectModel? selectedJobTitle = ItemSelectModel(title: JapaneseText.all, id: "");
  bool isLoading = false;
  DateTime? startWorkDate;
  DateTime? endWorkDate;
  DateTime month = DateTime.now();
  static DateTime now = DateTime.now();
  String companyId = "";
  List<CalendarModel> rangeDateList = [];
  List<GroupedCalendarModel> shiftBySeekerPerMonth = [];
  List<JobPostingDataTable> jobPostingDataTableList = [];
  List<DateTime> dateTimeList = [];
  DateTime firstDate = DateTime(now.year, now.month, 1);

  JobPosting? jobPosting;
  List<JobPosting> jobPostingList = [];
  List<WorkerManagement> jobApplyPerDay = [];

  set setCompanyId(String companyId) {
    this.companyId = companyId;
  }

  initSelectDisplay() {
    jobPosting = null;
    selectDisplay = JapaneseText.perWorker;
  }

  initData() async {
    // selectDisplay = JapaneseText.calendarDisplay;
    jobTitleList = [ItemSelectModel(title: JapaneseText.all, id: "")];
    selectedJobTitle = ItemSelectModel(title: JapaneseText.all, id: "");
    startWorkDate = null;
    endWorkDate = null;
  }

  refreshData(String branchId) {
    initData();
    filterApplicantList(branchId);
  }

  initializeRangeDate() async {
    await initData();
    dateTimeList.clear();
    rangeDateList.clear();
    DateTime lastDate = DateTime(month.year, month.month + 1, 0);
    for (var i = 1; i <= lastDate.day; ++i) {
      dateTimeList.add(DateTime(month.year, month.month, i));
      rangeDateList.add(CalendarModel(date: DateTime(month.year, month.month, i), shiftModelList: []));
    }
  }

  onChangeMonth(DateTime month) async {
    this.month = month;
    firstDate = DateTime(month.year, month.month, 1);
    await initializeRangeDate();
    notifyListeners();
  }

  onChangeDisplay(String val) {
    selectDisplay = val;
    // if (val == displayList[1]) {
    //   initializeJobPosting();
    // }
    notifyListeners();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  onChangeTitle(ItemSelectModel? val, String branchId) {
    selectedJobTitle = val;
    filterApplicantList(branchId);
    notifyListeners();
  }

  onChangeStartDate(DateTime? startDate, String branchId) {
    startWorkDate = startDate;
    filterApplicantList(branchId);
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate, String branchId) {
    endWorkDate = endDate;
    filterApplicantList(branchId);
    notifyListeners();
  }

  filterApplicantList(String branchId) async {
    await getApplicantList(companyId, branchId);

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

  getApplicantList(String companyId, String branchId) async {
    print("Get applicant by $companyId x $branchId");
    jobApplyList = await WorkerManagementApiService().getAllJobApply(companyId, branchId);
    await initializeJobPosting();
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
    var data = await Future.wait([for (var job in jobApplyList) JobPostingApiService().getAJobPosting(job.jobId.toString())]);
    for (var job in data) {
      if (job != null) {
        jobPostingList.add(job);
      }
    }

    ///Updated 22 June
    jobPostingList = jobPostingList.toSet().toList();
    onChangeLoading(false);
  }

  calculateCalendarData() {
    for (var date in rangeDateList) {
      date.shiftModelList!.clear();
    }
    for (var job in jobApplyList) {
      for (var shift in job.shiftList!) {
        //For Apply Job List
        shift.applicantCount = shift.status == "approved" || shift.status == "completed" ? 1 : 0;
        for (var data in rangeDateList) {
          if (CommonUtils.isTheSameDate(data.date, shift.date)) {
            shift.jobId = job.uid;
            String major = "";
            //find recruitment
            for (var j in jobPostingList) {
              if (job.jobId == j.uid) {
                major = j.occupationType ?? "";
                shift.recruitmentCount = j.numberOfRecruit ?? "0";
                shift.myJob = SearchJob(uid: j.uid);
                break;
              }
            }
            data.shiftModelList!.add(shift);
            data.jobId = job.jobId;
            data.major = major;
            data.applyName = job.myUser?.nameKanJi ?? job.userName ?? "";
            break;
          }
        }
      }
    }
    for (var data in rangeDateList) {
      // data.shiftModelList = data.shiftModelList!.toSet().toList();
      Map<String, int> shiftCountMap = {};

      // Count duplicates and remove them
      data.shiftModelList!.removeWhere((shift) {
        String key = "${shift.date}-${shift.startWorkTime}-${shift.endWorkTime}-${shift.myJob?.uid ?? ""}";
        if (shiftCountMap.containsKey(key)) {
          if (shift.status == "approved" || shift.status == "completed") {
            shiftCountMap[key] = shiftCountMap[key]! + shift.applicantCount;
          } else {
            shiftCountMap[key] = shiftCountMap[key]!;
          }
          return true;
        } else {
          shiftCountMap[key] = shift.applicantCount;
          return false;
        }
      });

      // Update applicant count in the original list
      data.shiftModelList!.forEach((shift) {
        String key = "${shift.date}-${shift.startWorkTime}-${shift.endWorkTime}-${shift.myJob?.uid ?? ""}";
        shift.applicantCount = shiftCountMap[key]!;
      });

      //Find Apply Count
      for (var shift in data.shiftModelList!) {
        shift.userNameList = [];
        // if (shift.recruitmentCount == "0") {
        //   data.shiftModelList!.remove(shift);
        // }
        for (var job in jobApplyList) {
          var dateList = job.shiftList!.map((e) => e.date!).toList();
          if (CommonUtils.isArrayOfDateContainDate(dateList, shift.date!) &&
              (job.shiftList![0].startWorkTime == shift.startWorkTime && job.shiftList![0].endWorkTime == shift.endWorkTime)) {
            // shift.applicantCount++;
            shift.userNameList!.add(job.myUser?.nameKanJi ?? job.userName.toString());
          }
        }
      }
    }
    jobApplyPerDay = [];

    for (var job in jobApplyList) {
      List<ShiftModel> shiftList = job.shiftList ?? [];
      if (CommonUtils.containsAnyDate(rangeDateList.map((e) => e.date).toList(), shiftList.map((e) => e.date!).toList())) {
        jobApplyPerDay.add(job);
      }
    }
    shiftBySeekerPerMonth = [];
    List<String> seekerIds = jobApplyList.map((e) => e.userId.toString()).toSet().toList();
    // print("Ids ${seekerIds.length}");

    ///Map name
    for (var seekerId in seekerIds) {
      var groupData = GroupedCalendarModel(
          calendarModels: rangeDateList.map((e) => CalendarModel(date: e.date, shiftModelList: [])).toList(), applyName: "", seekerId: "");
      for (var job in jobApplyPerDay) {
        if (job.userId == seekerId) {
          groupData.applyName = job.myUser?.nameKanJi ?? "";
          groupData.seekerId = seekerId;
          groupData.myUser = job.myUser;
          shiftBySeekerPerMonth.add(groupData);
          break;
        }
      }
    }

    // print("Group data ${shiftBySeekerPerMonth.map((e) => e.applyName.toString())}");

    for (var groupData in shiftBySeekerPerMonth) {
      for (var job in jobApplyPerDay) {
        if (job.userId == groupData.myUser?.uid) {
          List<ShiftModel> shiftList = job.shiftList ?? [];
          List<DateTime> dateListFromShift = shiftList.map((e) => e.date!).toList();
          for (var seeker in groupData.calendarModels!) {
            for (var shift in shiftList) {
              // print("Shift ${job.userId} - ${shift.date} x ${seeker.date}");
              if (CommonUtils.isTheSameDate(shift.date!, seeker.date) &&
                  (shift.status == "approved" || shift.status == "completed" || shift.status == "pending")) {
                seeker.shiftModelList = [shift];
                seeker.jobId = job.jobId;
                seeker.searchJobId = job.uid;
                seeker.applyName = job.myUser?.nameKanJi ?? "";
              }
            }
          }
        }
      }
    }
    notifyListeners();
  }

  findJobByOccupation(String branchId) async {
    jobPostingDataTableList = [];
    String id = FirebaseAuth.instance.currentUser?.uid ?? "";
    Company? company = await UserApiServices().getProfileCompany(id);
    var jobPostingList = await JobPostingApiService().getAllJobPostByCompany(company?.uid ?? "", branchId, isFromCalendar: false);
    for (var j in jobPostingList) {
      var startDate = DateToAPIHelper.fromApiToLocal(j.startDate ?? "");
      var endDate = DateToAPIHelper.fromApiToLocal(j.endDate ?? "");
      List<DateTime> dList = CommonUtils.getDateRange(startDate, endDate);
      if (company?.uid == j.companyId && CommonUtils.containsAnyDate(dateTimeList, dList)) {
        JobPostingDataTable jobPostingDataTable = JobPostingDataTable(
            countByDate: dateTimeList
                .map((e) => CountByDate(
                    date: DateTime(e.year, e.month, e.day, 0, 0, 0),
                    count: 0,
                    countOnlyApprove: 0,
                    recruitNumber: j.numberOfRecruit.toString(),
                    jobId: j.uid ?? "",
                    jobApplyId: ""))
                .toList(),
            recruitNumber: j.numberOfRecruit.toString(),
            jobId: j.uid ?? "",
            job: j.occupationType ?? "");
        int count = 0;
        for (var date in jobPostingDataTable.countByDate) {
          date.count = 0;
          date.countOnlyApprove = 0;
          for (var job in jobApplyList) {
            var dateList = job.shiftList!.map((e) => e.date).toList();
            if (job.jobId == date.jobId && dateList.contains(date.date)) {
              date.jobApplyId = job.uid ?? "";
              date.count++;
              // break;
            }
            for (var shift in job.shiftList!) {
              if (CommonUtils.isTheSameDate(date.date, shift.date!) &&
                  job.jobId == date.jobId &&
                  (shift.status == "approved" || shift.status == "completed")) {
                date.countOnlyApprove++;
              }
            }
          }
          // print("Count by date ${date.date} x ${date.countOnlyApprove}");
        }
        jobPostingDataTable.job = j.majorOccupation ?? "Empty";
        jobPostingDataTable.applyCount = count;
        jobPostingDataTable.isDelete = j.isDelete ?? false;
        jobPostingDataTableList.add(jobPostingDataTable);
      }
    }
    jobPostingDataTableList = jobPostingDataTableList.toSet().toList();

    ///Remove job that don't have apply
    // for (var jobApplyTable in jobPostingDataTableList) {
    //   bool atLeastHaveOne = false;
    //   for (var data in jobApplyTable.countByDate) {
    //     if (data.count > 0) {
    //       atLeastHaveOne = true;
    //       break;
    //     }
    //   }
    //   print("${jobApplyTable.job} x $atLeastHaveOne - ${jobApplyTable.isDelete}");
    //   if (!atLeastHaveOne && jobApplyTable.isDelete) {
    //     jobPostingDataTableList.remove(jobApplyTable);
    //   }
    // }
    notifyListeners();
  }

  List<GroupedCalendarModel> groupByApplyName(List<CalendarModel> calendarList) {
    Map<String?, GroupedCalendarModel> groupedData = HashMap();

    for (var calendarModel in calendarList) {
      if (groupedData.containsKey(calendarModel.applyName)) {
        groupedData[calendarModel.applyName]?.allShiftModels!.addAll(calendarModel.shiftModelList ?? []);
      } else {
        GroupedCalendarModel groupedModel = GroupedCalendarModel(applyName: calendarModel.applyName);
        groupedModel.allShiftModels!.addAll(calendarModel.shiftModelList ?? []);
        groupedData[calendarModel.applyName] = groupedModel;
      }
    }

    return groupedData.values.toList();
  }
}
