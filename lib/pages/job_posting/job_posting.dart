import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/pages/job_posting/widgets/job_posting_card.dart';
import 'package:air_job_management/pages/job_posting/widgets/sign_up_or_delete.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';
import '../company/widgets/filter_company.dart';

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with AfterBuildMixin {
  late JobPostingProvider jobPostingProvider;

  @override
  void initState() {
    Provider.of<JobPostingProvider>(context, listen: false).onInit();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    await jobPostingProvider.getAllJobPost();
    jobPostingProvider.onChangeLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    jobPostingProvider = Provider.of<JobPostingProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CompanyFilterDataWidget(),
            SignUpOrDeleteJobPostWidget(
              context2: context,
            ),
            Expanded(
                child: Container(
              decoration: boxDecoration,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          JapaneseText.listApplication,
                          style: titleStyle,
                        ),
                        IconButton(
                            onPressed: () async {
                              jobPostingProvider.onChangeLoading(true);
                              getData();
                            },
                            icon: const Icon(Icons.refresh))
                      ],
                    ),
                    AppSize.spaceHeight16,
                    //Title
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            JapaneseText.company,
                            style: normalTextStyle.copyWith(fontSize: 13),
                          )),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(JapaneseText.area,
                              style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 2,
                        ),
                        Expanded(
                          child: Text(JapaneseText.industry,
                              style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 2,
                        ),
                        Expanded(
                          child: Text(JapaneseText.numberOfJobOpening,
                              style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 2,
                        ),
                        Expanded(
                          child: Center(
                              child: Text(JapaneseText.correspondenceStatus,
                                  style:
                                      normalTextStyle.copyWith(fontSize: 13))),
                          flex: 2,
                        )
                      ],
                    ),
                    AppSize.spaceHeight16,
                    Expanded(child: buildList())
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  buildList() {
    if (jobPostingProvider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (jobPostingProvider.jobPostingList.isNotEmpty) {
        return ListView.separated(
            itemCount: jobPostingProvider.jobPostingList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    bottom:
                        index + 1 == jobPostingProvider.jobPostingList.length
                            ? 20
                            : 0)),
            itemBuilder: (context, index) {
              JobPosting jobPosting = jobPostingProvider.jobPostingList[index];
              return JobPostingCardWidget(jobPosting: jobPosting);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
