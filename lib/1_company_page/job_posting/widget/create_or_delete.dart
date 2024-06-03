import 'package:air_job_management/utils/my_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/company/job_posting.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class CreateOrDeleteJobPostingForCompany extends StatelessWidget {
  final Function onCopyPaste;
  final Function onDelete;
  const CreateOrDeleteJobPostingForCompany({super.key, required this.onCopyPaste, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            SizedBox(width: 130, child: ButtonWidget(radius: 25, title: "削除", color: Colors.red, onPress: () => onDelete())),
            AppSize.spaceWidth16,
            Container(
              width: 2,
              color: AppColor.darkGrey,
              height: 39,
            ),
            AppSize.spaceWidth16,
            SizedBox(
                width: 130,
                child: ButtonWidget(
                    radius: 25,
                    title: "新規登録",
                    color: AppColor.primaryColor,
                    onPress: () {
                      provider.onChangeSelectMenu(provider.tabMenu[0]);
                      context.go(MyRoute.companyCreateJobPosting);
                    })),
            AppSize.spaceWidth16,
            SizedBox(
              width: 180,
              child: ButtonWidget(radius: 25, title: "コピーして作成", color: AppColor.primaryColor, onPress: () => onCopyPaste()),
            ),
          ],
        ),
      ),
    );
  }
}
