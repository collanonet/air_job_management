import 'package:air_job_management/1_company_page/company_profile/company_branch.dart';
import 'package:air_job_management/1_company_page/company_profile/company_profile.dart';
import 'package:air_job_management/const/status.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/company.dart';
import '../../api/user_api.dart';
import '../../const/const.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading_overlay.dart';

class RootCompanyPage extends StatefulWidget {
  const RootCompanyPage({super.key});

  @override
  State<RootCompanyPage> createState() => _RootCompanyPageState();
}

class _RootCompanyPageState extends State<RootCompanyPage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late CompanyProvider companyProvider;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    companyProvider = Provider.of<CompanyProvider>(context);
    return Form(key: _formKey, child: CustomLoadingOverlay(isLoading: isLoading, child: buildBody()));
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
          AppSize.spaceHeight16,
          Text(
            "ホーム　＞　${authProvider.selectedMenu}",
            style: kNormalText.copyWith(fontSize: 12, color: AppColor.primaryColor),
          ),
          AppSize.spaceHeight16,
          if (authProvider.selectedMenu == authProvider.tabMenu[0]) CompanyProfilePage() else CompanyBranchPage(),
          authProvider.selectedMenu == authProvider.tabMenu[1]
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                        width: 200,
                        child: ButtonWidget(
                          radius: 25,
                          color: AppColor.whiteColor,
                          title: "キャンセル",
                          onPress: () {
                            ///Implement cancel change
                            companyProvider.onInitDataForDetail(authProvider.myCompany?.uid ?? "");
                          },
                        )),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 200,
                      child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => onSaveCompanyData()),
                    ),
                  ]),
                )
        ],
      ),
    );
  }

  onSaveCompanyData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Company c = Company(
          managerEmail: companyProvider.managerEmail.text,
          managerNameFu: companyProvider.nameFu.text,
          managerNameKhanJi: companyProvider.nameKhanJi.text,
          managerPassword: companyProvider.managerPassword.text,
          managerPhone: companyProvider.managerPhoneNumber.text,
          remark: companyProvider.remark.text,
          companyBranch: authProvider.myCompany!.companyBranch,
          companyUserId: authProvider.myCompany!.companyUserId,
          hashPassword: authProvider.myCompany!.hashPassword,
          numberOfJobOpening: authProvider.myCompany!.numberOfJobOpening,
          area: companyProvider.area.text,
          industry: companyProvider.industry.text,
          uid: authProvider.myCompany!.uid,
          email: companyProvider.email.text.trim(),
          affiliate: companyProvider.affiliate.text,
          capital: companyProvider.capital.text,
          companyName: companyProvider.companyName.text,
          companyProfile: companyProvider.imageUrl,
          content: companyProvider.content.text,
          homePage: companyProvider.homePage.text,
          publicDate: companyProvider.publicDate.text,
          location: companyProvider.location.text,
          postalCode: companyProvider.postalCode.text,
          status: companyProvider.company?.status ?? StatusUtils.active,
          tax: companyProvider.tax.text,
          tel: companyProvider.tel.text,
          companyLatLng: companyProvider.companyLatLng.text,
          branchList: authProvider.myCompany!.branchList!.map((e) => e).toList(),
          rePresentative: RePresentative(kana: companyProvider.kana.text, kanji: companyProvider.kanji.text),
          manager: companyProvider.managerList.map((e) => RePresentative(kanji: e["kanji"]?.text.trim(), kana: e["kana"]?.text.trim())).toList());
      String? val = await CompanyApiServices().updateCompanyInfo(c);
      setState(() {
        isLoading = false;
      });
      if (val == ConstValue.success) {
        toastMessageSuccess(JapaneseText.successUpdate, context);
        authProvider.onChangeCompany(c);
      } else {
        toastMessageError("$val", context);
      }
    }
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
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColor.primaryColor),
                  child: authProvider.myCompany!.companyProfile != null && authProvider.myCompany!.companyProfile != ""
                      ? Image.network(
                          authProvider.myCompany!.companyProfile!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.person,
                            color: AppColor.whiteColor,
                            size: 35,
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
                    "${authProvider.myCompany?.companyName}",
                    style: normalTextStyle.copyWith(fontSize: 20, color: AppColor.blackColor, fontFamily: "Bold"),
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "${authProvider.myCompany?.location}",
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
    return Stack(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => authProvider.onChangeSelectMenu(authProvider.tabMenu[0]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 39,
                alignment: Alignment.center,
                child: Text(
                  authProvider.tabMenu[0],
                  style: normalTextStyle.copyWith(
                      fontSize: 16,
                      fontFamily: "Bold",
                      color: authProvider.selectedMenu == authProvider.tabMenu[0] ? Colors.white : AppColor.primaryColor),
                ),
                decoration: BoxDecoration(
                    color: authProvider.selectedMenu == authProvider.tabMenu[0] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 2, color: AppColor.primaryColor),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
            AppSize.spaceWidth16,
            InkWell(
              onTap: () => authProvider.onChangeSelectMenu(authProvider.tabMenu[1]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 39,
                alignment: Alignment.center,
                child: Text(
                  authProvider.tabMenu[1],
                  style: normalTextStyle.copyWith(
                      fontSize: 16,
                      fontFamily: "Bold",
                      color: authProvider.selectedMenu == authProvider.tabMenu[1] ? Colors.white : AppColor.primaryColor),
                ),
                decoration: BoxDecoration(
                    color: authProvider.selectedMenu == authProvider.tabMenu[1] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 2, color: AppColor.primaryColor),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
          ],
        ),
        Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: AppSize.getDeviceWidth(context) * 0.5,
              height: 1,
              color: AppColor.primaryColor,
            ))
      ],
    );
  }
}
