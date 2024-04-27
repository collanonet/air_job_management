import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/job_posting.dart';
import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class RestoreDeleteJobPostingPage extends StatefulWidget {
  const RestoreDeleteJobPostingPage({super.key});

  @override
  State<RestoreDeleteJobPostingPage> createState() => _RestoreDeleteJobPostingPageState();
}

class _RestoreDeleteJobPostingPageState extends State<RestoreDeleteJobPostingPage> with AfterBuildMixin {
  List<JobPosting> jobPostingList = [];
  bool isLoading = true;
  bool overlayLoading = false;
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: overlayLoading,
      child: AlertDialog(
        title: const TitleWidget(title: "求人情報を復元する"),
        content: SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.9,
          height: AppSize.getDeviceHeight(context) * 0.7,
          child: buildList(),
        ),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
                width: 200,
                child: ButtonWidget(
                  radius: 25,
                  color: AppColor.whiteColor,
                  title: "キャンセル",
                  onPress: () => Navigator.pop(context),
                )),
            AppSize.spaceWidth16,
            SizedBox(
              width: 200,
              child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => onRestore()),
            )
          ])
        ],
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
              return Container(
                width: AppSize.getDeviceWidth(context),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 4, left: 0, right: 0),
                decoration: BoxDecoration(
                    color: Colors.transparent, borderRadius: BorderRadius.circular(16), border: Border.all(width: 2, color: AppColor.primaryColor)),
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
                                Icons.folder_rounded,
                                color: AppColor.whiteColor,
                                size: 22,
                              ),
                            ),
                          ),
                          AppSize.spaceWidth16,
                          Expanded(
                            child: Text(
                              jobPosting.title ?? "",
                              style: kTitleText.copyWith(color: AppColor.primaryColor, fontSize: 16),
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          (jobPosting.majorOccupation ?? "") + "\n${jobPosting.startDate}~${jobPosting.endDate}",
                          style: kTitleText.copyWith(color: AppColor.darkGrey, fontSize: 16),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      flex: 2,
                    ),
                    Container(
                        width: 190,
                        height: 36,
                        child: Checkbox(
                          value: jobPosting.isSelect,
                          activeColor: AppColor.primaryColor,
                          onChanged: (v) {
                            setState(() {
                              jobPosting.isSelect = v;
                            });
                          },
                        )),
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

  onRestore() async {
    List<String> selectedJobId = [];
    for (JobPosting job in jobPostingList) {
      if (job.isSelect == true) {
        selectedJobId.add(job.uid!);
      }
    }
    if (selectedJobId.isNotEmpty) {
      bool isSuccess = await JobPostingApiService().restorePosting(selectedJobId);
      if (isSuccess) {
        toastMessageSuccess(JapaneseText.successUpdate, context);
        Navigator.pop(context, true);
      } else {
        toastMessageError(JapaneseText.failUpdate, context);
      }
    } else {
      toastMessageError("復元するアイテムを少なくとも 1 つ選択してください。", context);
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    Company? company = authProvider.myCompany;
    Branch? branch = authProvider.branch;
    jobPostingList = await JobPostingApiService().getAllDeletedJobPostByCompany(company?.uid ?? "", branch?.id ?? "");
    setState(() {
      isLoading = false;
    });
  }
}
