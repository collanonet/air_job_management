import 'package:air_job_management/1_company_page/woker_management/widget/job_card.dart';
import 'package:air_job_management/1_company_page/woker_management/worker_management_detail/basic_information.dart';
import 'package:air_job_management/1_company_page/woker_management/worker_management_detail/chat.dart';
import 'package:air_job_management/api/company/worker_managment.dart';
import 'package:air_job_management/models/company/request.dart';
import 'package:air_job_management/models/company/worker_management.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/date_to_api.dart';
import '../../models/entry_exit_history.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../woker_management/worker_management_detail/application_history.dart';

List<EntryExitHistory> entryForApplicant = [];
List<Request> requestByUserList = [];

class ApplicantRootPage extends StatefulWidget {
  final String uid;
  final bool isView;
  const ApplicantRootPage({super.key, required this.uid, this.isView = false});

  @override
  State<ApplicantRootPage> createState() => _ApplicantRootPageState();
}

class _ApplicantRootPageState extends State<ApplicantRootPage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late WorkerManagementProvider provider;

  getJob() async {
    if (provider.selectedJob == null) {
      WorkerManagement? job = await WorkerManagementApiService().getAJob(widget.uid);
      provider.setJob = job!;
      provider.onChangeLoading(false);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<WorkerManagementProvider>(context);
    return CustomLoadingOverlay(isLoading: provider.isLoading, child: buildBody());
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topBarWidget(),
          AppSize.spaceHeight20,
          tabSelection(),
          if (provider.selectedMenu == provider.tabMenu[0])
            BasicInformationPage(
              myUser: provider.selectedJob?.myUser,
            )
          else if (provider.selectedMenu == provider.tabMenu[1])
            CompanyChatPage(
              myUser: provider.selectedJob!.myUser!,
              companyID: provider.selectedJob!.companyId!,
              companyImageUrl: authProvider.myCompany!.companyProfile,
              companyName: authProvider.myCompany!.companyName,
            )
          else
            ApplicationHistoryPage(
              myUser: provider.selectedJob?.myUser,
            ),
          // AllShiftApplicantPage(
          //   myUser: provider.selectedJob!.myUser!,
          //   id: provider.selectedJob!.uid!,
          //   searchJobId: provider.selectedJob!.jobId!,
          // ),
          SizedBox(
            height: widget.isView ? 20 : 0,
          ),
          if (widget.isView)
            Center(
                child: SizedBox(
              width: 150,
              child: ButtonWidget(color: Colors.white, radius: 50, title: JapaneseText.close, onPress: () => Navigator.pop(context)),
            ))
          else
            const SizedBox()
        ],
      ),
    );
  }

  topBarWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 100,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: provider.selectedJob != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppSize.spaceWidth32,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl: provider.selectedJob?.myUser?.profileImage ?? "",
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: AppColor.whiteColor,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppSize.spaceWidth32,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${provider.selectedJob?.myUser?.nameKanJi} ${provider.selectedJob?.myUser?.nameFu}",
                          style: normalTextStyle.copyWith(fontSize: 20, color: AppColor.blackColor, fontFamily: "Bold"),
                        ),
                        AppSize.spaceHeight5,
                        Text(
                          "${provider.selectedJob?.myUser?.city ?? provider.selectedJob?.myUser?.province ?? provider.selectedJob?.myUser?.street}                ${provider.selectedJob?.myUser?.gender}   ${calculateAge(DateToAPIHelper.fromApiToLocal(provider.selectedJob!.myUser!.dob!.replaceAll("-", "/").toString()))}",
                          style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.blackColor, fontFamily: "Normal"),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  tabSelection() {
    return Stack(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => provider.onChangeSelectMenu(provider.tabMenu[0]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 39,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[0],
                  style: normalTextStyle.copyWith(
                      fontSize: 16, fontFamily: "Bold", color: provider.selectedMenu == provider.tabMenu[0] ? Colors.white : AppColor.primaryColor),
                ),
                decoration: BoxDecoration(
                    color: provider.selectedMenu == provider.tabMenu[0] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 2, color: AppColor.primaryColor),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
            AppSize.spaceWidth16,
            InkWell(
              onTap: () => provider.onChangeSelectMenu(provider.tabMenu[1]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 39,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[1],
                  style: normalTextStyle.copyWith(
                      fontSize: 16, fontFamily: "Bold", color: provider.selectedMenu == provider.tabMenu[1] ? Colors.white : AppColor.primaryColor),
                ),
                decoration: BoxDecoration(
                    color: provider.selectedMenu == provider.tabMenu[1] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 2, color: AppColor.primaryColor),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
            AppSize.spaceWidth16,
            InkWell(
              onTap: () => provider.onChangeSelectMenu(provider.tabMenu[2]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 39,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[2],
                  style: normalTextStyle.copyWith(
                      fontSize: 16, fontFamily: "Bold", color: provider.selectedMenu == provider.tabMenu[2] ? Colors.white : AppColor.primaryColor),
                ),
                decoration: BoxDecoration(
                    color: provider.selectedMenu == provider.tabMenu[2] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 2, color: AppColor.primaryColor),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            )
          ],
        ),
        Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: AppSize.getDeviceWidth(context) * 0.75,
              height: 1,
              color: AppColor.primaryColor,
            ))
      ],
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getJob();
  }
}
