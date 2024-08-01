import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_info.dart';
import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_shift.dart';
import 'package:air_job_management/1_company_page/job_posting/job_posting_detail/job_posting_shift_frame_list.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../2_worker_page/viewprofile/widgets/pickimage.dart';
import '../../api/user_api.dart';
import '../../models/company.dart';
import '../../models/job_posting.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../../widgets/show_message.dart';

class CreateOrEditJobPostingPageForCompany extends StatefulWidget {
  final String? jobPosting;
  final bool? isCopyPaste;
  final bool isView;
  const CreateOrEditJobPostingPageForCompany({super.key, this.jobPosting, this.isCopyPaste, this.isView = false});

  @override
  State<CreateOrEditJobPostingPageForCompany> createState() => _CreateOrEditJobPostingPageForCompanyState();
}

class _CreateOrEditJobPostingPageForCompanyState extends State<CreateOrEditJobPostingPageForCompany> with AfterBuildMixin {
  final _formKey = GlobalKey<FormState>();
  late JobPostingForCompanyProvider provider;
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    if (widget.isCopyPaste == true) {
      return Form(
          key: _formKey,
          child: Scaffold(
            body: buildBody(),
            backgroundColor: AppColor.bgPageColor,
          ));
    } else {
      return Form(key: _formKey, child: CustomLoadingOverlay(isLoading: provider.isLoading, child: buildBody()));
    }
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topBarWidget(),
          AppSize.spaceHeight8,
          tabSelection(),
          if (provider.selectedMenu == provider.tabMenu[0])
            JobPostingInformationPageForCompany(
              isView: widget.isView,
            )
          else if (provider.selectedMenu == provider.tabMenu[1])
            JobPostingShiftPageForCompany(
              isView: widget.isView,
            )
          else if (widget.isCopyPaste == true && widget.jobPosting == null)
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: EmptyDataWidget(),
              ),
            )
          else
            JobPostingShiftFramePageForCompany(
              isView: widget.isView,
            ),
          if (provider.selectedMenu != provider.tabMenu[2])
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                    width: 200,
                    child: ButtonWidget(
                      radius: 25,
                      color: AppColor.whiteColor,
                      title: "キャンセル",
                      onPress: () =>
                          widget.isCopyPaste == true || widget.isView == true ? Navigator.pop(context) : context.go(MyRoute.companyJobPosting),
                    )),
                AppSize.spaceWidth16,
                widget.isView == true
                    ? const SizedBox()
                    : SizedBox(
                        width: 200,
                        child: ButtonWidget(radius: 25, title: "保存", color: AppColor.primaryColor, onPress: () => saveJobPostingData()),
                      )
              ]),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  saveJobPostingData() async {
    if (_formKey.currentState!.validate()) {
      if (provider.latLong.text.isEmpty || !provider.latLong.text.contains(", ")) {
        MessageWidget.show("無効な緯度と経度 (形式は \"34.xxxxxxxx、135.xxxxxxxx\" である必要があります)");
      } else if (provider.jobPosterProfile.length == 1) {
        MessageWidget.show("求人情報の表紙画像を選択してください");
      } else if (provider.selectedSpecificOccupation == null) {
        MessageWidget.show("職業を選択してください");
      } else if (provider.selectedLocation == null) {
        MessageWidget.show("勤務地を選択してください");
      } else {
        try {
          bool isTheSameMajorJob = false;
          if (provider.jobPosting?.majorOccupation == provider.selectedSpecificOccupation) {
            isTheSameMajorJob = true;
          }
          provider.onChangeLoading(true);
          List<String> urlPosterList = [];
          for (int i = 0; i < provider.jobPosterProfile.length; i++) {
            var file = provider.jobPosterProfile[i];
            if (file != null) {
              if (file.toString().contains("https")) {
                urlPosterList.add(file.toString());
              } else {
                String imageUrl = await fileToUrl(file.files.first.bytes!, "job_cover_images");
                urlPosterList.add(imageUrl);
              }
            }
          }
          if (urlPosterList.isNotEmpty) {
            provider.jobPosting?.image = urlPosterList[0];
          }
          if (widget.isCopyPaste == true) {
            if (provider.jobPosting!.updateList!.isEmpty) {
              provider.jobPosting!.updateList!.add(UpdateHistory(
                recruitment: provider.jobPosting!.numberOfRecruit.toString(),
                postStartDate: provider.jobPosting!.postedStartDate.toString(),
                postEndDate: provider.jobPosting!.postedEndDate.toString(),
                startDate: provider.jobPosting!.startDate.toString(),
                endDate: provider.jobPosting!.endDate.toString(),
                title: provider.jobPosting!.title.toString(),
                startTime: provider.jobPosting!.startTimeHour.toString(),
                endTime: provider.jobPosting!.endTimeHour.toString(),
              ));
            }
            var update = UpdateHistory(
              recruitment: provider.numberOfRecruitPeople.text.toString(),
              postStartDate: DateToAPIHelper.convertDateToString(provider.startPostDate),
              postEndDate: DateToAPIHelper.convertDateToString(provider.endPostDate),
              startDate: DateToAPIHelper.convertDateToString(provider.startWorkDate),
              endDate: DateToAPIHelper.convertDateToString(provider.endWorkDate),
              title: provider.title.text.toString(),
              startTime: dateTimeToHourAndMinute(provider.startWorkingTime),
              endTime: dateTimeToHourAndMinute(provider.endWorkingTime),
            );
            provider.jobPosting?.updateList!.add(update);
            if (isTheSameMajorJob == false) {
              provider.jobPosting?.updateList = [];
            }
          } else {
            var update = UpdateHistory(
                recruitment: provider.numberOfRecruitPeople.text.toString(),
                postStartDate: DateToAPIHelper.convertDateToString(provider.startPostDate),
                postEndDate: DateToAPIHelper.convertDateToString(provider.endPostDate),
                startDate: DateToAPIHelper.convertDateToString(provider.startWorkDate),
                endDate: DateToAPIHelper.convertDateToString(provider.endWorkDate),
                title: provider.title.text.toString(),
                startTime: dateTimeToHourAndMinute(provider.startWorkingTime),
                endTime: dateTimeToHourAndMinute(provider.endWorkingTime),
                isClose: provider.selectedPublicSetting == JapaneseText.privatePost ? true : false);
            provider.jobPosting?.updateList!.add(update);
          }
          if (provider.jobPosting?.transportationFeeOptions == JapaneseText.notProvidedTF) {
            provider.jobPosting?.transportExpenseFee = "0";
          } else {
            provider.jobPosting?.transportExpenseFee = provider.transportExp.text;
          }
          provider.jobPosting?.postedStartDate = DateToAPIHelper.convertDateToString(provider.startPostDate);
          provider.jobPosting?.postedEndDate = DateToAPIHelper.convertDateToString(provider.endPostDate);
          provider.jobPosting?.branchId = authProvider.branch?.id ?? "";
          provider.jobPosting?.isAllowSmokingInArea = provider.isAllowSmokingInArea;
          provider.jobPosting?.selectSmokingInDoor = provider.selectSmokingInDoor;
          provider.jobPosting?.limitGroupEmail = initialTags;
          provider.jobPosting?.employmentType ??= JapaneseText.partTimeJob;
          provider.jobPosting?.company = authProvider.myCompany?.companyName;
          provider.jobPosting?.companyId = authProvider.myCompany?.uid;
          provider.jobPosting?.coverList = urlPosterList;
          provider.jobPosting?.title = provider.title.text;
          provider.jobPosting?.description = provider.jobDescription.text;
          provider.jobPosting?.belongings = provider.belongings.text;
          provider.jobPosting?.notes = provider.notes.text;
          provider.jobPosting?.workCatchPhrase = provider.conditionForWork.text;
          provider.jobPosting?.location?.postalCode = provider.postalCode.text;
          provider.jobPosting?.location?.street = provider.street.text;
          provider.jobPosting?.location?.building = provider.building.text;
          provider.jobPosting?.location?.accessAddress = provider.accessAddress.text;
          provider.jobPosting?.location?.accessAddress = provider.accessAddress.text;
          provider.jobPosting?.location?.lat = provider.latLong.text.split(", ")[0].toString();
          provider.jobPosting?.location?.lng = provider.latLong.text.split(", ")[1].toString();
          provider.jobPosting?.numberOfRecruit = provider.numberOfRecruitPeople.text;
          provider.jobPosting?.hourlyWag = provider.hourlyWag.text;
          provider.jobPosting?.emergencyContact = provider.emergencyContact.text;
          provider.jobPosting?.expAndQualifiedPeopleWelcome = provider.expWelcome;
          provider.jobPosting?.mealsAssAvailable = provider.mealsAvailable;
          provider.jobPosting?.clothFree = provider.freeClothing;
          provider.jobPosting?.hairStyleColorFree = provider.freeHairStyleAndColor;
          provider.jobPosting?.transportExpense = provider.transportationProvided;
          provider.jobPosting?.motorCycleCarCommutingPossible = provider.motorCycleCarCommutingPossible;
          provider.jobPosting?.bicycleCommutingPossible = provider.bicycleCommutingPossible;
          provider.jobPosting?.selectedPublicSetting = provider.selectedPublicSetting;
          provider.jobPosting?.occupationType = provider.selectedOccupationType;
          provider.jobPosting?.majorOccupation = provider.selectedSpecificOccupation;
          provider.jobPosting?.jobLocation = provider.selectedLocation;
          provider.jobPosting?.startTimeHour = dateTimeToHourAndMinute(provider.startWorkingTime);
          provider.jobPosting?.endTimeHour = dateTimeToHourAndMinute(provider.endWorkingTime);
          provider.jobPosting?.startBreakTimeHour = dateTimeToHourAndMinute(provider.startBreakTime);
          provider.jobPosting?.endBreakTimeHour = dateTimeToHourAndMinute(provider.endBreakTime);
          provider.jobPosting?.startDate = DateToAPIHelper.convertDateToString(provider.startWorkDate);
          provider.jobPosting?.endDate = DateToAPIHelper.convertDateToString(provider.endWorkDate);

          if (widget.isCopyPaste == true) {
            provider.jobPosting!.shiftFrameList = [];
          }

          String? success = provider.jobPosting?.uid != null && widget.isCopyPaste == null
              ? await JobPostingApiService().updateJobPostingInfo(provider.jobPosting)
              : await JobPostingApiService().createJob(provider.jobPosting);
          provider.onChangeLoading(false);
          if (success == ConstValue.success) {
            MessageWidget.show(
                provider.jobPosting?.uid != null && widget.isCopyPaste == null ? JapaneseText.successUpdate : JapaneseText.successCreate);
            await provider.getAllJobPost(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
            if (widget.isCopyPaste == true && isTheSameMajorJob) {
              await JobPostingApiService().updateJobHistory(widget.jobPosting ?? "", provider.jobPosting?.updateList ?? []);
              Navigator.pop(context);
            } else {
              context.go(MyRoute.companyJobPosting);
            }
          } else {
            MessageWidget.show(provider.jobPosting?.uid != null && widget.isCopyPaste == null ? JapaneseText.failUpdate : JapaneseText.failCreate);
          }
        } catch (e) {
          provider.onChangeLoading(false);
          MessageWidget.show(e.toString());
        }
      }
    }
  }

  topBarWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 80,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppSize.spaceWidth32,
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(authProvider.myCompany?.companyProfile ?? ConstValue.defaultBgImage), fit: BoxFit.cover),
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
                        authProvider.myCompany?.companyName ?? "",
                        style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.blackColor, fontFamily: "Bold"),
                      ),
                      AppSize.spaceWidth32,
                      Text(
                        provider.jobPosting?.title ?? "",
                        style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.blackColor, fontFamily: "Bold"),
                      ),
                    ],
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    authProvider.myCompany?.companyBranch ?? "",
                    style: normalTextStyle.copyWith(fontSize: 14, color: AppColor.blackColor, fontFamily: "Normal"),
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
        Row(
          children: [
            InkWell(
              onTap: () => context.go(MyRoute.companyJobPosting),
              child: Text(
                "ホーム　＞　",
                style: kNormalText.copyWith(fontSize: 12, color: AppColor.primaryColor),
              ),
            ),
            Text(provider.selectedMenu, style: kNormalText.copyWith(fontSize: 12, color: AppColor.primaryColor))
          ],
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
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      provider.tabMenu[0],
                      style: normalTextStyle.copyWith(
                          fontSize: 14,
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
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      provider.tabMenu[1],
                      style: normalTextStyle.copyWith(
                          fontSize: 14,
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
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      provider.tabMenu[2],
                      style: normalTextStyle.copyWith(
                          fontSize: 14,
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
        await provider.onInitForJobPostingDetail(widget.jobPosting, authProvider: authProvider);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      if (widget.jobPosting != null) {
        await provider.onInitForJobPostingDetail(widget.jobPosting, authProvider: authProvider);
      } else {
        provider.initialData();
        await provider.onInitForJobPostingDetail(widget.jobPosting, authProvider: authProvider);
      }
    }
  }
}
