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

  String selectedMenu = "基本情報";

  List<String> tabMenu = ["基本情報", "チャット", "応募履歴"];

  onChangeSelectMenu(String menu) {
    selectedMenu = menu;
    notifyListeners();
  }

  set setJob(WorkerManagement job) {
    selectedJob = job;
  }

  onInitForList() {
    selectedCooperationStatus = JapaneseText.all;
    isLoading = true;
    selectedMenu = "基本情報";
    selectedJob = null;
  }

  onChangeLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onChangeSelectCooperationStatus(String? val) {
    selectedCooperationStatus = val;
    notifyListeners();
  }

  getWorkerApply(String companyId) async {
    workManagementList = await WorkerManagementApiService().getAllJobApply(companyId);
    notifyListeners();
  }
}
