import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../api/worker_api/search_api.dart';
import '../../../models/worker_model/shift.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';
import '../../job_posting/create_or_edit_job_posting.dart';

class AllShiftApplicantPage extends StatefulWidget {
  final String id;
  final MyUser myUser;
  final String searchJobId;
  const AllShiftApplicantPage({super.key, required this.id, required this.myUser, required this.searchJobId});

  @override
  State<AllShiftApplicantPage> createState() => _AllShiftApplicantPageState();
}

class _AllShiftApplicantPageState extends State<AllShiftApplicantPage> with AfterBuildMixin {
  WorkerManagement? workerManagement;
  bool isLoading = true;
  late AuthProvider authProvider;
  List<ShiftModel> shiftList = [];

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
            padding: const EdgeInsets.only(left: 32, right: 32, top: 4),
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
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 75),
                              child: Text(
                                "求人タイトルを選んでまとめて",
                                style: normalTextStyle.copyWith(fontSize: 13),
                              ),
                            ),
                            AppSize.spaceHeight8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: ButtonWidget(
                                    radius: 25,
                                    color: AppColor.whiteColor,
                                    title: "確定する",
                                    onPress: () {},
                                  ),
                                ),
                                AppSize.spaceWidth8,
                                SizedBox(
                                  width: 150,
                                  child: ButtonWidget(
                                    radius: 25,
                                    color: AppColor.whiteColor,
                                    title: "不承認にする",
                                    onPress: () {},
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        AppSize.spaceWidth16,
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              getData();
                            },
                            icon: const Icon(Icons.refresh)),
                      ],
                    )
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
      if (shiftList.isNotEmpty) {
        return ListView.separated(
            itemCount: shiftList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == shiftList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              ShiftModel shift = shiftList[index];
              return Container(
                // height: 110,
                width: AppSize.getDeviceWidth(context),
                padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 16),
                margin: const EdgeInsets.only(bottom: 4, left: 0, right: 0),
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
                                InkWell(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: CreateOrEditJobPostingPageForCompany(
                                              isView: true,
                                              jobPosting: shift.myJob!.uid,
                                            ),
                                          )),
                                  child: Text(
                                    shift.myJob?.title ?? "",
                                    style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                                    overflow: TextOverflow.fade,
                                  ),
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
                            "${DateToAPIHelper.convertDateToString(shift.date!)}  ${shift.startWorkTime}〜${shift.endWorkTime}",
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
                              color: shift.status == "completed"
                                  ? AppColor.bgPageColor
                                  : shift.status == "approved"
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                              title: "確定する",
                              onPress: () {
                                if (shift.status != "completed") {
                                  updateJobStatus(index, shift, "確定する", widget.myUser!);
                                } else {
                                  toastMessageError("この仕事は完了しました。", context);
                                }
                              },
                            ),
                          ),
                          AppSize.spaceWidth32,
                          SizedBox(
                            width: 150,
                            child: ButtonWidget(
                              radius: 25,
                              color: shift.status == "completed"
                                  ? AppColor.bgPageColor
                                  : shift.status == "rejected"
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                              title: "不承認にする",
                              onPress: () {
                                if (shift.status != "completed") {
                                  updateJobStatus(index, shift, "キャンセル", widget.myUser!);
                                } else {
                                  toastMessageError("この仕事は完了しました。", context);
                                }
                              },
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
    shiftList = [];
    workerManagement = await WorkerManagementApiService().getAJob(widget.id);
    var job = await SearchJobApi().getASearchJob(widget.searchJobId);
    shiftList = workerManagement?.shiftList ?? [];
    for (var shift in shiftList) {
      shift.myJob = job;
    }
    shiftList.sort((a, b) => b.date!.compareTo(a.date!));
    setState(() {
      isLoading = false;
    });
  }

  updateJobStatus(int index, ShiftModel shiftModel, String action, MyUser myUser) {
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          if (action == "確定する") {
            shiftModel.status = "approved";
          } else {
            shiftModel.status = "rejected";
          }
          shiftList[index] = shiftModel;
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await WorkerManagementApiService().updateShiftStatus(
              branch: authProvider.branch, shiftList, widget.id, shiftModel: shiftModel, company: authProvider.myCompany!, myUser: myUser);
          if (isSuccess) {
            await getData();
            toastMessageSuccess(JapaneseText.successUpdate, context);
          } else {
            setState(() {
              isLoading = false;
            });
            toastMessageSuccess(JapaneseText.failUpdate, context);
          }
        },
        title: "本当に確定しますか？",
        titleText: action);
  }
}
