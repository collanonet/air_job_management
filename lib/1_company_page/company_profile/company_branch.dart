import 'package:air_job_management/1_company_page/company_profile/widget/create_or_edit_branch.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class CompanyBranchPage extends StatefulWidget {
  const CompanyBranchPage({super.key});

  @override
  State<CompanyBranchPage> createState() => _CompanyBranchPageState();
}

class _CompanyBranchPageState extends State<CompanyBranchPage> {
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        padding: const EdgeInsets.all(32),
        decoration: boxDecoration,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleWidget(title: "店舗情報"),
                // IconButton(onPressed: () => JobPostingApiService().updateAllJobPosting(), icon: const Icon(Icons.update)),
                SizedBox(
                  width: 230,
                  child: ButtonWidget(radius: 25, title: "ブランチの作成", color: AppColor.primaryColor, onPress: () => showCreateBranchDialog()),
                ),
              ],
            ),
            AppSize.spaceHeight16,
            if (authProvider.myCompany == null)
              const SizedBox(
                child: Text(""),
              )
            else if (authProvider.myCompany!.branchList!.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: EmptyDataWidget(),
              )
            else
              Expanded(
                child: ListView.builder(
                    itemCount: authProvider.myCompany!.branchList!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var branch = authProvider.myCompany!.branchList![index];
                      Branch? selectedBranch = authProvider.branch;
                      return Container(
                        decoration: BoxDecoration(
                            color: selectedBranch?.createdAt == branch.createdAt ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                            border: Border.all(
                                color: selectedBranch?.createdAt == branch.createdAt ? AppColor.primaryColor : AppColor.darkGrey, width: 1),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TitleWidget(title: "店舗${index + 1}"),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft, child: Text(JapaneseText.name, style: kNormalText.copyWith(fontSize: 12))),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: AppSize.getDeviceHeight(context) * 0.8,
                                        child: PrimaryTextField(
                                          hint: "",
                                          controller: TextEditingController(text: "${branch.name}"),
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(JapaneseText.postalCode, style: kNormalText.copyWith(fontSize: 12))),
                                          AppSize.spaceHeight5,
                                          SizedBox(
                                            width: 150,
                                            child: PrimaryTextField(
                                              hint: "",
                                              controller: TextEditingController(text: "${branch.postalCode}"),
                                              readOnly: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AppSize.spaceWidth16,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(JapaneseText.location, style: kNormalText.copyWith(fontSize: 12))),
                                          AppSize.spaceHeight5,
                                          SizedBox(
                                            width: AppSize.getDeviceHeight(context) * 0.8 - 166,
                                            child: PrimaryTextField(
                                              hint: "",
                                              controller: TextEditingController(text: "${branch.location}"),
                                              readOnly: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(alignment: Alignment.centerLeft, child: Text("TEL", style: kNormalText.copyWith(fontSize: 12))),
                                      AppSize.spaceHeight5,
                                      SizedBox(
                                        width: 200,
                                        child: PrimaryTextField(
                                          hint: "",
                                          controller: TextEditingController(text: "${branch.contactNumber}"),
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 230,
                              child: ButtonWidget(
                                  radius: 25,
                                  title: "編集",
                                  color: AppColor.primaryColor,
                                  onPress: () =>
                                      showDialog(context: context, builder: (context) => CreateOrEditBranchWidget(branch: branch, index: index))
                                          .then((value) {
                                        if (value != null) {}
                                      })),
                            ),
                          ],
                        ),
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }

  showCreateBranchDialog() {
    showDialog(context: context, builder: (context) => const CreateOrEditBranchWidget(branch: null, index: null)).then((value) {
      if (value != null) {}
    });
  }
}
