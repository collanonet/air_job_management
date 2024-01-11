import 'package:air_job_management/1_company_page/job_posting/widget/create_or_delete.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/filter.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/job_posting_card_for_company.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class JobPostingForCompanyPage extends StatefulWidget {
  const JobPostingForCompanyPage({super.key});

  @override
  State<JobPostingForCompanyPage> createState() =>
      _JobPostingForCompanyPageState();
}

class _JobPostingForCompanyPageState extends State<JobPostingForCompanyPage>
    with AfterBuildMixin {
  late JobPostingForCompanyProvider jobPostingProvider;

  @override
  void initState() {
    Provider.of<JobPostingForCompanyProvider>(context, listen: false)
        .onInitForList();
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
    jobPostingProvider = Provider.of<JobPostingForCompanyProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            JobPostingFilterFilterDataWidgetForCompany(),
            const CreateOrDeleteJobPostingForCompany(),
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
                          "求人ひな形　一覧",
                          style: titleStyle,
                        ),
                        IconButton(
                            onPressed: () async {
                              jobPostingProvider.onChangeLoading(true);
                              jobPostingProvider.onInitForList();
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
                            "求人タイトル",
                            style: normalTextStyle.copyWith(fontSize: 13),
                          )),
                          flex: 4,
                        ),
                        Expanded(
                          child: Center(
                            child: Text("職種",
                                style: normalTextStyle.copyWith(fontSize: 13)),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Text("",
                              style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 2,
                        ),
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
              return JobPostingCardForCompanyWidget(jobPosting: jobPosting);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
