import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/company/job_posting.dart';

class JobPostingFilterFilterDataWidgetForCompany extends StatelessWidget {
  final Function onRecycleTap;
  JobPostingFilterFilterDataWidgetForCompany({Key? key, required this.onRecycleTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<JobPostingForCompanyProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "求人ひな形　検索",
            style: titleStyle,
          ),
          AppSize.spaceHeight8,
          Text(
            "求人タイトル",
            style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
          ),
          AppSize.spaceHeight5,
          Row(
            children: [
              SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.5,
                child: PrimaryTextField(
                  controller: provider.searchController,
                  hint: "タイトルを入れます",
                  isRequired: false,
                  onChange: (v) {
                    provider.filterData(auth.myCompany?.uid ?? "", auth.branch?.id ?? "");
                  },
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "求人情報を復元する",
                    style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight5,
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor.withOpacity(0.2)),
                    child: InkWell(
                        onTap: () => onRecycleTap(),
                        child: Icon(
                          Icons.recycling,
                          color: AppColor.primaryColor,
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
