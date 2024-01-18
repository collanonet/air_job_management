import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/foundation.dart';

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

  onChangeStartDate(DateTime? startDate) {
    startWorkDate = startDate;
    notifyListeners();
  }

  onChangeEndDate(DateTime? endDate) {
    endWorkDate = endDate;
    notifyListeners();
  }

  set setJob(WorkerManagement job) {
    selectedJob = job;
  }

  onInitForList() {
    selectedJobStatus = JapaneseText.all;
    selectedCooperationStatus = JapaneseText.all;
    selectedJobTitle = JapaneseText.all;
    isLoading = true;
    selectedMenu = "基本情報";
    selectedJob = null;
  }

  onChangeLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onChangeJobStatus(String? val) {
    selectedJobStatus = val;
    notifyListeners();
  }

  onChangeTitle(String? val) {
    selectedJobTitle = val;
    notifyListeners();
  }

  onChangeSelectCooperationStatus(String? val) {
    selectedCooperationStatus = val;
    notifyListeners();
  }

  getWorkerApply(String companyId) async {
    workManagementList = await WorkerManagementApiService().getAllJobApply(companyId);
    // for (var item in list) {
    //   if (item.status == JapaneseText.hired) {
    //     workManagementList.add(item);
    //   }
    // }
    notifyListeners();
  }

  getApplicantList(String companyId) async {
    jobTitleList = [JapaneseText.all];
    applicantList = await WorkerManagementApiService().getAllJobApply(companyId);
    for (var job in applicantList) {
      jobTitleList.add(job.jobTitle.toString());
    }
    jobTitleList = jobTitleList.toSet().toList();
    notifyListeners();
  }
}
