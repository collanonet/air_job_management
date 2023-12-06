import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/worker_page/myjob/future_screen.dart';
import 'package:air_job_management/worker_page/myjob/past_screen.dart';
import 'package:flutter/material.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

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
            labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: "Future Job",
              ),
              Tab(text: "Past Job"),
            ],
            onTap: (value) {},
          ),
        ),
        body: const TabBarView(
          children: [FutureJob(), PastJobScreen()],
        ),
      ),
    );
  }
}
