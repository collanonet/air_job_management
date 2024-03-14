import 'package:air_job_management/2_worker_page/myjob/future_screen.dart';
import 'package:air_job_management/2_worker_page/myjob/past_screen.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:flutter/material.dart';

import 'all_job_apply.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 500),
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0,
          title: TabBar(
            labelColor: AppColor.primaryColor,
            indicatorColor: AppColor.primaryColor,
            indicatorWeight: 3,
            isScrollable: Responsive.isMobile(context) ? true : false,
            labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "Normal"),
            tabs: const [
              Tab(
                text: "応募一覧",
              ),
              Tab(
                text: "仕事の予定",
              ),
              Tab(text: "完了した仕事"),
            ],
            onTap: (value) {},
          ),
        ),
        body: TabBarView(
          children: [
            AppJobApplyPage(
              uid: uid,
            ),
            FutureJob(
              uid: uid,
            ),
            PastJobScreen(
              uid: uid,
            )
          ],
        ),
      ),
    );
  }
}
