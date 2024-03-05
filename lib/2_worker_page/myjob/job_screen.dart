import 'package:air_job_management/2_worker_page/myjob/future_screen.dart';
import 'package:air_job_management/2_worker_page/myjob/past_screen.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:flutter/material.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 500),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: TabBar(
            labelColor: AppColor.primaryColor,
            indicatorColor: AppColor.primaryColor,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: "今後の予定",
              ),
              Tab(text: "完了した仕事"),
            ],
            onTap: (value) {},
          ),
        ),
        body: TabBarView(
          children: [
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
