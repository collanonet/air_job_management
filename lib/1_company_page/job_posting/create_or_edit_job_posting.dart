import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_info.dart';
import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_shift.dart';
import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_shift_frame_list.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading_overlay.dart';

class CreateOrEditJobPostingPageForCompany extends StatefulWidget {
  final String? jobPosting;
  const CreateOrEditJobPostingPageForCompany({super.key, this.jobPosting});

  @override
  State<CreateOrEditJobPostingPageForCompany> createState() => _CreateOrEditJobPostingPageForCompanyState();
}

class _CreateOrEditJobPostingPageForCompanyState extends State<CreateOrEditJobPostingPageForCompany> with AfterBuildMixin {
  final _formKey = GlobalKey<FormState>();
  JobPosting? jobPosting;
  late JobPostingForCompanyProvider provider;
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return CustomLoadingOverlay(isLoading: provider.isLoading, child: buildBody());
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topBarWidget(),
          AppSize.spaceHeight8,
          tabSelection(),
          if (provider.selectedMenu == provider.tabMenu[0])
            JobPostingInformationPageForCompany()
          else if (provider.selectedMenu == provider.tabMenu[1])
            JobPostingShiftPageForCompany()
          else
            JobPostingShiftFramePageForCompany(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                  width: 200,
                  child: ButtonWidget(
                    radius: 25,
                    color: AppColor.whiteColor,
                    title: "キャンセル",
                    onPress: () {},
                  )),
              AppSize.spaceWidth16,
              SizedBox(
                width: 200,
                child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () {}),
              ),
            ]),
          )
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppSize.spaceWidth32,
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(authProvider.myCompany?.companyProfile ?? ConstValue.defaultImage), fit: BoxFit.cover),
                    shape: BoxShape.circle,
                    color: AppColor.primaryColor),
                alignment: Alignment.center,
              ),
              AppSize.spaceWidth32,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${authProvider.myCompany?.companyName}",
                        style: normalTextStyle.copyWith(fontSize: 20, color: AppColor.blackColor, fontFamily: "Bold"),
                      ),
                      AppSize.spaceWidth32,
                      Text(
                        provider.jobPosting?.title ?? "",
                        style: normalTextStyle.copyWith(fontSize: 20, color: AppColor.blackColor, fontFamily: "Bold"),
                      ),
                    ],
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "${authProvider.myCompany?.manager?.first.kanji} ${authProvider.myCompany?.manager?.first.kana}",
                    style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.blackColor, fontFamily: "Normal"),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  tabSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ホーム　＞　求人一覧",
          style: kNormalText.copyWith(fontSize: 12, color: AppColor.primaryColor),
        ),
        AppSize.spaceHeight5,
        Stack(
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
                          fontSize: 16,
                          fontFamily: "Bold",
                          color: provider.selectedMenu == provider.tabMenu[0] ? Colors.white : AppColor.primaryColor),
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
                          fontSize: 16,
                          fontFamily: "Bold",
                          color: provider.selectedMenu == provider.tabMenu[1] ? Colors.white : AppColor.primaryColor),
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
                          fontSize: 16,
                          fontFamily: "Bold",
                          color: provider.selectedMenu == provider.tabMenu[2] ? Colors.white : AppColor.primaryColor),
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
        ),
      ],
    );
  }

  @override
  void initState() {
    Provider.of<JobPostingForCompanyProvider>(context, listen: false).setLoading = true;
    Provider.of<JobPostingForCompanyProvider>(context, listen: false).setAllController = [];
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    initialData();
  }

  initialData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        await provider.onInitForJobPostingDetail(widget.jobPosting);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      await provider.onInitForJobPostingDetail(widget.jobPosting);
    }
  }
}
