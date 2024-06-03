import 'package:air_job_management/1_company_page/job_posting/create_or_edit_job_posting.dart';
import 'package:air_job_management/1_company_page/job_posting/restore_delete_job_posting.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/create_or_delete.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/filter.dart';
import 'package:air_job_management/1_company_page/job_posting/widget/job_posting_card_for_company.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class JobPostingForCompanyPage extends StatefulWidget {
  const JobPostingForCompanyPage({super.key});

  @override
  State<JobPostingForCompanyPage> createState() => _JobPostingForCompanyPageState();
}

class _JobPostingForCompanyPageState extends State<JobPostingForCompanyPage> with AfterBuildMixin {
  late JobPostingForCompanyProvider jobPostingProvider;
  late AuthProvider authProvider;
  JobPosting? selectedJobPosting;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<JobPostingForCompanyProvider>(context, listen: false).onInitForList();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        await jobPostingProvider.getAllJobPost(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
        jobPostingProvider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      await jobPostingProvider.getAllJobPost(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
      jobPostingProvider.onChangeLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    jobPostingProvider = Provider.of<JobPostingForCompanyProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                JobPostingFilterFilterDataWidgetForCompany(
                  onRecycleTap: () {
                    showDialog(context: context, builder: (context) => const RestoreDeleteJobPostingPage()).then((value) {
                      if (value == true) {
                        jobPostingProvider.onChangeLoading(true);
                        getData();
                      }
                    });
                  },
                ),
                CreateOrDeleteJobPostingForCompany(
                  onDelete: () {
                    if (selectedJobPosting == null) {
                      toastMessageError("最初に求人情報を選択してください。", context);
                    } else {
                      CustomDialog.confirmDelete(
                          context: context,
                          onDelete: () async {
                            Navigator.pop(context);
                            await JobPostingApiService().deleteJobPosting(selectedJobPosting!.uid!);
                            getData();
                          });
                    }
                  },
                  onCopyPaste: () {
                    if (selectedJobPosting == null) {
                      toastMessageError("最初に求人情報を選択してください。", context);
                    } else {
                      showCopyAndPaste();
                    }
                  },
                ),
                Container(
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
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
                                  selectedJobPosting = null;
                                  jobPostingProvider.onChangeLoading(true);
                                  jobPostingProvider.onInitForList();
                                  getData();
                                },
                                icon: const Icon(Icons.refresh))
                          ],
                        ),
                        // AppSize.spaceHeight16,
                        //Title
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
                              flex: 4,
                            ),
                            Expanded(
                              child: Center(
                                child: Text("稼働日開始 ~ 稼働日終了", style: normalTextStyle.copyWith(fontSize: 13)),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Center(
                                child: Text("職種", style: normalTextStyle.copyWith(fontSize: 13)),
                              ),
                              flex: 2,
                            ),
                            SizedBox(
                              width: 200,
                              child: Text("", style: normalTextStyle.copyWith(fontSize: 13)),
                            ),
                          ],
                        ),
                        AppSize.spaceHeight16,
                        buildList()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCopyAndPaste() {
    showDialog(
        context: context,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceHeight(context) * 0.1, vertical: 32),
            child: CreateOrEditJobPostingPageForCompany(
              jobPosting: selectedJobPosting!.uid,
              isCopyPaste: true,
            ),
          );
        }).then((value) {
      if (value == true) {
        getData();
      }
    });
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
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == jobPostingProvider.jobPostingList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              JobPosting jobPosting = jobPostingProvider.jobPostingList[index];
              return JobPostingCardForCompanyWidget(
                jobPosting: jobPosting,
                selectedJobPosting: selectedJobPosting,
                onClick: () {
                  jobPostingProvider.onChangeSelectMenu(jobPostingProvider.tabMenu[0]);
                  setState(() {
                    selectedJobPosting = jobPosting;
                  });
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
}
