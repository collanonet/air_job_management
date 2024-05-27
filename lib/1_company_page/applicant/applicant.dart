import 'dart:convert';
import 'dart:html' as html;

import 'package:air_job_management/1_company_page/applicant/widget/applicant_card.dart';
import 'package:air_job_management/1_company_page/applicant/widget/filter.dart';
import 'package:air_job_management/1_company_page/applicant/widget/manual_and_download.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
        await workerManagementProvider.getApplicantList(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
        workerManagementProvider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await workerManagementProvider.getApplicantList(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
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
                ApplicantFilterDataWidgetForCompany(),
                ManualAndDownloadApplicantWidget(
                  onDownload: () => generateApplicantListCSV(),
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
                                  workerManagementProvider.startWorkDate = null;
                                  workerManagementProvider.endWorkDate = null;
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   FontAwesome.arrow_circle_down,
                                  //   color: AppColor.primaryColor,
                                  // ),
                                  // AppSize.spaceWidth5,
                                  Text("応募日", style: normalTextStyle.copyWith(fontSize: 13)),
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
      if (workerManagementProvider.applicantList.isNotEmpty) {
        return ListView.separated(
            itemCount: workerManagementProvider.applicantList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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

  void generateApplicantListCSV() {
    // we will declare the list of headers that we want
    List<String> rowHeader = ["Job Id", "Full Name", "Status", "Job Title", "Rate", "Total Apply Time", "Date"];
    // here we will make a 2D array to handle a row
    List<List<dynamic>> rows = [];
    //First add entire row header into our first row
    rows.add(rowHeader);
    //Now lets add 5 data rows
    for (int i = 0; i < workerManagementProvider.applicantList.length; i++) {
      var job = workerManagementProvider.applicantList[i];
      List<dynamic> dataRow = [];
      dataRow.add(job.uid);
      dataRow.add(job.userName);
      dataRow.add(job.status);
      dataRow.add(job.jobTitle);
      dataRow.add("95%");
      dataRow.add(job.applyCount);
      dataRow.add(DateToAPIHelper.convertDateToString(job.shiftList!.first.date!));
      rows.add(dataRow);
    }
    String url = "";
    if (defaultTargetPlatform == TargetPlatform.macOS && kIsWeb) {
      String csv = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);
      List<int> excelCsvBytes = [0xEF, 0xBB, 0xBF]..addAll(utf8.encode(csv));
      String base64ExcelCsvBytes = base64Encode(excelCsvBytes);
      url = "data:text/plain;charset=utf-8;base64,$base64ExcelCsvBytes";
    } else {
      String csv = const ListToCsvConverter().convert(rows);
      List<int> excelCsvBytes = [0xEF, 0xBB, 0xBF]..addAll(utf8.encode(csv));
      String base64ExcelCsvBytes = base64Encode(excelCsvBytes);
      url = "data:text/plain;charset=utf-8;base64,$base64ExcelCsvBytes";
    }
//It will create anchor to download the file
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'applicant_list_${DateTime.now()}.csv';
//finally add the csv anchor to body
    html.document.body!.children.add(anchor);
// Cause download by calling this function
    anchor.click();
//revoke the object
    html.Url.revokeObjectUrl(url);
  }
}
