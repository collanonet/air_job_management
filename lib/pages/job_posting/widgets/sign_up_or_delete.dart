import 'package:air_job_management/pages/company/widgets/delete_dialog.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/company.dart';

class SignUpOrDeleteJobPostWidget extends StatelessWidget {
  final BuildContext context2;
  const SignUpOrDeleteJobPostWidget({super.key, required this.context2});

  @override
  Widget build(BuildContext context) {
    var companyProvider = Provider.of<CompanyProvider>(context2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            ButtonWidget(
                title: JapaneseText.signUp,
                color: AppColor.primaryColor,
                onPress: () {
                  context2.go(MyRoute.createJob);
                }),
            AppSize.spaceWidth16,
            ButtonWidget(
                title: JapaneseText.delete,
                color: AppColor.whiteColor,
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => DeleteCompanyDialogWidget(
                          companyList: companyProvider.companyList,
                          onRefresh: () {
                            companyProvider.getAllCompany(isNotify: true);
                          }));
                }),
          ],
        ),
      ),
    );
  }
}
