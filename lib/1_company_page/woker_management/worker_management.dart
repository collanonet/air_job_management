import 'package:air_job_management/1_company_page/woker_management/widget/filter.dart';
import 'package:air_job_management/1_company_page/woker_management/widget/job_card.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
import '../../widgets/custom_button.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class WorkerManagementPage extends StatefulWidget {
  const WorkerManagementPage({super.key});

  @override
  State<WorkerManagementPage> createState() => _WorkerManagementPageState();
}

class _WorkerManagementPageState extends State<WorkerManagementPage> with AfterBuildMixin {
  late WorkerManagementProvider workerManagementProvider;
  late AuthProvider authProvider;
  ScrollController scrollController = ScrollController();

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
        await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
        workerManagementProvider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
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
        child: Scrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const WorkerManagementFilterDataWidgetForCompany(),
                AppSize.spaceHeight8,
                Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        width: 130,
                        child: ButtonWidget(
                            radius: 25, title: "新規登録", color: AppColor.primaryColor, onPress: () => context.go(MyRoute.companyCreateWorkerMgt)))),
                AppSize.spaceHeight8,
                Container(
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ワーカー　一覧",
                              style: titleStyle,
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
                        AppSize.spaceHeight16,
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
                              child: Center(
                                child: Text("年齢/性別", style: normalTextStyle.copyWith(fontSize: 13)),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Center(
                                child: Text("電話番号", style: normalTextStyle.copyWith(fontSize: 13)),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesome.arrow_circle_down,
                                    color: AppColor.primaryColor,
                                  ),
                                  AppSize.spaceWidth5,
                                  Text("Good率", style: normalTextStyle.copyWith(fontSize: 13)),
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesome.arrow_circle_down,
                                    color: AppColor.primaryColor,
                                  ),
                                  AppSize.spaceWidth5,
                                  Text("最終稼働日", style: normalTextStyle.copyWith(fontSize: 13)),
                                ],
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesome.arrow_circle_down,
                                    color: AppColor.primaryColor,
                                  ),
                                  AppSize.spaceWidth5,
                                  Text("稼働回数", style: normalTextStyle.copyWith(fontSize: 13)),
                                ],
                              ),
                              flex: 1,
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

  buildList() {
    if (workerManagementProvider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (workerManagementProvider.workManagementList.isNotEmpty) {
        return ListView.separated(
            itemCount: workerManagementProvider.workManagementList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == workerManagementProvider.workManagementList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              WorkerManagement job = workerManagementProvider.workManagementList[index];
              return JobApplyCardWidget(job: job);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
