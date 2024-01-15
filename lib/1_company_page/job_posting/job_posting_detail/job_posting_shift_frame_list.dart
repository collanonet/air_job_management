import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';
import '../../../utils/style.dart';

class JobPostingShiftFramePageForCompany extends StatefulWidget {
  const JobPostingShiftFramePageForCompany({super.key});

  @override
  State<JobPostingShiftFramePageForCompany> createState() => _JobPostingShiftFramePageForCompanyState();
}

class _JobPostingShiftFramePageForCompanyState extends State<JobPostingShiftFramePageForCompany> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        child: const Center(
          child: Text("We are going to develop this page soon!!!"),
        ),
      ),
    );
  }
}
