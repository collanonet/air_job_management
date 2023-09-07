import 'package:air_job_management/pages/job_seeker/widget/create_seeker_or_download.dart';
import 'package:air_job_management/pages/job_seeker/widget/filter_data.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/job_seeker.dart';

class JobSeekerPage extends StatefulWidget {
  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  State<JobSeekerPage> createState() => _JobSeekerPageState();
}

class _JobSeekerPageState extends State<JobSeekerPage> {
  late JobSeekerProvider jobSeekerProvider;

  @override
  void initState() {
    Provider.of<JobSeekerProvider>(context, listen: false).onInit();
    super.initState();
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
            JobSeekerFilterDataWidget(),
            CreateSeekerOrDownloadListWidget(
              context2: context,
            ),
            Expanded(
                child: Container(
              decoration: boxDecoration,
            ))
          ],
        ),
      ),
    );
  }
}
