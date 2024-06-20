import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_button.dart';

class ChooseBranchWidget extends StatefulWidget {
  final Function onRefresh;
  const ChooseBranchWidget({super.key, required this.onRefresh});

  @override
  State<ChooseBranchWidget> createState() => _ChooseBranchWidgetState();
}

class _ChooseBranchWidgetState extends State<ChooseBranchWidget> with AfterBuildMixin {
  late AuthProvider authProvider;
  Branch? selectedBranch;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const TitleWidget(title: "切り替え"),
      content: SizedBox(
        width: AppSize.getDeviceHeight(context),
        height: AppSize.getDeviceHeight(context) * 0.5,
        child: ListView.builder(
            itemCount: authProvider.myCompany?.branchList!.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              var branch = authProvider.myCompany?.branchList![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: selectedBranch?.createdAt == branch?.createdAt ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(color: selectedBranch?.createdAt == branch?.createdAt ? AppColor.primaryColor : AppColor.darkGrey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedBranch = branch;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        branch?.name == "企業" ? "企業" : "${branch!.name} | ${branch.postalCode} | ${branch.location}",
                        style: kNormalText.copyWith(fontFamily: "Normal", color: Colors.black),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
                width: 200,
                child: ButtonWidget(
                  radius: 25,
                  color: AppColor.whiteColor,
                  title: "キャンセル",
                  onPress: () {
                    Navigator.pop(context);
                  },
                )),
            AppSize.spaceWidth16,
            SizedBox(
              width: 200,
              child: ButtonWidget(
                  radius: 25,
                  title: "保存",
                  color: AppColor.primaryColor,
                  onPress: () {
                    authProvider.onChangeBranch(selectedBranch);
                    Navigator.pop(context);
                    widget.onRefresh();
                    context.go(MyRoute.companyDashboard);
                  }),
            ),
          ]),
        )
      ],
    );
  }

  @override
  void afterBuild(BuildContext context) {
    Branch branch = Branch(
      id: "",
      name: "企業",
      location: "",
      postalCode: "",
    );
    bool isContain = false;
    for (var b in authProvider.myCompany!.branchList!) {
      if (branch.id == b.id && branch.name == b.name && branch.location == b.location) {
        isContain = true;
        break;
      }
    }
    if (!isContain) {
      authProvider.myCompany!.branchList!.add(branch);
    }
    setState(() {
      selectedBranch = authProvider.branch;
    });
  }
}
