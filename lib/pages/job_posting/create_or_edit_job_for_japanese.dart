import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/providers/job_posting_for_japanese.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/radio_listtile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/company.dart';
import '../../const/const.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/my_route.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown_string.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../../widgets/custom_textfield.dart';

class CreateOrEditJobForJapanesePage extends StatefulWidget {
  final String? jobPostId;
  const CreateOrEditJobForJapanesePage({Key? key, required this.jobPostId}) : super(key: key);

  @override
  State<CreateOrEditJobForJapanesePage> createState() => _CreateOrEditJobForJapanesePageState();
}

class _CreateOrEditJobForJapanesePageState extends State<CreateOrEditJobForJapanesePage> with AfterBuildMixin {
  late JobPostingForJapaneseProvider provider;
  late JobPostingProvider jobPostingProvider;
  DateTime now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      DateTime start = MyDateTimeUtils.fromApiToLocal(provider.startRecruitDate.text);
      DateTime end = MyDateTimeUtils.fromApiToLocal(provider.endRecruitDate.text);
      if (end.isBefore(start)) {
        // End date is before start date validation
        toastMessageError("募集終了日が募集開始日より前です", context);
      } else if (!provider.companyLocationLatLng.text.contains(", ")) {
        //Invalid latitude and longitude of company location or interview location.
        toastMessageError("会社の所在地または面接の場所の緯度と経度が無効です。", context);
      } else {
        //Continue to create job posting
        print("Start Job post");
        JobPosting c = JobPosting(
            status: "",
            uid: widget.jobPostId ?? "",
            title: provider.title.text,
            endDate: provider.endRecruitDate.text,
            startDate: provider.startRecruitDate.text,
            annualHoliday: provider.numberOfAnnualHolidays.text,
            bonus: provider.bonus,
            breakTimeAsMinute: provider.breakTimeMinute.text,
            childCareLeaveSystem: provider.isChildCareSystem,
            company: provider.selectedCompany,
            companyId: provider.selectedCompanyId,
            content: provider.content.text,
            contentOfTheTest: [],
            description: provider.overview.text,
            desiredGender: provider.selectedDesiredGender,
            desiredNationality: provider.selectedNationality,
            dormOrCompanyHouse: provider.dorm,
            employmentContractProvisioning: provider.contractProvisioning == JapaneseText.yes,
            employmentType: provider.selectedEmploymentType,
            endTimeHour: provider.startWorkTime.text,
            holidayDetail: provider.holidayDetail.text,
            hotelCleaningLearningItem: [],
            image: provider.imageUrl,
            interviewLocation: Location(
                name: provider.companyLocationLatLng.text,
                des: provider.companyLocationLatLng.text,
                lat: provider.companyLocationLatLng.text.split(", ")[0],
                lng: provider.companyLocationLatLng.text.split(", ")[1]),
            isRemoteInterview: provider.isThereRemoteInterview,
            location: Location(
                name: provider.companyLocation.text,
                des: provider.companyLocation.text,
                lat: provider.companyLocationLatLng.text.split(", ")[0],
                lng: provider.companyLocationLatLng.text.split(", ")[1]),
            meals: provider.meals,
            necessaryJapanSkill: provider.selectedNecessaryJapanSkill,
            numberOfRecruit: provider.numberOfRecruitPeople.text,
            occupation: provider.chooseOccupationSkill,
            occupationType: provider.selectedOccupation,
            offHour: provider.offHour,
            otherQualification: provider.otherQualification.text,
            paidHoliday: provider.paidHoliday,
            raise: provider.raise,
            rehire: provider.isRetirementSystem,
            remarkOfRequirement: provider.remark.text,
            retirementSystem: provider.isRetirementSystem,
            reviews: [],
            salaryType: provider.salaryType,
            severancePay: provider.isRetirementBenefits,
            socialInsurance: "",
            startTimeHour: provider.startWorkTime.text,
            statusOfResidence: [],
            trailPeriod: provider.trailPeriod,
            transportExpense: provider.transportExpense,
            wifi: provider.wifi,
            workCatchPhrase: provider.title.text,
            employment: provider.isEmployment,
            health: provider.isHealth,
            industrialAccident: provider.isIndustrialAccident,
            publicWelfare: provider.isWelfare,
            sun: provider.sun,
            sat: provider.sat,
            fri: provider.sat,
            thu: provider.thu,
            mon: provider.mon,
            salaryRange: provider.salaryRangeType,
            tue: provider.tue,
            accordingToOurCalendar: provider.accordingToOurCalendar,
            amountOfPayrollFrom: provider.fromSalaryAmount.text,
            wed: provider.wed,
            amountOfPayrollTo: provider.toSalaryAmount.text,
            applicationProcess: provider.flowAfterApplication.text,
            atHome: provider.atHome,
            atmosphereRemark: provider.remarkAtmosphere.text,
            beginnersAreActivelyWorking: provider.beginnersAreActivelyWorking,
            blankOk: provider.blankOk,
            bonuses: provider.bonuses,
            bonusRemark: provider.remarkBonus.text,
            businessLike: provider.businessLike,
            calmWorkplace: provider.calmWorkplace,
            canApplyWithFri: provider.canApplyWithFri,
            childCareLeave: provider.childCareLeave,
            clothFree: provider.clothFree,
            collaborative: provider.collaborative,
            commutingByBikeOK: provider.commutingByBikeOK,
            commutingNearByOK: provider.commutingNearByOK,
            companyDiscountAvailable: provider.companyDiscountAvailable,
            dailyWorkFlow: provider.oneDayWorkFlow.text,
            deskWork: provider.deskWork,
            dormCompanyHouseHousingAllowanceAvailable: provider.dormCompanyHouseHousingAllowanceAvailable,
            easyToAdjustToYourConvenience: provider.easyToAdjustToYourConvenience,
            eligibilityForApplication: provider.eligibilityForApp.text,
            employeePromotionAvailable: provider.employeePromotionAvailable,
            examinationOfTraining: provider.examAndTraining,
            exampleOfShiftAndIncome: provider.shiftIncomeExample.text,
            expAndQualifiedPeopleWelcome: provider.expAndQualifiedPeopleWelcome,
            expectedNumberOfRecruits: provider.plannedNumberOfEmployee.text,
            familyAllowance: provider.familyAllowance,
            fewInteractionsOutsideOfWork: provider.fewInteractionsOutsideOfWork,
            form: ConstValue.japanese,
            fourAndMoreDayAWeekOK: provider.fourAndMoreDayAWeekOK,
            fourTwoFiveTwoOff: provider.fourTwoFiveTwoOff,
            fullTimeWelcome: provider.fullTimeWelcome,
            hairStyleColorFree: provider.hairStyleColorFree,
            highSchoolStudent: provider.highSchoolStudent,
            holidayAllowance: provider.holidayAllowance,
            holidayRemark: provider.remarkHoliday.text,
            houseWivesHouseHusbandsWelcome: provider.houseWivesHouseHusbandsWelcome,
            individualityCanBeUtilized: provider.individualityCanBeUtilized,
            infoToBeObtains: provider.informationToObtain,
            knowledgeAndExperience: provider.knowledgeAndExperience,
            lateNightAllowance: provider.lateNightAllowance,
            lessInteractionWithCustomers: provider.lessInteractionWithCustomers,
            littleOfManualLabor: provider.littleOfManualLabor,
            livelyWorkplace: provider.livelyWorkplace,
            longTermWelcome: provider.longTermWelcome,
            lotsOfManualLabor: provider.lotsOfManualLabor,
            manyInteractionsOutsideOfWork: provider.manyInteractionsOutsideOfWork,
            manyInTheir20: provider.manyInTheir20,
            manyInTheir30: provider.manyInTheir30,
            manyInTheir40: provider.manyInTheir40,
            manyInTheir50: provider.manyInTheir50,
            manyMen: provider.manyMen,
            manyTeenagers: provider.manyTeenagers,
            manyWomen: provider.manyWomen,
            mealsAssAvailable: provider.mealsAssAvailable,
            messageFromSeniorStaff: provider.aWordFromASeniorStaffMember.text,
            minimumNumberOfWorkingDays: provider.minimumNumberOfWorkingDays.text,
            minimumNumberOfWorkingTime: provider.minimumNumberOfWorkingTime.text,
            minimumWorkTerm: provider.minimumWorkTerm.text,
            nearOrInsideStation: provider.nearOrInsideStation,
            noEducationRequire: provider.noEducationRequire,
            noExpBeginnerIsOk: provider.noExpBeginnerIsOk,
            noKnowledgeOrExperienceRequired: provider.noKnowledgeOrExperienceRequired,
            nurseCareLeave: provider.nurseCareLeave,
            offHours: provider.offHours.text,
            onlyOnWeekDayOK: provider.onlyOnWeekDayOK,
            ovenStaff: provider.ovenStaff,
            overtimeAllowance: provider.overtimeAllowance,
            paidHoliday2: provider.paidHoliday2,
            partTimeWelcome: provider.partTimeWelcome,
            perfectAttendanceAllowance: provider.perfectAttendanceAllowance,
            phoneNumber: provider.inquiryPhoneNumber.text,
            prenatalAndPostnatalLeave: provider.prenatalAndPostnatalLeave,
            qualificationAcqSupportSystem: provider.qualificationAcqSupportSystem,
            qualificationAllowance: provider.qualificationAllowance,
            salaryIncrease: provider.salaryIncrease,
            sameDayWorkOK: provider.sameDayWorkOK,
            satSunHolidayOK: provider.satSunHolidayOK,
            scheduledTimeExactly: provider.scheduledTimeExactly,
            seniorSupport: provider.seniorSupport,
            shiftCycle: provider.shiftCycle.text,
            shiftFixingPeriod: provider.shiftFixingPeriod.text,
            shiftSubPeriod: provider.shiftSubPeriod.text,
            shiftSystem2: provider.shiftSystem2,
            shiftSystem: provider.shiftSystem,
            shortTerm: provider.shortTerm,
            sideJoBDoubleWorkOK: provider.sideJoBDoubleWorkOK,
            singleDayOK: provider.singleDayOK,
            socialInsurance2: provider.socialInsurance2,
            standingWork: provider.standingWork,
            summerVacation: provider.summerVacation,
            sundayAndPublicHoliday: provider.sundayAndPublicHoliday,
            supplementaryExplanationOfSalary: provider.supplementary.text,
            tooMuchInteractionWithCustomers: provider.tooMuchInteractionWithCustomers,
            trainingAvailable: provider.trainingAvailable,
            transportRemark: provider.remarkTransport.text,
            uniform: provider.uniform,
            universityStudentWelcome: provider.universityStudentWelcome,
            winterVacation: provider.winterVacation,
            workDependentsOK: provider.workDependentsOK,
            youCanChooseTheTimeAndDayOfTheWeek: provider.youCanChooseTheTimeAndDayOfTheWeek,
            youCanWorkForAlongTime: provider.youCanWorkForAlongTime);
        String? val;
        if (widget.jobPostId != null) {
          val = await JobPostingApiService().updateJobPostingInfo(c);
        } else {
          val = await JobPostingApiService().createJob(c);
        }
        print("end Job post");
        provider.onChangeLoading(false);
        if (val == ConstValue.success) {
          toastMessageSuccess(widget.jobPostId != null ? JapaneseText.successUpdate : JapaneseText.successCreate, context);
          await jobPostingProvider.getAllJobPost();
          context.pop();
          context.go(MyRoute.job);
        } else {
          toastMessageError("$val", context);
        }
      }
    }
  }

  @override
  void initState() {
    Provider.of<JobPostingForJapaneseProvider>(context, listen: false).setLoading = true;
    Provider.of<JobPostingForJapaneseProvider>(context, listen: false).setAllController = [];
    Provider.of<JobPostingForJapaneseProvider>(context, listen: false).setImage = "";
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    initialData();
  }

  initialData() async {
    await provider.onInitForJobPostingDetail(widget.jobPostId);
  }

  @override
  void dispose() {
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForJapaneseProvider>(context);
    jobPostingProvider = Provider.of<JobPostingProvider>(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        body: CustomLoadingOverlay(
          isLoading: provider.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget(),
                AppSize.spaceHeight16,
                Container(
                  padding: const EdgeInsets.all(12),
                  width: AppSize.getDeviceWidth(context),
                  height: AppSize.getDeviceHeight(context) - 110,
                  decoration: boxDecoration,
                  child: Scrollbar(
                    controller: controller,
                    isAlwaysShown: true,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.55 + 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    JapaneseText.workCatchPhrase,
                                    style: normalTextStyle,
                                  ),
                                  AppSize.spaceHeight5,
                                  PrimaryTextField(
                                    controller: provider.title,
                                    hint: '',
                                    marginBottom: 5,
                                  ),
                                ],
                              )),
                          AppSize.spaceHeight16,
                          const Divider(),
                          AppSize.spaceHeight16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColor.primaryColor,
                              ),
                              AppSize.spaceWidth8,
                              Text(
                                JapaneseText.applicationGuidelines,
                                style: titleStyle,
                              ),
                            ],
                          ),
                          AppSize.spaceHeight16,
                          chooseCompany(),
                          AppSize.spaceHeight16,
                          employmentStatus(),
                          AppSize.spaceHeight16,
                          chooseOccupation(),
                          AppSize.spaceHeight16,
                          chooseSalaryType(),
                          AppSize.spaceHeight16,
                          supplementaryExplanationExamAndTraining(),
                          AppSize.spaceHeight16,
                          aboutEmployee(),
                          AppSize.spaceHeight16,
                          aboutJobContent(),
                          AppSize.spaceHeight16,
                          const Divider(),
                          AppSize.spaceHeight16,
                          workEnvironment(),
                          AppSize.spaceHeight16,
                          const Divider(),
                          AppSize.spaceHeight16,
                          aboutApplication(),
                          const Divider(),
                          AppSize.spaceHeight50,
                          Center(
                            child: SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.2,
                              child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  employmentStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.employmentStatus,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        CustomDropDownWidget(
          list: provider.employmentType.map((e) => e.toString()).toList(),
          onChange: (e) => provider.onChangeEmploymentType(e),
          width: AppSize.getDeviceWidth(context) * 0.3,
          selectItem: provider.selectedEmploymentType,
        )
      ],
    );
  }

  chooseCompany() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.company,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        CustomDropDownWidget(
          list: provider.allCompany.map((e) => e.companyName.toString()).toList(),
          onChange: (e) => provider.onChangeSelectCompanyForDetail(e),
          width: AppSize.getDeviceWidth(context) * 0.6,
          selectItem: provider.selectedCompany,
        )
      ],
    );
  }

  chooseSalaryType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.salaryFrom,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTileWidget(
                title: JapaneseText.hourlyWage,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.hourlyWage),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.dailyWage,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.dailyWage),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.monthlySalary,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.monthlySalary),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.annualWage,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.annualWage),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.onePanel,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.onePanel),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.oneWorkday,
                onChange: (v) => provider.onChangeSalaryType(JapaneseText.oneWorkday),
                size: 100,
                val: provider.salaryType),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.other, onChange: (v) => provider.onChangeSalaryType(JapaneseText.other), size: 140, val: provider.salaryType),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.salaryFrom,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        RadioListTileWidget(
            title: JapaneseText.salaryRangeFrom1200,
            onChange: (v) => provider.onChangeSalaryRangeType(JapaneseText.salaryRangeFrom1200),
            size: AppSize.getDeviceWidth(context) * 0.4,
            val: provider.salaryRangeType),
        RadioListTileWidget(
            title: JapaneseText.salaryRangeUnder1200,
            onChange: (v) => provider.onChangeSalaryRangeType(JapaneseText.salaryRangeUnder1200),
            size: AppSize.getDeviceWidth(context) * 0.4,
            val: provider.salaryRangeType),
        RadioListTileWidget(
            title: JapaneseText.salaryRangeFixed1200,
            onChange: (v) => provider.onChangeSalaryRangeType(JapaneseText.salaryRangeFixed1200),
            size: AppSize.getDeviceWidth(context) * 0.4,
            val: provider.salaryRangeType),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.salaryFrom,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 170,
              child: PrimaryTextField(
                controller: provider.fromSalaryAmount,
                hint: '1200',
                isRequired: true,
                isPhoneNumber: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
              child: Center(child: Text("~", style: normalTextStyle)),
            ),
            SizedBox(
              width: 170,
              child: PrimaryTextField(
                controller: provider.toSalaryAmount,
                hint: '20000',
                isRequired: true,
                isPhoneNumber: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 15),
              child: Text("円", style: normalTextStyle),
            ),
          ],
        )
      ],
    );
  }

  supplementaryExplanationExamAndTraining() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.supplementaryExplanationOfSalary,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.supplementary,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.examAndTraining,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTileWidget(
                title: JapaneseText.neither,
                onChange: (v) => provider.onChangeExamAndTraining(JapaneseText.neither),
                size: 130,
                val: provider.examAndTraining),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.trailPeriodYes,
                onChange: (v) => provider.onChangeExamAndTraining(JapaneseText.trailPeriodYes),
                size: 130,
                val: provider.examAndTraining),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.trainingPeriodYes,
                onChange: (v) => provider.onChangeExamAndTraining(JapaneseText.trainingPeriodYes),
                size: 130,
                val: provider.examAndTraining),
            AppSize.spaceWidth16,
            RadioListTileWidget(
                title: JapaneseText.desInTheText,
                onChange: (v) => provider.onChangeExamAndTraining(JapaneseText.desInTheText),
                size: 130,
                val: provider.examAndTraining),
            AppSize.spaceWidth16,
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.eligibilityForApplication,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.eligibilityForApp,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  readOnly: true,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        Text(
          "クリックされると上記枠に追加されます",
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        //1 row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eliItem(eligibilityApplicationList[0]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[1]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[2]),
            AppSize.spaceWidth8,
          ],
        ),
        AppSize.spaceHeight5,
        //2 row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eliItem(eligibilityApplicationList[3]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[4]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[5]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[6]),
          ],
        ),
        AppSize.spaceHeight5,
        //3 row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eliItem(eligibilityApplicationList[7]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[8]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[9]),
            AppSize.spaceWidth8,
          ],
        ),
        AppSize.spaceHeight5,
        //4 row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eliItem(eligibilityApplicationList[10]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[11]),
            AppSize.spaceWidth8,
            eliItem(eligibilityApplicationList[12]),
            AppSize.spaceWidth8,
          ],
        ),
        AppSize.spaceHeight16,
        //Off Hours
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "勤務時間",
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.offHours,
                  hint: '10時〜17時',
                  marginBottom: 5,
                  maxLine: 3,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
      ],
    );
  }

  aboutEmployee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
            AppSize.spaceWidth8,
            Text(
              JapaneseText.aboutEmployee,
              style: titleStyle,
            ),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.workDay,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        //  月 火 水 木 金 土 日
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                title: "月",
                val: provider.mon,
                onChange: (v) {
                  setState(() {
                    provider.mon = v;
                  });
                }),
            checkBoxTile(
                title: "火",
                val: provider.tue,
                onChange: (v) {
                  setState(() {
                    provider.tue = v;
                  });
                }),
            checkBoxTile(
                title: "水",
                val: provider.wed,
                onChange: (v) {
                  setState(() {
                    provider.wed = v;
                  });
                }),
            checkBoxTile(
                title: "木",
                val: provider.thu,
                onChange: (v) {
                  setState(() {
                    provider.thu = v;
                  });
                }),
            checkBoxTile(
                title: "金",
                val: provider.fri,
                onChange: (v) {
                  setState(() {
                    provider.fri = v;
                  });
                }),
            checkBoxTile(
                title: "土",
                val: provider.sat,
                onChange: (v) {
                  setState(() {
                    provider.sat = v;
                  });
                }),
            checkBoxTile(
                title: "日",
                val: provider.sun,
                onChange: (v) {
                  setState(() {
                    provider.sun = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.holidayLeave,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // checkBoxTile(
            //     size: 140,
            //     title: JapaneseText.shiftSystem,
            //     val: provider.shiftSystem,
            //     onChange: (v) {
            //       setState(() {
            //         provider.shiftSystem = v;
            //       });
            //     }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.paidHoliday2,
                val: provider.paidHoliday2,
                onChange: (v) {
                  setState(() {
                    provider.paidHoliday2 = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.summerVacation,
                val: provider.summerVacation,
                onChange: (v) {
                  setState(() {
                    provider.summerVacation = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.winterVacation,
                val: provider.winterVacation,
                onChange: (v) {
                  setState(() {
                    provider.winterVacation = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.nurseCareLeave,
                val: provider.nurseCareLeave,
                onChange: (v) {
                  setState(() {
                    provider.nurseCareLeave = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.childCareLeave,
                val: provider.childCareLeave,
                onChange: (v) {
                  setState(() {
                    provider.childCareLeave = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.prenatalAndPostnatalLeave,
                val: provider.prenatalAndPostnatalLeave,
                onChange: (v) {
                  setState(() {
                    provider.prenatalAndPostnatalLeave = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.accordingToOurCalendar,
                val: provider.accordingToOurCalendar,
                onChange: (v) {
                  setState(() {
                    provider.accordingToOurCalendar = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.sundayAndPublicHoliday,
                val: provider.sundayAndPublicHoliday,
                onChange: (v) {
                  setState(() {
                    provider.sundayAndPublicHoliday = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.fourTwoFiveTwoOff,
                val: provider.fourTwoFiveTwoOff,
                onChange: (v) {
                  setState(() {
                    provider.fourTwoFiveTwoOff = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.remark,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.remarkHoliday,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        //Bonus
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.salaryIncrease,
                val: provider.salaryIncrease,
                onChange: (v) {
                  setState(() {
                    provider.salaryIncrease = v;
                  });
                }),
            const SizedBox(
              width: 60,
            ),
            checkBoxTile(
                size: 140,
                title: JapaneseText.uniform,
                val: provider.uniform,
                onChange: (v) {
                  setState(() {
                    provider.uniform = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.socialInsurance2,
                val: provider.socialInsurance2,
                onChange: (v) {
                  setState(() {
                    provider.socialInsurance2 = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.bonuses,
                val: provider.bonuses,
                onChange: (v) {
                  setState(() {
                    provider.bonuses = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 200,
                title: JapaneseText.mealsAssAvailable,
                val: provider.mealsAssAvailable,
                onChange: (v) {
                  setState(() {
                    provider.mealsAssAvailable = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.companyDiscountAvailable,
                val: provider.companyDiscountAvailable,
                onChange: (v) {
                  setState(() {
                    provider.companyDiscountAvailable = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.employeePromotionAvailable,
                val: provider.employeePromotionAvailable,
                onChange: (v) {
                  setState(() {
                    provider.employeePromotionAvailable = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.qualificationAcqSupportSystem,
                val: provider.qualificationAcqSupportSystem,
                onChange: (v) {
                  setState(() {
                    provider.qualificationAcqSupportSystem = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.overtimeAllowance,
                val: provider.overtimeAllowance,
                onChange: (v) {
                  setState(() {
                    provider.overtimeAllowance = v;
                  });
                }),
            const SizedBox(
              width: 60,
            ),
            checkBoxTile(
                size: 140,
                title: JapaneseText.lateNightAllowance,
                val: provider.lateNightAllowance,
                onChange: (v) {
                  setState(() {
                    provider.lateNightAllowance = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.holidayAllowance,
                val: provider.holidayAllowance,
                onChange: (v) {
                  setState(() {
                    provider.holidayAllowance = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.dormCompanyHouseHousingAllowanceAvailable,
                val: provider.dormCompanyHouseHousingAllowanceAvailable,
                onChange: (v) {
                  setState(() {
                    provider.dormCompanyHouseHousingAllowanceAvailable = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.qualificationAllowance,
                val: provider.qualificationAllowance,
                onChange: (v) {
                  setState(() {
                    provider.qualificationAllowance = v;
                  });
                }),
            const SizedBox(
              width: 60,
            ),
            checkBoxTile(
                size: 140,
                title: JapaneseText.perfectAttendanceAllowance,
                val: provider.perfectAttendanceAllowance,
                onChange: (v) {
                  setState(() {
                    provider.perfectAttendanceAllowance = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.familyAllowance,
                val: provider.familyAllowance,
                onChange: (v) {
                  setState(() {
                    provider.familyAllowance = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.remark,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.remarkBonus,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        //Transport Exp
        Text(
          JapaneseText.transportExpense,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: RadioListTile(
                  activeColor: AppColor.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  groupValue: true,
                  title: Text(
                    JapaneseText.yes,
                    style: normalTextStyle.copyWith(fontSize: 12),
                  ),
                  value: provider.transportExpense,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (v) => provider.onChangeTransportExpense(true)),
            ),
            AppSize.spaceWidth16,
            SizedBox(
              width: 80,
              child: RadioListTile(
                  activeColor: AppColor.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  groupValue: false,
                  title: Text(
                    JapaneseText.no,
                    style: normalTextStyle.copyWith(fontSize: 12),
                  ),
                  value: provider.transportExpense,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (v) => provider.onChangeTransportExpense(false)),
            )
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.remark,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.remarkTransport,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        //work term
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.minimumWorkTerm,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.minimumWorkTerm,
                  hint: '例)3ヶ月以上',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.minimumNumberOfWorkingDays,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.minimumNumberOfWorkingDays,
                  hint: '例)週2日以上',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.minimumNumberOfWorkingTime,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.minimumNumberOfWorkingTime,
                  hint: '例)1日4時間以上',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.shiftCycle,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.shiftCycle,
                  hint: '例)1週間3日',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      JapaneseText.shiftSubPeriod,
                      style: normalTextStyle,
                    ),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.shiftSubPeriod,
                      hint: '例)3ヶ月以上',
                      marginBottom: 5,
                    ),
                  ],
                )),
            AppSize.spaceWidth32,
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      JapaneseText.shiftFixingPeriod,
                      style: normalTextStyle,
                    ),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.shiftFixingPeriod,
                      hint: '例)3ヶ月以上',
                      marginBottom: 5,
                    ),
                  ],
                )),
          ],
        )
      ],
    );
  }

  aboutJobContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
            AppSize.spaceWidth8,
            Text(
              JapaneseText.aboutJobContent,
              style: titleStyle,
            ),
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.overview,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.overview,
                  hint: '',
                  marginBottom: 5,
                  maxLine: 6,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight5,
        InkWell(
          onTap: () async {
            await CompanyApiServices().uploadImageToFirebase(provider);
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 230,
              width: AppSize.getDeviceWidth(context) * 0.55 + 16,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColor.primaryColor),
              ),
              alignment: Alignment.center,
              child: provider.imageUrl.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "診療報酬明細をここにドラッグ&ドロップ",
                          style: normalTextStyle,
                        ),
                        AppSize.spaceHeight16,
                        ButtonWidget(
                          title: "またはファイルを選択する",
                          color: AppColor.primaryColor,
                          onPress: () async {
                            await CompanyApiServices().uploadImageToFirebase(provider);
                          },
                        )
                      ],
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Image.network(
                            provider.imageUrl,
                            fit: BoxFit.cover,
                            width: 230,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                provider.onChangeImageUrl("");
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              )),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        AppSize.spaceHeight8,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.55 + 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(JapaneseText.recruitmentStart, style: normalTextStyle),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.startRecruitDate,
                      hint: '',
                      isRequired: true,
                      onTap: () async {
                        var date = await showDatePicker(
                            locale: const Locale("ja", "JP"),
                            context: context,
                            initialDate:
                                provider.startRecruitDate.text.isNotEmpty ? MyDateTimeUtils.fromApiToLocal(provider.startRecruitDate.text) : now,
                            firstDate:
                                provider.startRecruitDate.text.isNotEmpty ? MyDateTimeUtils.fromApiToLocal(provider.startRecruitDate.text) : now,
                            lastDate: DateTime.now().add(const Duration(days: 3000)));
                        if (date != null) {
                          provider.startRecruitDate.text = MyDateTimeUtils.convertDateToString(date);
                        }
                      },
                    ),
                  ],
                ),
              ),
              AppSize.spaceWidth16,
              const Padding(padding: EdgeInsets.only(top: 35), child: Text("~")),
              AppSize.spaceWidth16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      JapaneseText.end,
                      style: normalTextStyle,
                    ),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.endRecruitDate,
                      hint: '',
                      isRequired: true,
                      onTap: () async {
                        var date = await showDatePicker(
                            locale: const Locale("ja", "JP"),
                            context: context,
                            initialDate: provider.endRecruitDate.text.isNotEmpty ? MyDateTimeUtils.fromApiToLocal(provider.endRecruitDate.text) : now,
                            firstDate:
                                provider.startRecruitDate.text.isNotEmpty ? MyDateTimeUtils.fromApiToLocal(provider.startRecruitDate.text) : now,
                            lastDate: now.add(const Duration(days: 3000)));
                        if (date != null) {
                          provider.endRecruitDate.text = MyDateTimeUtils.convertDateToString(date);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.55 + 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(JapaneseText.location, style: normalTextStyle),
              AppSize.spaceHeight5,
              PrimaryTextField(
                controller: provider.companyLocation,
                hint: '',
                isRequired: true,
              ),
            ],
          ),
        ),
        AppSize.spaceHeight8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.companyLatLng, style: normalTextStyle),
                AppSize.spaceHeight5,
                SizedBox(
                  width: 200,
                  child: PrimaryTextField(
                    controller: provider.companyLocationLatLng,
                    hint: '',
                    isRequired: true,
                  ),
                ),
              ],
            ),
            AppSize.spaceWidth32,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.numberOfPeopleRecruiting, style: normalTextStyle),
                AppSize.spaceHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: PrimaryTextField(
                        controller: provider.numberOfRecruitPeople,
                        hint: '',
                        isRequired: true,
                        isPhoneNumber: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 15),
                      child: Text("人", style: normalTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.occupationAndExp,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.houseWivesHouseHusbandsWelcome,
                val: provider.houseWivesHouseHusbandsWelcome,
                onChange: (v) {
                  setState(() {
                    provider.houseWivesHouseHusbandsWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.partTimeWelcome,
                val: provider.partTimeWelcome,
                onChange: (v) {
                  setState(() {
                    provider.partTimeWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.universityStudentWelcome,
                val: provider.universityStudentWelcome,
                onChange: (v) {
                  setState(() {
                    provider.universityStudentWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.highSchoolStudent,
                val: provider.highSchoolStudent,
                onChange: (v) {
                  setState(() {
                    provider.highSchoolStudent = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.seniorSupport,
                val: provider.seniorSupport,
                onChange: (v) {
                  setState(() {
                    provider.seniorSupport = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.noEducationRequire,
                val: provider.noEducationRequire,
                onChange: (v) {
                  setState(() {
                    provider.noEducationRequire = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.noExpBeginnerIsOk,
                val: provider.noExpBeginnerIsOk,
                onChange: (v) {
                  setState(() {
                    provider.noExpBeginnerIsOk = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.blankOk,
                val: provider.blankOk,
                onChange: (v) {
                  setState(() {
                    provider.blankOk = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.expAndQualifiedPeopleWelcome,
                val: provider.expAndQualifiedPeopleWelcome,
                onChange: (v) {
                  setState(() {
                    provider.expAndQualifiedPeopleWelcome = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        //Shift Day
        Text(
          JapaneseText.shiftDayOfTheWeek,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.shiftSystem,
                val: provider.shiftSystem2,
                onChange: (v) {
                  setState(() {
                    provider.shiftSystem2 = v;
                  });
                }),
            checkBoxTile(
                size: 280,
                title: JapaneseText.youCanChooseTheTimeAndDayOfTheWeek,
                val: provider.youCanChooseTheTimeAndDayOfTheWeek,
                onChange: (v) {
                  setState(() {
                    provider.youCanChooseTheTimeAndDayOfTheWeek = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.onlyOnWeekDayOK,
                val: provider.onlyOnWeekDayOK,
                onChange: (v) {
                  setState(() {
                    provider.onlyOnWeekDayOK = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.satSunHolidayOK,
                val: provider.satSunHolidayOK,
                onChange: (v) {
                  setState(() {
                    provider.satSunHolidayOK = v;
                  });
                }),
            checkBoxTile(
                size: 280,
                title: JapaneseText.fourAndMoreDayAWeekOK,
                val: provider.fourAndMoreDayAWeekOK,
                onChange: (v) {
                  setState(() {
                    provider.fourAndMoreDayAWeekOK = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.singleDayOK,
                val: provider.singleDayOK,
                onChange: (v) {
                  setState(() {
                    provider.singleDayOK = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        //Way of Working
        Text(
          JapaneseText.wayOfWorking,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.sameDayWorkOK,
                val: provider.sameDayWorkOK,
                onChange: (v) {
                  setState(() {
                    provider.sameDayWorkOK = v;
                  });
                }),
            checkBoxTile(
                size: 180,
                title: JapaneseText.fullTimeWelcome,
                val: provider.fullTimeWelcome,
                onChange: (v) {
                  setState(() {
                    provider.fullTimeWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.workDependentsOK,
                val: provider.workDependentsOK,
                onChange: (v) {
                  setState(() {
                    provider.workDependentsOK = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.longTermWelcome,
                val: provider.longTermWelcome,
                onChange: (v) {
                  setState(() {
                    provider.longTermWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.sideJoBDoubleWorkOK,
                val: provider.sideJoBDoubleWorkOK,
                onChange: (v) {
                  setState(() {
                    provider.sideJoBDoubleWorkOK = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        //Commuting Style
        Text(
          JapaneseText.commutingStyle,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.nearOrInsideStation,
                val: provider.nearOrInsideStation,
                onChange: (v) {
                  setState(() {
                    provider.nearOrInsideStation = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.commutingNearByOK,
                val: provider.commutingNearByOK,
                onChange: (v) {
                  setState(() {
                    provider.commutingNearByOK = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.commutingByBikeOK,
                val: provider.commutingByBikeOK,
                onChange: (v) {
                  setState(() {
                    provider.commutingByBikeOK = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 160,
                title: JapaneseText.hairStyleColorFree,
                val: provider.hairStyleColorFree,
                onChange: (v) {
                  setState(() {
                    provider.hairStyleColorFree = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.clothFree,
                val: provider.clothFree,
                onChange: (v) {
                  setState(() {
                    provider.clothFree = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.canApplyWithFri,
                val: provider.canApplyWithFri,
                onChange: (v) {
                  setState(() {
                    provider.canApplyWithFri = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        //Other
        Text(
          JapaneseText.other,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.ovenStaff,
                val: provider.ovenStaff,
                onChange: (v) {
                  setState(() {
                    provider.ovenStaff = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.shortTerm,
                val: provider.shortTerm,
                onChange: (v) {
                  setState(() {
                    provider.shortTerm = v;
                  });
                }),
            checkBoxTile(
                size: 160,
                title: JapaneseText.trainingAvailable,
                val: provider.trainingAvailable,
                onChange: (v) {
                  setState(() {
                    provider.trainingAvailable = v;
                  });
                }),
          ],
        ),
      ],
    );
  }

  workEnvironment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
            AppSize.spaceWidth8,
            Text(
              JapaneseText.workEnvAtmosphere,
              style: titleStyle,
            ),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.areGroup,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 120,
                title: JapaneseText.manyTeenagers,
                val: provider.manyTeenagers,
                onChange: (v) {
                  setState(() {
                    provider.manyTeenagers = v;
                  });
                }),
            checkBoxTile(
                size: 120,
                title: JapaneseText.manyInTheir20,
                val: provider.manyInTheir20,
                onChange: (v) {
                  setState(() {
                    provider.manyInTheir20 = v;
                  });
                }),
            checkBoxTile(
                size: 120,
                title: JapaneseText.manyInTheir30,
                val: provider.manyInTheir30,
                onChange: (v) {
                  setState(() {
                    provider.manyInTheir30 = v;
                  });
                }),
            checkBoxTile(
                size: 120,
                title: JapaneseText.manyInTheir40,
                val: provider.manyInTheir40,
                onChange: (v) {
                  setState(() {
                    provider.manyInTheir40 = v;
                  });
                }),
            checkBoxTile(
                size: 120,
                title: JapaneseText.manyInTheir50,
                val: provider.manyInTheir50,
                onChange: (v) {
                  setState(() {
                    provider.manyInTheir50 = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.genderRatio,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 140,
                title: JapaneseText.manyMen,
                val: provider.manyMen,
                onChange: (v) {
                  setState(() {
                    provider.manyMen = v;
                  });
                }),
            checkBoxTile(
                size: 140,
                title: JapaneseText.manyWomen,
                val: provider.manyWomen,
                onChange: (v) {
                  setState(() {
                    provider.manyWomen = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.atmosphere,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.livelyWorkplace,
                val: provider.livelyWorkplace,
                onChange: (v) {
                  setState(() {
                    provider.livelyWorkplace = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.calmWorkplace,
                val: provider.calmWorkplace,
                onChange: (v) {
                  setState(() {
                    provider.calmWorkplace = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.manyInteractionsOutsideOfWork,
                val: provider.manyInteractionsOutsideOfWork,
                onChange: (v) {
                  setState(() {
                    provider.manyInteractionsOutsideOfWork = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.fewInteractionsOutsideOfWork,
                val: provider.fewInteractionsOutsideOfWork,
                onChange: (v) {
                  setState(() {
                    provider.fewInteractionsOutsideOfWork = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.atHome,
                val: provider.atHome,
                onChange: (v) {
                  setState(() {
                    provider.atHome = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.businessLike,
                val: provider.businessLike,
                onChange: (v) {
                  setState(() {
                    provider.businessLike = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.beginnersAreActivelyWorking,
                val: provider.beginnersAreActivelyWorking,
                onChange: (v) {
                  setState(() {
                    provider.beginnersAreActivelyWorking = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.youCanWorkForAlongTime,
                val: provider.youCanWorkForAlongTime,
                onChange: (v) {
                  setState(() {
                    provider.youCanWorkForAlongTime = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.easyToAdjustToYourConvenience,
                val: provider.easyToAdjustToYourConvenience,
                onChange: (v) {
                  setState(() {
                    provider.easyToAdjustToYourConvenience = v;
                  });
                }),
            checkBoxTile(
                size: 230,
                title: JapaneseText.scheduledTimeExactly,
                val: provider.scheduledTimeExactly,
                onChange: (v) {
                  setState(() {
                    provider.scheduledTimeExactly = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.collaborative,
                val: provider.collaborative,
                onChange: (v) {
                  setState(() {
                    provider.collaborative = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.individualityCanBeUtilized,
                val: provider.individualityCanBeUtilized,
                onChange: (v) {
                  setState(() {
                    provider.individualityCanBeUtilized = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.standingWork,
                val: provider.standingWork,
                onChange: (v) {
                  setState(() {
                    provider.standingWork = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.deskWork,
                val: provider.deskWork,
                onChange: (v) {
                  setState(() {
                    provider.deskWork = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.tooMuchInteractionWithCustomers,
                val: provider.tooMuchInteractionWithCustomers,
                onChange: (v) {
                  setState(() {
                    provider.tooMuchInteractionWithCustomers = v;
                  });
                }),
            checkBoxTile(
                size: 230,
                title: JapaneseText.lessInteractionWithCustomers,
                val: provider.lessInteractionWithCustomers,
                onChange: (v) {
                  setState(() {
                    provider.lessInteractionWithCustomers = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.lotsOfManualLabor,
                val: provider.lotsOfManualLabor,
                onChange: (v) {
                  setState(() {
                    provider.lotsOfManualLabor = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.littleOfManualLabor,
                val: provider.littleOfManualLabor,
                onChange: (v) {
                  setState(() {
                    provider.littleOfManualLabor = v;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 230,
                title: JapaneseText.knowledgeAndExperience,
                val: provider.knowledgeAndExperience,
                onChange: (v) {
                  setState(() {
                    provider.knowledgeAndExperience = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.noKnowledgeOrExperienceRequired,
                val: provider.noKnowledgeOrExperienceRequired,
                onChange: (v) {
                  setState(() {
                    provider.noKnowledgeOrExperienceRequired = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.remark,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.remarkAtmosphere,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.oneDayWorkFlow,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.oneDayWorkFlow,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.shiftIncomeExample,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.shiftIncomeExample,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.aWordFromASeniorStaffMember,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.aWordFromASeniorStaffMember,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
      ],
    );
  }

  aboutApplication() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
            AppSize.spaceWidth8,
            Text(
              JapaneseText.aboutApplication,
              style: titleStyle,
            ),
          ],
        ),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.flowAfterApplication,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.flowAfterApplication,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.plannedNumberOfEmployee,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.plannedNumberOfEmployee,
                  hint: '補足があれば入力してください',
                  marginBottom: 5,
                  maxLine: 6,
                  isRequired: false,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.multiline,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JapaneseText.inquiryPhoneNumber,
                  style: normalTextStyle,
                ),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.inquiryPhoneNumber,
                  hint: '',
                  isRequired: false,
                  isPhoneNumber: true,
                )
              ],
            )),
        AppSize.spaceHeight16,
        const Divider(),
        AppSize.spaceHeight16,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
            AppSize.spaceWidth8,
            Text(
              JapaneseText.regardingInputItemsOnTheApplicationScreen,
              style: titleStyle,
            ),
          ],
        ),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.informationToObtain,
          style: normalTextStyle,
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              child: RadioListTile(
                  activeColor: AppColor.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  groupValue: true,
                  title: Text(
                    JapaneseText.getOnlyBasicInformation,
                    style: normalTextStyle.copyWith(fontSize: 12),
                  ),
                  value: provider.informationToObtain == JapaneseText.getOnlyBasicInformation,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (v) => provider.onChangeInformationToObtain(JapaneseText.getOnlyBasicInformation)),
            ),
            AppSize.spaceWidth16,
            SizedBox(
              width: 220,
              child: RadioListTile(
                  activeColor: AppColor.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  groupValue: false,
                  title: Text(
                    JapaneseText.obtainEducationalBackground,
                    style: normalTextStyle.copyWith(fontSize: 12),
                  ),
                  value: provider.informationToObtain != JapaneseText.obtainEducationalBackground,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (v) => provider.onChangeInformationToObtain(JapaneseText.obtainEducationalBackground)),
            )
          ],
        )
      ],
    );
  }

  checkBoxTile({required String title, required bool val, required Function onChange, double size = 80}) {
    return SizedBox(
      width: size,
      child: CheckboxListTile(
        value: val,
        dense: true,
        contentPadding: EdgeInsets.zero,
        activeColor: AppColor.primaryColor,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (v) => onChange(v),
        title: Text(
          title,
          style: normalTextStyle,
        ),
      ),
    );
  }

  eliItem(String title) {
    return InkWell(
      onTap: () {
        if (provider.eligibilityForApp.text.contains(title)) {
          if (provider.eligibilityForApp.text.split(", ")[0] == title) {
            setState(() {
              provider.eligibilityForApp.text = provider.eligibilityForApp.text.replaceAll(title, "");
            });
          } else {
            setState(() {
              provider.eligibilityForApp.text = provider.eligibilityForApp.text.replaceAll(", $title", "");
            });
          }
        } else {
          if (provider.eligibilityForApp.text.isEmpty) {
            setState(() {
              provider.eligibilityForApp.text = title;
            });
          } else {
            setState(() {
              provider.eligibilityForApp.text += ", $title";
            });
          }
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: provider.eligibilityForApp.text.contains(title) ? AppColor.primaryColor.withOpacity(0.5) : Colors.white,
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: Text(title),
      ),
    );
  }

  chooseOccupation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.occupationMajor,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            CustomDropDownWidget(
              list: provider.occupationList.map((e) => e.toString()).toList(),
              onChange: (e) => provider.onChangeOccupation(e),
              width: AppSize.getDeviceWidth(context) * 0.3,
              selectItem: provider.selectedOccupation,
            )
          ],
        ),
        AppSize.spaceWidth32,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JapaneseText.occupationSmallItem,
              style: normalTextStyle,
            ),
            AppSize.spaceHeight5,
            CustomDropDownWidget(
              list: provider.occupationList.map((e) => e.toString()).toList(),
              onChange: (e) => provider.onChangeOccupation(e),
              width: AppSize.getDeviceWidth(context) * 0.3,
              selectItem: provider.selectedOccupation,
            )
          ],
        ),
      ],
    );
  }

  clearAllText() {}

  titleWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 60,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            JapaneseText.applicantSearch + " (Japanese)",
            style: titleStyle,
          ),
          IconButton(splashRadius: 30, onPressed: () => context.pop(), icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
