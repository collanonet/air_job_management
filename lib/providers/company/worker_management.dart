import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/helper/status_helper.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

import '../../models/company/worker_management.dart';

class WorkerManagementProvider with ChangeNotifier {
  bool isLoading = true;
  String? selectedCooperationStatus = JapaneseText.all;
  List<String> cooperationStatus = [JapaneseText.all, "稼働経験あり", "お気に入り", "NG"];
  WorkerManagement? selectedJob;
  List<WorkerManagement> workManagementList = [];
  List<WorkerManagement> applicantList = [];
  DateTime? startWorkDate;
  DateTime? endWorkDate;
  String companyId = "";
  TextEditingController searchController = TextEditingController();

  List<String> jobStatus = [JapaneseText.all, JapaneseText.canceled, JapaneseText.hired, JapaneseText.pending];
  String? selectedJobStatus = JapaneseText.all;

  String? selectedJobTitle;
  List<String> jobTitleList = [JapaneseText.all];

  String selectedMenu = "基本情報";

  List<String> tabMenu = ["基本情報", "チャット", "応募履歴"];

  onChangeSelectMenu(String menu) {
    selectedMenu = menu;
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

  onChangeIsSelect(int index, bool val) {
    workManagementList[index].isSelect = val;
    notifyListeners();
  }

  set setCompanyId(String companyId) {
    this.companyId = companyId;
  }

  set setJob(WorkerManagement job) {
    selectedJob = job;
  }

  onInitForList() {
    searchController = TextEditingController();
    selectedJobStatus = JapaneseText.all;
    selectedCooperationStatus = JapaneseText.all;
    selectedJobTitle = JapaneseText.all;
    isLoading = true;
    selectedMenu = "基本情報";
    selectedJob = null;
  }

  filterApplicantList(String branchId) async {
    await getApplicantList(companyId, branchId);

    ///Filter application by job title
    List<WorkerManagement> afterFilterSelectJobTitle = [];
    if (selectedJobTitle != null && selectedJobTitle != JapaneseText.all) {
      for (var job in applicantList) {
        if (job.jobTitle.toString().contains(selectedJobTitle.toString())) {
          afterFilterSelectJobTitle.add(job);
        }
      }
    } else {
      afterFilterSelectJobTitle = applicantList;
    }
    print("afterFilterSelectJobTitle ${afterFilterSelectJobTitle.length}");
    List<WorkerManagement> afterFilterStatus = [];
    if (selectedJobStatus != null && selectedJobStatus != JapaneseText.all) {
      for (var job in afterFilterSelectJobTitle) {
        if (job.shiftList!.map((e) => e.status).toString().contains(StatusHelper.japanToEnglish(selectedJobStatus))) {
          afterFilterStatus.add(job);
        }
      }
    } else {
      afterFilterStatus = afterFilterSelectJobTitle;
    }
    print("afterFilterStatus ${afterFilterStatus.length}");
    List<WorkerManagement> afterFilterRangeDate = [];
    if (startWorkDate != null && endWorkDate != null) {
      for (var job in afterFilterStatus) {
        bool isWithin = isDateRangeWithin(job.shiftList!.first.date!, job.shiftList!.last.date!, startWorkDate!, endWorkDate!);
        if (isWithin) {
          afterFilterRangeDate.add(job);
        }
      }
    } else {
      afterFilterRangeDate = afterFilterStatus;
    }
    print("afterFilterRangeDate ${afterFilterRangeDate.length}");
    applicantList = afterFilterRangeDate;
    notifyListeners();
  }

  bool isDateRangeWithin(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isAfterOrEqualTo(start2) && end1.isBeforeOrEqualTo(end2);
  }

  filterWorkerManagement(String val, String branchId) async {
    await getWorkerApply(companyId, branchId);
    List<WorkerManagement> searchFilter = [];
    if (val.isNotEmpty) {
      for (var job in workManagementList) {
        if (job.userName.toString().toLowerCase().contains(val)) {
          searchFilter.add(job);
        }
      }
    } else {
      searchFilter = workManagementList;
    }
    workManagementList = searchFilter;
    notifyListeners();
  }

  onChangeLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onChangeJobStatus(String? val, String branchId) {
    selectedJobStatus = val;
    filterApplicantList(branchId);
    notifyListeners();
  }

  onChangeTitle(String? val, String branchId) {
    selectedJobTitle = val;
    filterApplicantList(branchId);
    notifyListeners();
  }

  onChangeSelectCooperationStatus(String? val) {
    selectedCooperationStatus = val;
    notifyListeners();
  }

  getWorkerApply(String companyId, String branchId, {bool isForMatchPage = false}) async {
    workManagementList = await WorkerManagementApiService().getAllJobApply(companyId, branchId);
    if (isForMatchPage == true) {
      List<WorkerManagement> workerWithoutJob = [];
      for (var job in workManagementList) {
        if (job.jobId == "") {
          workerWithoutJob.add(job);
        }
      }
      workManagementList = workerWithoutJob;
    }
    notifyListeners();
  }

  getApplicantList(String companyId, String branchId) async {
    applicantList = await WorkerManagementApiService().getAllJobApply(companyId, branchId);
    jobTitleList = [JapaneseText.all];
    for (var job in applicantList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();
    notifyListeners();
  }
}
