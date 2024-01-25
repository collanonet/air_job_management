import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../helper/date_to_api.dart';
import '../../../models/company/worker_management.dart';
import '../../../providers/auth.dart';
import '../../../providers/company/worker_management.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';
import '../../woker_management/widget/filter.dart';
import '../../woker_management/widget/job_card.dart';

class MatchingWorkerPage extends StatefulWidget {
  final JobPosting jobPosting;
  final ShiftFrame shiftFrame;
  const MatchingWorkerPage({super.key, required this.jobPosting, required this.shiftFrame});

  @override
  State<MatchingWorkerPage> createState() => _MatchingWorkerPageState();
}

class _MatchingWorkerPageState extends State<MatchingWorkerPage> with AfterBuildMixin {
  late WorkerManagementProvider workerManagementProvider;
  late AuthProvider authProvider;
  bool isLoading = false;

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
    workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
    await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", isForMatchPage: true);
    workerManagementProvider.onChangeLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    workerManagementProvider = Provider.of<WorkerManagementProvider>(context);
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const WorkerManagementFilterDataWidgetForCompany(
                isHaveClose: true,
              ),
              AppSize.spaceHeight16,
              Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: 180, child: ButtonWidget(radius: 25, title: "マッチングする", color: AppColor.primaryColor, onPress: () => onMatchUser()))),
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
                            child: Center(
                              child: Text("Good率", style: normalTextStyle.copyWith(fontSize: 13)),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Center(
                              child: Text("最終稼働日", style: normalTextStyle.copyWith(fontSize: 13)),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Center(
                              child: Text("稼働回数", style: normalTextStyle.copyWith(fontSize: 13)),
                            ),
                            flex: 1,
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
      ),
    );
  }

  onMatchUser() async {
    setState(() {
      isLoading = true;
    });
    for (var job in workerManagementProvider.workManagementList) {
      if (job.isSelect == true) {
        job.jobTitle = widget.jobPosting.title;
        job.jobId = widget.jobPosting.uid;
        job.jobLocation = widget.jobPosting.jobLocation;
        DateTime startDate = DateToAPIHelper.fromApiToLocal(widget.shiftFrame.startDate!);
        DateTime endDate = DateToAPIHelper.fromApiToLocal(widget.shiftFrame.endDate!);
        List<DateTime> dateList = [DateToAPIHelper.timeToDateTime(widget.shiftFrame.startWorkTime!, dateTime: startDate)];
        for (var i = 1; i <= (startDate.difference(endDate).inDays * -1); ++i) {
          dateList.add(DateTime(startDate.year, startDate.month, startDate.day + i));
        }
        List<ShiftModel> shiftList = [];
        for (var date in dateList) {
          if (date.isAfter(DateTime.now())) {
            shiftList.add(ShiftModel(
                startBreakTime: widget.shiftFrame.startBreakTime!,
                date: date,
                endBreakTime: widget.shiftFrame.endBreakTime!,
                endWorkTime: widget.shiftFrame.endWorkTime!,
                price: widget.shiftFrame.hourlyWag!,
                startWorkTime: widget.shiftFrame.startWorkTime!));
          }
        }
        job.shiftList = shiftList.map((e) => e).toList();
        await WorkerManagementApiService().updateJobId(job);
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, true);
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
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == workerManagementProvider.workManagementList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              WorkerManagement job = workerManagementProvider.workManagementList[index];
              return JobApplyCardWidget(
                job: job,
                isFromMatching: true,
                index: index,
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
