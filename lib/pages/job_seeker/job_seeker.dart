import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/job_seeker/widget/create_seeker_or_download.dart';
import 'package:air_job_management/pages/job_seeker/widget/filter_data.dart';
import 'package:air_job_management/pages/job_seeker/widget/job_seeker_card.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/job_seeker.dart';
import '../../utils/japanese_text.dart';

class JobSeekerPage extends StatefulWidget {
  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  State<JobSeekerPage> createState() => _JobSeekerPageState();
}

class _JobSeekerPageState extends State<JobSeekerPage> with AfterBuildMixin {
  late JobSeekerProvider jobSeekerProvider;

  @override
  void initState() {
    Provider.of<JobSeekerProvider>(context, listen: false).onInit();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    await jobSeekerProvider.getAllUser();
    jobSeekerProvider.onChangeLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    jobSeekerProvider = Provider.of<JobSeekerProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const JobSeekerFilterDataWidget(),
            CreateSeekerOrDownloadListWidget(
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
                              jobSeekerProvider.onChangeLoading(true);
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
                            JapaneseText.application,
                            style: normalTextStyle.copyWith(fontSize: 13),
                          )),
                          flex: 2,
                        ),
                        Expanded(
                          child: Text(JapaneseText.jobDetail, style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(JapaneseText.note, style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 3,
                        ),
                        Expanded(
                          child: Center(child: Text(JapaneseText.message, style: normalTextStyle.copyWith(fontSize: 13))),
                          flex: 1,
                        ),
                        Expanded(
                          child: Center(child: Text(JapaneseText.correspondenceStatus, style: normalTextStyle.copyWith(fontSize: 13))),
                          flex: 1,
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
    if (jobSeekerProvider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (jobSeekerProvider.myUserList.isNotEmpty) {
        return ListView.separated(
            itemCount: jobSeekerProvider.myUserList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == jobSeekerProvider.myUserList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              MyUser user = jobSeekerProvider.myUserList[index];
              return JobSeekerCardWidget(user: user);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
