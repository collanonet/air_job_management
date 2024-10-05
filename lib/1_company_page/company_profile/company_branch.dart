import 'package:air_job_management/1_company_page/company_profile/widget/create_or_edit_branch.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/company.dart';
import '../../const/const.dart';
import '../../utils/app_color.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class CompanyBranchPage extends StatefulWidget {
  final bool isFromMain;

  const CompanyBranchPage({super.key, this.isFromMain = false});

  @override
  State<CompanyBranchPage> createState() => _CompanyBranchPageState();
}

class _CompanyBranchPageState extends State<CompanyBranchPage> {
  late AuthProvider authProvider;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    if (widget.isFromMain) {
      return CustomLoadingOverlay(
        isLoading: isLoading,
        child: Container(
          width: AppSize.getDeviceWidth(context),
          margin: const EdgeInsets.symmetric(vertical: 32),
          padding: const EdgeInsets.all(32),
          decoration: boxDecoration,
          child: SingleChildScrollView(
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
                      child: ButtonWidget(
                          radius: 25,
                          title: "ブランチの作成",
                          color: AppColor.primaryColor,
                          onPress: () => showCreateBranchDialog()),
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
                  ListView.builder(
                      itemCount: authProvider.myCompany!.branchList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var branch = authProvider.myCompany!.branchList![index];
                        Branch? selectedBranch = authProvider.branch;
                        return (branch.location == "" && branch.id == "" ||
                                branch.isDelete == true)
                            ? const SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    color: selectedBranch?.createdAt ==
                                            branch.createdAt
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: selectedBranch?.createdAt ==
                                                branch.createdAt
                                            ? AppColor.primaryColor
                                            : AppColor.darkGrey,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TitleWidget(title: "店舗${index + 1}"),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(JapaneseText.name,
                                                      style:
                                                          kNormalText.copyWith(
                                                              fontSize: 12))),
                                              AppSize.spaceHeight5,
                                              SizedBox(
                                                width: AppSize.getDeviceHeight(
                                                        context) *
                                                    0.8,
                                                child: PrimaryTextField(
                                                  hint: "",
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              "${branch.name}"),
                                                  readOnly: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          JapaneseText
                                                              .postalCode,
                                                          style: kNormalText
                                                              .copyWith(
                                                                  fontSize:
                                                                      12))),
                                                  AppSize.spaceHeight5,
                                                  SizedBox(
                                                    width: 150,
                                                    child: PrimaryTextField(
                                                      hint: "",
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  "${branch.postalCode}"),
                                                      readOnly: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              AppSize.spaceWidth16,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          JapaneseText.location,
                                                          style: kNormalText
                                                              .copyWith(
                                                                  fontSize:
                                                                      12))),
                                                  AppSize.spaceHeight5,
                                                  SizedBox(
                                                    width:
                                                        AppSize.getDeviceHeight(
                                                                    context) *
                                                                0.8 -
                                                            166,
                                                    child: PrimaryTextField(
                                                      hint: "",
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  "${branch.location}"),
                                                      readOnly: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text("TEL",
                                                      style:
                                                          kNormalText.copyWith(
                                                              fontSize: 12))),
                                              AppSize.spaceHeight5,
                                              SizedBox(
                                                width: 200,
                                                child: PrimaryTextField(
                                                  hint: "",
                                                  controller: TextEditingController(
                                                      text:
                                                          "${branch.contactNumber}"),
                                                  readOnly: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 230,
                                          child: ButtonWidget(
                                              radius: 25,
                                              title: "編集",
                                              color: AppColor.primaryColor,
                                              onPress: () => showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CreateOrEditBranchWidget(
                                                              branch: branch,
                                                              index:
                                                                  index)).then(
                                                      (value) {
                                                    if (value != null) {}
                                                  })),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => onDeleteBranch(
                                                index,
                                                selectedBranch?.createdAt ==
                                                    branch.createdAt),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.red)),
                                              alignment: Alignment.center,
                                              child: Text("削除",
                                                  style: kNormalText.copyWith(
                                                      fontSize: 13,
                                                      color: Colors.red)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      })
              ],
            ),
          ),
        ),
      );
    } else {
      return CustomLoadingOverlay(
        isLoading: isLoading,
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
                    child: ButtonWidget(
                        radius: 25,
                        title: "ブランチの作成",
                        color: AppColor.primaryColor,
                        onPress: () => showCreateBranchDialog()),
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
                ListView.builder(
                    itemCount: authProvider.myCompany!.branchList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var branch = authProvider.myCompany!.branchList![index];
                      Branch? selectedBranch = authProvider.branch;
                      return (branch.location == "" && branch.id == "" ||
                              branch.isDelete == true)
                          ? const SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                  color: selectedBranch?.createdAt ==
                                          branch.createdAt
                                      ? Colors.orange.withOpacity(0.1)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectedBranch?.createdAt ==
                                              branch.createdAt
                                          ? AppColor.primaryColor
                                          : AppColor.darkGrey,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(32),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TitleWidget(title: "店舗${index + 1}"),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(JapaneseText.name,
                                                    style: kNormalText.copyWith(
                                                        fontSize: 12))),
                                            AppSize.spaceHeight5,
                                            SizedBox(
                                              width: AppSize.getDeviceHeight(
                                                      context) *
                                                  0.8,
                                              child: PrimaryTextField(
                                                hint: "",
                                                controller:
                                                    TextEditingController(
                                                        text: "${branch.name}"),
                                                readOnly: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        JapaneseText.postalCode,
                                                        style: kNormalText
                                                            .copyWith(
                                                                fontSize: 12))),
                                                AppSize.spaceHeight5,
                                                SizedBox(
                                                  width: 150,
                                                  child: PrimaryTextField(
                                                    hint: "",
                                                    controller:
                                                        TextEditingController(
                                                            text:
                                                                "${branch.postalCode}"),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AppSize.spaceWidth16,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        JapaneseText.location,
                                                        style: kNormalText
                                                            .copyWith(
                                                                fontSize: 12))),
                                                AppSize.spaceHeight5,
                                                SizedBox(
                                                  width:
                                                      AppSize.getDeviceHeight(
                                                                  context) *
                                                              0.8 -
                                                          166,
                                                  child: PrimaryTextField(
                                                    hint: "",
                                                    controller:
                                                        TextEditingController(
                                                            text:
                                                                "${branch.location}"),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("TEL",
                                                    style: kNormalText.copyWith(
                                                        fontSize: 12))),
                                            AppSize.spaceHeight5,
                                            SizedBox(
                                              width: 200,
                                              child: PrimaryTextField(
                                                hint: "",
                                                controller: TextEditingController(
                                                    text:
                                                        "${branch.contactNumber}"),
                                                readOnly: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 230,
                                        child: ButtonWidget(
                                            radius: 25,
                                            title: "編集",
                                            color: AppColor.primaryColor,
                                            onPress: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CreateOrEditBranchWidget(
                                                            branch: branch,
                                                            index: index)).then(
                                                    (value) {
                                                  if (value != null) {}
                                                })),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => onDeleteBranch(
                                              index,
                                              selectedBranch?.createdAt ==
                                                  branch.createdAt),
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.red)),
                                            alignment: Alignment.center,
                                            child: Text("削除",
                                                style: kNormalText.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.red)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                    })
            ],
          ),
        ),
      );
    }
  }

  onDeleteBranch(int index, bool isSelected) {
    if (isSelected) {
      toastMessageError("Can not delete selected branch.", context);
    } else {
      CustomDialog.confirmDelete(
          context: context,
          onDelete: () async {
            Navigator.pop(context);
            setState(() {
              isLoading = true;
            });
            authProvider.myCompany!.branchList![index].isDelete = true;
            String? isSuccess = await CompanyApiServices()
                .updateCompanyBranchInfo(authProvider.myCompany!.uid!,
                    authProvider.myCompany!.branchList!);
            setState(() {
              isLoading = false;
            });
            if (isSuccess == ConstValue.success) {
              authProvider.onChangeCompany(authProvider.myCompany!,
                  branch: null);
              toastMessageSuccess(JapaneseText.successDelete, context);
            } else {
              toastMessageSuccess(JapaneseText.failDelete, context);
            }
          });
    }
  }

  showCreateBranchDialog() {
    showDialog(
            context: context,
            builder: (context) =>
                const CreateOrEditBranchWidget(branch: null, index: null))
        .then((value) {
      if (value != null) {}
    });
  }
}
