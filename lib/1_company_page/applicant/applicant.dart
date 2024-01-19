import 'package:air_job_management/1_company_page/applicant/widget/applicant_card.dart';
import 'package:air_job_management/1_company_page/applicant/widget/filter.dart';
import 'package:air_job_management/1_company_page/applicant/widget/manual_and_download.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../providers/auth.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class ApplicantListPage extends StatefulWidget {
  const ApplicantListPage({super.key});

  @override
  State<ApplicantListPage> createState() => _ApplicantListPageState();
}

class _ApplicantListPageState extends State<ApplicantListPage> with AfterBuildMixin {
  late WorkerManagementProvider workerManagementProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    Provider.of<WorkerManagementProvider>(context, listen: false).onInitForList();
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
        workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
        await workerManagementProvider.getApplicantList(authProvider.myCompany?.uid ?? "");
        workerManagementProvider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await workerManagementProvider.getApplicantList(authProvider.myCompany?.uid ?? "");
      workerManagementProvider.onChangeLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    workerManagementProvider = Provider.of<WorkerManagementProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ApplicantFilterDataWidgetForCompany(),
            const ManualAndDownloadApplicantWidget(),
            Expanded(
                child: Container(
              decoration: boxDecoration,
              child: Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "応募者一覧",
                              style: titleStyle,
                            ),
                            AppSize.spaceWidth32,
                            Text(
                              "合計${workerManagementProvider.applicantList.length}名",
                              style: kNormalText.copyWith(fontSize: 12),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              workerManagementProvider.onChangeLoading(true);
                              workerManagementProvider.onInitForList();
                              getData();
                            },
                            icon: const Icon(Icons.refresh))
                      ],
                    ),
                    AppSize.spaceHeight30,
                    //Title
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80),
                                child: Text(
                                  "氏名（漢字）",
                                  style: normalTextStyle.copyWith(fontSize: 13),
                                ),
                              )),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: Center(
                              child: Text("状態", style: normalTextStyle.copyWith(fontSize: 13)),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Center(
                            child: Text("求人タイトル", style: normalTextStyle.copyWith(fontSize: 13)),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Center(
                            child: Text("Good率", style: normalTextStyle.copyWith(fontSize: 13)),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Center(
                            child: Text("稼働回数", style: normalTextStyle.copyWith(fontSize: 13)),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Center(
                            child: Text("最終稼働日", style: normalTextStyle.copyWith(fontSize: 13)),
                          ),
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
    if (workerManagementProvider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (workerManagementProvider.applicantList.isNotEmpty) {
        return ListView.separated(
            itemCount: workerManagementProvider.applicantList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == workerManagementProvider.applicantList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              WorkerManagement job = workerManagementProvider.applicantList[index];
              return ApplicantCardWidget(job: job);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
