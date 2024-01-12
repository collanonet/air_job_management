import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';

class JobPostingShiftPageForCompany extends StatefulWidget {
  const JobPostingShiftPageForCompany({super.key});

  @override
  State<JobPostingShiftPageForCompany> createState() => _JobPostingShiftPageForCompanyState();
}

class _JobPostingShiftPageForCompanyState extends State<JobPostingShiftPageForCompany> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        child: Center(
          child: Text("JobPostingInformationPageForCompany"),
        ),
      ),
    );
  }
}
