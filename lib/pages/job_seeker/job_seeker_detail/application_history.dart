import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/pages/job_posting/widgets/job_posting_card.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../../../api/user_api.dart';
import '../../../models/job_posting.dart';

class ApplicationHistoryPage extends StatefulWidget {
  final String id;
  const ApplicationHistoryPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ApplicationHistoryPage> createState() => _ApplicationHistoryPageState();
}

class _ApplicationHistoryPageState extends State<ApplicationHistoryPage> with AfterBuildMixin {
  ValueNotifier loading = ValueNotifier<bool>(true);
  List<JobApply> jobApply = [];
  List<JobPosting> jobList = [];

  @override
  void initState() {
    loading.value = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading.value) {
      return Center(child: LoadingWidget(AppColor.primaryColor));
    } else if (jobList.isEmpty) {
      return const Center(child: EmptyDataWidget());
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: jobList.length,
          itemBuilder: (context, index) {
            var jobPosting = jobList[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: JobPostingCardWidget(jobPosting: jobPosting, fromSeekerPage: true),
            );
          });
    }
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    jobApply = await UserApiServices().getJobByWorkerId(widget.id);
    var data = await Future.wait([...jobApply.map((e) => JobPostingApiService().getAJobPosting(e.jobId!))]);
    jobList = data.map((e) => e!).toList();
    loading.value = false;
    setState(() {});
  }
}
