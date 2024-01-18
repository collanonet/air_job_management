import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';

class ApplicationHistoryPage extends StatefulWidget {
  final MyUser? myUser;
  const ApplicationHistoryPage({super.key, required this.myUser});

  @override
  State<ApplicationHistoryPage> createState() => _ApplicationHistoryPageState();
}

class _ApplicationHistoryPageState extends State<ApplicationHistoryPage> with AfterBuildMixin {
  List<WorkerManagement> jobList = [];
  bool isLoading = true;
  late AuthProvider authProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Expanded(
        child: Column(
      children: [
        AppSize.spaceHeight16,
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
                    Text(
                      "応募求人　一覧",
                      style: titleStyle,
                    ),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
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
                      child: Center(
                        child: Text("求人タイトル", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("応募稼働日", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text("状態", style: normalTextStyle.copyWith(fontSize: 13)),
                      ),
                      flex: 3,
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
    ));
  }

  buildList() {
    if (isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (jobList.isNotEmpty) {
        return ListView.separated(
            itemCount: jobList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == jobList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              WorkerManagement job = jobList[index];
              return Container(
                height: 110,
                width: AppSize.getDeviceWidth(context),
                padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
                margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(width: 1, color: AppColor.primaryColor)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                            child: Center(
                              child: Icon(
                                Icons.folder_outlined,
                                color: AppColor.whiteColor,
                                size: 30,
                              ),
                            ),
                          ),
                          AppSize.spaceWidth16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  job.jobTitle ?? "",
                                  style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                                  overflow: TextOverflow.fade,
                                ),
                                // Text(
                                //   job.jobLocation ?? "",
                                //   style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                                //   overflow: TextOverflow.fade,
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Center(
                          child: Text(
                            "${DateToAPIHelper.convertDateToString(job.shiftList!.first.date!)} ~ ${DateToAPIHelper.convertDateToString(job.shiftList!.last.date!)}",
                            style: kNormalText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ButtonWidget(
                              radius: 25,
                              color: job.status == "approved" ? AppColor.primaryColor : AppColor.whiteColor,
                              title: "確定する",
                              onPress: () => updateJobStatus(job, "確定する"),
                            ),
                          ),
                          AppSize.spaceWidth32,
                          SizedBox(
                            width: 150,
                            child: ButtonWidget(
                              radius: 25,
                              color: job.status == "canceled" ? AppColor.primaryColor : AppColor.whiteColor,
                              title: "キャンセル",
                              onPress: () => updateJobStatus(job, "キャンセル"),
                            ),
                          )
                        ],
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              );
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    // TODO: implement afterBuild
    getData();
  }

  getData() async {
    jobList = await WorkerManagementApiService().getAllJobApplyForAUSer(authProvider.myCompany?.uid ?? "", widget.myUser?.uid ?? "");
    setState(() {
      isLoading = false;
    });
  }

  updateJobStatus(WorkerManagement job, String action) {
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await WorkerManagementApiService().updateJobStatus(job.uid!, action == "確定する" ? "approved" : "canceled");
          if (isSuccess) {
            jobList = await WorkerManagementApiService().getAllJobApplyForAUSer(authProvider.myCompany?.uid ?? "", widget.myUser?.uid ?? "");
            setState(() {
              isLoading = false;
            });
            MessageWidget.show(JapaneseText.successUpdate);
          } else {
            setState(() {
              isLoading = false;
            });
            MessageWidget.show(JapaneseText.failUpdate);
          }
        },
        title: "本当に確定しますか？",
        titleText: action);
  }
}
