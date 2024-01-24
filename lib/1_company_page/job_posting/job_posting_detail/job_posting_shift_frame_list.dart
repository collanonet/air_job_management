import 'package:air_job_management/1_company_page/home/home.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/matching_worker.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../models/job_posting.dart';
import '../../../providers/company/job_posting.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';
import '../widget/matching_and_copy_button.dart';
import '../widget/shift_frame_card.dart';

class JobPostingShiftFramePageForCompany extends StatefulWidget {
  const JobPostingShiftFramePageForCompany({super.key});

  @override
  State<JobPostingShiftFramePageForCompany> createState() => _JobPostingShiftFramePageForCompanyState();
}

class _JobPostingShiftFramePageForCompanyState extends State<JobPostingShiftFramePageForCompany> with AfterBuildMixin {
  late JobPostingForCompanyProvider provider;
  late AuthProvider authProvider;
  JobPosting? selectJobPosting;

  List<JobPosting> jobPostingList = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                const TitleWidget(title: "シフト枠　一覧"),
                Expanded(child: MatchingAndCopyButtonWidget(
                  onAdd: () {
                    if (selectJobPosting == null) {
                      MessageWidget.show("Please select one job first before matching!");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomePageForCompany(
                                    page: MatchingWorkerPage(
                                      jobPosting: selectJobPosting!,
                                    ),
                                  ))).then((value) {
                        if (value != null && value == true) {
                          onRefreshData();
                        }
                      });
                    }
                  },
                ))
              ],
            ),
            AppSize.spaceHeight16,
            Row(
              children: [
                Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Text(
                          "求人タイトル",
                          style: normalTextStyle.copyWith(fontSize: 13),
                        ),
                      )),
                  flex: 3,
                ),
                Expanded(
                  child: Center(
                    child: Text("稼働期間", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Center(
                    child: Text("募集人数", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text("応募人数", style: normalTextStyle.copyWith(fontSize: 13)),
                  ),
                  flex: 1,
                ),
                SizedBox(
                    width: 100,
                    child: Center(
                      child: Text("掲載状況", style: normalTextStyle.copyWith(fontSize: 13)),
                    ))
              ],
            ),
            AppSize.spaceHeight16,
            buildList()
          ],
        ),
      ),
    );
  }

  buildList() {
    if (isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (jobPostingList.isNotEmpty) {
        return ListView.separated(
            itemCount: jobPostingList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == jobPostingList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              JobPosting jobPosting = jobPostingList[index];
              return ShiftFrameCardWidget(
                jobPosting: jobPosting,
                selectJob: selectJobPosting,
                onClick: () {
                  if (selectJobPosting == null) {
                    setState(() {
                      selectJobPosting = jobPosting;
                    });
                  }
                },
              );
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }

  onRefreshData() async {
    setState(() {
      isLoading = true;
    });
    jobPostingList.clear();
    await provider.getAllJobPost(authProvider.myCompany?.uid ?? "");
    getData();
  }

  getData() {
    for (var job in provider.jobPostingList) {
      if (job.title == provider.jobPosting?.title) {
        jobPostingList.add(job);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }
}
