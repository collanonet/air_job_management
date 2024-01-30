import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/models/notification.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/material.dart';

class DashboardForCompanyProvider with ChangeNotifier {
  bool isLoading = false;
  List<JobPosting> jobPostingList = [];
  List<WorkerManagement> applicantList = [];
  List<NotificationModel> notificationList = [];
  String workerCount = "";

  onInit(String companyId) async {
    jobPostingList = [];
    applicantList = [];
    notificationList = [];
    await getData(companyId);
  }

  set setLoading(bool isLoading) {
    this.isLoading = isLoading;
  }

  getData(String companyId) async {
    var data = await Future.wait([
      JobPostingApiService().getAllJobPostByCompany(companyId),
      WorkerManagementApiService().getAllJobApply(companyId),
      JobPostingApiService().getAllNotification(companyId),
    ]);
    jobPostingList = data[0] as List<JobPosting>;
    applicantList = data[1] as List<WorkerManagement>;
    notificationList = data[2] as List<NotificationModel>;
    int count = 0;
    for (var worker in applicantList) {
      if (worker.status == JapaneseText.hired) {
        count++;
      }
    }
    workerCount = count.toString();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
}
