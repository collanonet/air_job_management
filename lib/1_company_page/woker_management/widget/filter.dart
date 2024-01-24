import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_dropdown_string.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkerManagementFilterDataWidgetForCompany extends StatelessWidget {
  final bool? isHaveClose;
  const WorkerManagementFilterDataWidgetForCompany({Key? key, this.isHaveClose = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkerManagementProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ワーカー検索",
                style: titleStyle,
              ),
              AppSize.spaceHeight16,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "連携状態",
                        style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                      ),
                      AppSize.spaceHeight5,
                      CustomDropDownWidget(
                          radius: 5,
                          width: 180,
                          selectItem: provider.selectedCooperationStatus,
                          list: provider.cooperationStatus,
                          onChange: (v) => provider.onChangeSelectCooperationStatus(v))
                    ],
                  ),
                  AppSize.spaceWidth32,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "氏名（漢字）",
                        style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                      ),
                      AppSize.spaceHeight5,
                      SizedBox(
                        width: AppSize.getDeviceWidth(context) * 0.35,
                        child: PrimaryTextField(
                          controller: provider.searchController,
                          hint: "タイトルを入れます",
                          isRequired: false,
                          onChange: (val) async {
                            await Future.delayed(const Duration(milliseconds: 500));
                            provider.filterWorkerManagement(val);
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          if (isHaveClose == true) IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)) else const SizedBox()
        ],
      ),
    );
  }
}
