class SearchJob {
  String? uid;
  DateTime? createdAt;
  String? status;
  String? fee;
  String? company;
  String? companyId;
  String? workCatchPhrase;
  String? description;
  String? content;
  String? startDate;
  String? endDate;
  String? image;
  Locations? location;
  String? numberOfRecruit;
  String? occupationType;
  bool? occupation;
  bool? employmentContractProvisioning;
  String? employmentType;
  bool? trailPeriod;
  String? salaryType;
  String? startTimeHour;
  String? endTimeHour;
  String? breakTimeAsMinute;
  bool? bonus;
  bool? offHour;
  bool? raise;
  bool? paidHoliday;
  String? annualHoliday;
  String? holidayDetail;
  bool? dormOrCompanyHouse;
  bool? wifi;
  bool? meals;
  bool? transportExpense;
  bool? isRemoteInterview;
  Locations? interviewLocation;
  List<String>? contentOfTheTest;
  List<String>? statusOfResidence;
  String? otherQualification;
  List<String>? hotelCleaningLearningItem;
  String? desiredGender;
  String? desiredNationality;
  String? necessaryJapanSkill;
  String? remarkOfRequirement;
  String? socialInsurance;
  bool? childCareLeaveSystem;
  bool? retirementSystem;
  bool? rehire;
  bool? severancePay;
  String? title;
  List<Review>? reviews;
  bool? employment;
  bool? industrialAccident;
  bool? health;
  bool? publicWelfare;
  String? form;

  //Add More for Japanese
  String? salaryRange;
  String? amountOfPayrollFrom;
  String? amountOfPayrollTo;
  String? supplementaryExplanationOfSalary;
  String? examinationOfTraining;
  String? eligibilityForApplication;
  String? offHours;

  //Work Day
  bool? mon;
  bool? tue;
  bool? wed;
  bool? thu;
  bool? fri;
  bool? sat;
  bool? sun;

  //Holiday
  String? holidayRemark;
  bool? shiftSystem;
  bool? paidHoliday2;
  bool? summerVacation;
  bool? winterVacation;
  bool? nurseCareLeave;
  bool? childCareLeave;
  bool? prenatalAndPostnatalLeave;
  bool? accordingToOurCalendar;
  bool? sundayAndPublicHoliday;
  bool? fourTwoFiveTwoOff;

  //Bonus
  String? bonusRemark;
  bool? salaryIncrease;
  bool? uniform;
  bool? socialInsurance2;
  bool? bonuses;

  bool? mealsAssAvailable;
  bool? companyDiscountAvailable;
  bool? employeePromotionAvailable;
  bool? qualificationAcqSupportSystem;

  bool? overtimeAllowance;
  bool? lateNightAllowance;
  bool? holidayAllowance;
  bool? dormCompanyHouseHousingAllowanceAvailable;

  bool? qualificationAllowance;
  bool? perfectAttendanceAllowance;
  bool? familyAllowance;

  String? transportRemark;
  String? minimumWorkTerm;
  String? minimumNumberOfWorkingDays;
  String? minimumNumberOfWorkingTime;
  String? shiftCycle;
  String? shiftSubPeriod;
  String? shiftFixingPeriod;

  //Occupation Exp
  bool? houseWivesHouseHusbandsWelcome;
  bool? partTimeWelcome;
  bool? universityStudentWelcome;
  bool? highSchoolStudent;
  bool? seniorSupport;
  bool? noEducationRequire;
  bool? noExpBeginnerIsOk;
  bool? blankOk;
  bool? expAndQualifiedPeopleWelcome;

  //Shift day of the week
  bool? shiftSystem2;
  bool? youCanChooseTheTimeAndDayOfTheWeek;
  bool? onlyOnWeekDayOK;
  bool? satSunHolidayOK;
  bool? fourAndMoreDayAWeekOK;
  bool? singleDayOK;

  //how to work
  bool? sameDayWorkOK;
  bool? fullTimeWelcome;
  bool? workDependentsOK;
  bool? longTermWelcome;
  bool? sideJoBDoubleWorkOK;

  //commuting style
  bool? nearOrInsideStation;
  bool? commutingNearByOK;
  bool? commutingByBikeOK;
  bool? hairStyleColorFree;
  bool? clothFree;
  bool? canApplyWithFri;

  bool? ovenStaff;
  bool? shortTerm;
  bool? trainingAvailable;

  //Work Env
  //age range
  bool? manyTeenagers;
  bool? manyInTheir20;
  bool? manyInTheir30;
  bool? manyInTheir40;
  bool? manyInTheir50;

  bool? manyMen;
  bool? manyWomen;

  //Atmosphere
  String? atmosphereRemark;
  bool? livelyWorkplace;
  bool? calmWorkplace;
  bool? manyInteractionsOutsideOfWork;
  bool? fewInteractionsOutsideOfWork;
  bool? atHome;
  bool? businessLike;
  bool? beginnersAreActivelyWorking;
  bool? youCanWorkForAlongTime;
  bool? easyToAdjustToYourConvenience;
  bool? scheduledTimeExactly;
  bool? collaborative;
  bool? individualityCanBeUtilized;
  bool? standingWork;
  bool? deskWork;
  bool? tooMuchInteractionWithCustomers;
  bool? lessInteractionWithCustomers;
  bool? lotsOfManualLabor;
  bool? littleOfManualLabor;
  bool? knowledgeAndExperience;
  bool? noKnowledgeOrExperienceRequired;

  String? dailyWorkFlow;
  String? exampleOfShiftAndIncome;
  String? messageFromSeniorStaff;

  //About Application
  String? applicationProcess;
  String? expectedNumberOfRecruits;
  String? phoneNumber;

  String? infoToBeObtains;

  //favorite status
  bool? favorite;

  SearchJob(
      {this.favorite = false,
      this.status,
      this.fee,
      this.company,
      this.companyId,
      this.workCatchPhrase,
      this.description,
      this.content,
      this.startDate,
      this.endDate,
      this.image,
      this.location,
      this.numberOfRecruit,
      this.occupationType,
      this.occupation,
      this.employmentContractProvisioning,
      this.employmentType,
      this.trailPeriod,
      this.salaryType,
      this.startTimeHour,
      this.endTimeHour,
      this.breakTimeAsMinute,
      this.bonus,
      this.offHour,
      this.raise,
      this.paidHoliday,
      this.annualHoliday,
      this.holidayDetail,
      this.dormOrCompanyHouse,
      this.wifi,
      this.meals,
      this.transportExpense,
      this.isRemoteInterview,
      this.interviewLocation,
      this.contentOfTheTest,
      this.statusOfResidence,
      this.otherQualification,
      this.hotelCleaningLearningItem,
      this.desiredGender,
      this.desiredNationality,
      this.necessaryJapanSkill,
      this.remarkOfRequirement,
      this.socialInsurance,
      this.childCareLeaveSystem,
      this.retirementSystem,
      this.rehire,
      this.severancePay,
      this.title,
      this.reviews,
      this.uid,
      this.employment,
      this.health,
      this.industrialAccident,
      this.publicWelfare,
      this.form,
      this.mon,
      this.offHours,
      this.eligibilityForApplication,
      this.supplementaryExplanationOfSalary,
      this.phoneNumber,
      this.tue,
      this.accordingToOurCalendar,
      this.amountOfPayrollFrom,
      this.wed,
      this.amountOfPayrollTo,
      this.applicationProcess,
      this.atHome,
      this.atmosphereRemark,
      this.beginnersAreActivelyWorking,
      this.blankOk,
      this.bonuses,
      this.bonusRemark,
      this.businessLike,
      this.calmWorkplace,
      this.canApplyWithFri,
      this.childCareLeave,
      this.clothFree,
      this.collaborative,
      this.commutingByBikeOK,
      this.commutingNearByOK,
      this.companyDiscountAvailable,
      this.dailyWorkFlow,
      this.deskWork,
      this.dormCompanyHouseHousingAllowanceAvailable,
      this.easyToAdjustToYourConvenience,
      this.employeePromotionAvailable,
      this.examinationOfTraining,
      this.exampleOfShiftAndIncome,
      this.expAndQualifiedPeopleWelcome,
      this.expectedNumberOfRecruits,
      this.familyAllowance,
      this.fewInteractionsOutsideOfWork,
      this.fourAndMoreDayAWeekOK,
      this.fourTwoFiveTwoOff,
      this.fri,
      this.fullTimeWelcome,
      this.hairStyleColorFree,
      this.highSchoolStudent,
      this.holidayAllowance,
      this.holidayRemark,
      this.houseWivesHouseHusbandsWelcome,
      this.individualityCanBeUtilized,
      this.infoToBeObtains,
      this.knowledgeAndExperience,
      this.lateNightAllowance,
      this.lessInteractionWithCustomers,
      this.littleOfManualLabor,
      this.livelyWorkplace,
      this.longTermWelcome,
      this.lotsOfManualLabor,
      this.manyInteractionsOutsideOfWork,
      this.manyInTheir20,
      this.manyInTheir30,
      this.manyInTheir40,
      this.manyInTheir50,
      this.manyMen,
      this.manyTeenagers,
      this.manyWomen,
      this.mealsAssAvailable,
      this.messageFromSeniorStaff,
      this.minimumNumberOfWorkingDays,
      this.minimumNumberOfWorkingTime,
      this.minimumWorkTerm,
      this.nearOrInsideStation,
      this.noEducationRequire,
      this.noExpBeginnerIsOk,
      this.noKnowledgeOrExperienceRequired,
      this.nurseCareLeave,
      this.onlyOnWeekDayOK,
      this.ovenStaff,
      this.overtimeAllowance,
      this.paidHoliday2,
      this.partTimeWelcome,
      this.perfectAttendanceAllowance,
      this.prenatalAndPostnatalLeave,
      this.qualificationAcqSupportSystem,
      this.qualificationAllowance,
      this.salaryIncrease,
      this.salaryRange,
      this.sameDayWorkOK,
      this.sat,
      this.satSunHolidayOK,
      this.scheduledTimeExactly,
      this.seniorSupport,
      this.shiftCycle,
      this.shiftFixingPeriod,
      this.shiftSubPeriod,
      this.shiftSystem,
      this.shiftSystem2,
      this.shortTerm,
      this.sideJoBDoubleWorkOK,
      this.singleDayOK,
      this.socialInsurance2,
      this.standingWork,
      this.summerVacation,
      this.sun,
      this.sundayAndPublicHoliday,
      this.thu,
      this.tooMuchInteractionWithCustomers,
      this.trainingAvailable,
      this.transportRemark,
      this.uniform,
      this.universityStudentWelcome,
      this.winterVacation,
      this.workDependentsOK,
      this.youCanChooseTheTimeAndDayOfTheWeek,
      this.youCanWorkForAlongTime,
      this.createdAt});

  factory SearchJob.fromJson(Map<String, dynamic> json) => SearchJob(
        favorite: json["favorite"],
        createdAt:
            json["created_at"] != null ? json["created_at"].toDate() : null,
        form: json["form"],
        employment: json["employment"],
        industrialAccident: json["industrial_accident"],
        health: json["health"],
        publicWelfare: json["public_welfare"],
        status: json["status"],
        company: json["company"],
        companyId: json["company_id"],
        workCatchPhrase: json["work_catch_phrase"],
        description: json["description"],
        content: json["content"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        image: json["image"],
        location: json["location"] == null
            ? null
            : Locations.fromJson(json["location"]),
        numberOfRecruit: json["number_of_recruit"],
        occupationType: json["occupation_type"],
        occupation: json["occupation"],
        employmentContractProvisioning:
            json["employment_contract_provisioning"],
        employmentType: json["employment_type"],
        trailPeriod: json["trail_period"],
        salaryType: json["salary_type"],
        startTimeHour: json["start_time_hour"],
        endTimeHour: json["end_time_hour"],
        breakTimeAsMinute: json["break_time_as_minute"],
        bonus: json["bonus"],
        offHour: json["off_hour"],
        raise: json["raise"],
        paidHoliday: json["paid_holiday"],
        annualHoliday: json["annual_holiday"],
        holidayDetail: json["holiday_detail"],
        dormOrCompanyHouse: json["dorm_or_company_house"],
        wifi: json["wifi"],
        meals: json["meals"],
        transportExpense: json["transport_expense"],
        isRemoteInterview: json["is_remote_interview"],
        interviewLocation: json["interview_location"] == null
            ? null
            : Locations.fromJson(json["interview_location"]),
        contentOfTheTest: json["content_of_the_test"] != null
            ? List<String>.from(json["content_of_the_test"].map((e) => e))
            : [],
        statusOfResidence: json["status_of_residence"] != null
            ? List<String>.from(json["status_of_residence"].map((e) => e))
            : [],
        otherQualification: json["other_qualification"],
        hotelCleaningLearningItem: json["hotel_cleaning_learning_item"] != null
            ? List<String>.from(
                json["hotel_cleaning_learning_item"].map((e) => e))
            : [],
        desiredGender: json["desired_gender"],
        desiredNationality: json["desired_nationality"],
        necessaryJapanSkill: json["necessary_japan_skill"],
        remarkOfRequirement: json["remark_of_requirement"],
        socialInsurance: json["social_insurance"],
        childCareLeaveSystem: json["child_care_leave_system"],
        retirementSystem: json["retirement_system"],
        rehire: json["rehire"],
        severancePay: json["severance_pay"],
        title: json["title"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        salaryRange: json["salaryRange"] ?? "",
        amountOfPayrollFrom: json["amountOfPayrollFrom"] ?? "",
        amountOfPayrollTo: json["amountOfPayrollTo"] ?? "",
        supplementaryExplanationOfSalary:
            json["supplementaryExplanationOfSalary"] ?? "",
        examinationOfTraining: json["examinationOfTraining"] ?? "",
        eligibilityForApplication: json["eligibilityForApplication"] ?? "",
        offHours: json["offHours"] ?? "",
        mon: json["work_day_mon"] ?? false,
        tue: json["work_day_tue"] ?? false,
        wed: json["work_day_wed"] ?? false,
        thu: json["work_day_thu"] ?? false,
        fri: json["work_day_fri"] ?? false,
        sat: json["work_day_sat"] ?? false,
        sun: json["work_day_sun"] ?? false,
        holidayRemark: json["holidayRemark"] ?? "",
        shiftSystem: json["holiday_shiftSystem"] ?? false,
        paidHoliday2: json["holiday_paidHoliday2"] ?? false,
        summerVacation: json["holiday_summerVacation"] ?? false,
        winterVacation: json["holiday_winterVacation"] ?? false,
        nurseCareLeave: json["holiday_nurseCareLeave"] ?? false,
        childCareLeave: json["holiday_childCareLeave"] ?? false,
        prenatalAndPostnatalLeave:
            json["holiday_prenatalAndPostnatalLeave"] ?? false,
        accordingToOurCalendar: json["holiday_accordingToOurCalendar"] ?? false,
        sundayAndPublicHoliday: json["holiday_sundayAndPublicHoliday"] ?? false,
        fourTwoFiveTwoOff: json["holiday_fourTwoFiveTwoOff"] ?? false,
        bonusRemark: json["bonusRemark"] ?? "",
        salaryIncrease: json["bonus_salaryIncrease"] ?? false,
        uniform: json["bonus_uniform"] ?? false,
        socialInsurance2: json["bonus_socialInsurance2"] ?? false,
        bonuses: json["bonus_bonuses"] ?? false,
        mealsAssAvailable: json["bonus_mealsAssAvailable"] ?? false,
        companyDiscountAvailable:
            json["bonus_companyDiscountAvailable"] ?? false,
        employeePromotionAvailable:
            json["bonus_employeePromotionAvailable"] ?? false,
        qualificationAcqSupportSystem:
            json["bonus_qualificationAcqSupportSystem"] ?? false,
        overtimeAllowance: json["bonus_overtimeAllowance"] ?? false,
        lateNightAllowance: json["bonus_lateNightAllowance"] ?? false,
        holidayAllowance: json["bonus_holidayAllowance"] ?? false,
        dormCompanyHouseHousingAllowanceAvailable:
            json["bonus_dormCompanyHouseHousingAllowanceAvailable"] ?? false,
        qualificationAllowance: json["bonus_qualificationAllowance"] ?? false,
        perfectAttendanceAllowance:
            json["bonus_perfectAttendanceAllowance"] ?? false,
        familyAllowance: json["bonus_familyAllowance"] ?? false,
        transportRemark: json["transportRemark"] ?? "",
        minimumWorkTerm: json["minimumWorkTerm"] ?? "",
        minimumNumberOfWorkingDays: json["minimumNumberOfWorkingDays"] ?? "",
        minimumNumberOfWorkingTime: json["minimumNumberOfWorkingTime"] ?? "",
        shiftCycle: json["shiftCycle"] ?? "",
        shiftSubPeriod: json["shiftSubPeriod"] ?? "",
        shiftFixingPeriod: json["shiftFixingPeriod"] ?? "",
        houseWivesHouseHusbandsWelcome:
            json["occ_exp_WivesHouseHusbandsWelcome"] ?? false,
        partTimeWelcome: json["occ_exp_partTimeWelcome"] ?? false,
        universityStudentWelcome:
            json["occ_exp_universityStudentWelcome"] ?? false,
        highSchoolStudent: json["occ_exp_highSchoolStudent"] ?? false,
        seniorSupport: json["occ_exp_seniorSupport"] ?? false,
        noEducationRequire: json["occ_exp_noEducationRequire"] ?? false,
        noExpBeginnerIsOk: json["occ_exp_noExpBeginnerIsOk"] ?? false,
        blankOk: json["occ_exp_blankOk"] ?? false,
        expAndQualifiedPeopleWelcome:
            json["occ_exp_expAndQualifiedPeopleWelcome"] ?? false,
        shiftSystem2: json["shift_shiftSystem2"] ?? false,
        youCanChooseTheTimeAndDayOfTheWeek:
            json["shift_youCanChooseTheTimeAndDayOfTheWeek"] ?? false,
        onlyOnWeekDayOK: json["shift_onlyOnWeekDayOK"] ?? false,
        satSunHolidayOK: json["shift_satSunHolidayOK"] ?? false,
        fourAndMoreDayAWeekOK: json["shift_fourAndMoreDayAWeekOK"] ?? false,
        singleDayOK: json["shift_singleDayOK"] ?? false,
        sameDayWorkOK: json["how_to_work_sameDayWorkOK"] ?? false,
        fullTimeWelcome: json["how_to_work_fullTimeWelcome"] ?? false,
        workDependentsOK: json["how_to_work_workDependentsOK"] ?? false,
        longTermWelcome: json["how_to_work_longTermWelcome"] ?? false,
        sideJoBDoubleWorkOK: json["how_to_work_sideJoBDoubleWorkOK"] ?? false,
        nearOrInsideStation: json["commute_nearOrInsideStation"] ?? false,
        commutingNearByOK: json["commute_commutingNearByOK"] ?? false,
        commutingByBikeOK: json["commute_commutingByBikeOK"] ?? false,
        hairStyleColorFree: json["commute_hairStyleColorFree"] ?? false,
        clothFree: json["commute_clothFree"] ?? false,
        canApplyWithFri: json["commute_canApplyWithFri"] ?? false,
        ovenStaff: json["commute_ovenStaff"] ?? false,
        shortTerm: json["commute_shortTerm"] ?? false,
        trainingAvailable: json["commute_trainingAvailable"] ?? false,
        manyTeenagers: json["manyTeenagers"] ?? false,
        manyInTheir20: json["manyInTheir20"] ?? false,
        manyInTheir30: json["manyInTheir30"] ?? false,
        manyInTheir40: json["manyInTheir40"] ?? false,
        manyInTheir50: json["manyInTheir50"] ?? false,
        manyMen: json["manyMen"] ?? false,
        manyWomen: json["manyWomen"] ?? false,
        atmosphereRemark: json["atmosphereRemark"] ?? "",
        livelyWorkplace: json["atmosphere_livelyWorkplace"] ?? false,
        calmWorkplace: json["atmosphere_calmWorkplace"] ?? false,
        manyInteractionsOutsideOfWork:
            json["atmosphere_manyInteractionsOutsideOfWork"] ?? false,
        fewInteractionsOutsideOfWork:
            json["atmosphere_fewInteractionsOutsideOfWork"] ?? false,
        atHome: json["atmosphere_atHome"] ?? false,
        businessLike: json["atmosphere_businessLike"] ?? false,
        beginnersAreActivelyWorking:
            json["atmosphere_beginnersAreActivelyWorking"] ?? false,
        youCanWorkForAlongTime:
            json["atmosphere_youCanWorkForAlongTime"] ?? false,
        easyToAdjustToYourConvenience:
            json["atmosphere_easyToAdjustToYourConvenience"] ?? false,
        scheduledTimeExactly: json["atmosphere_scheduledTimeExactly"] ?? false,
        collaborative: json["atmosphere_collaborative"] ?? false,
        individualityCanBeUtilized:
            json["atmosphere_individualityCanBeUtilized"] ?? false,
        standingWork: json["atmosphere_standingWork"] ?? false,
        deskWork: json["atmosphere_deskWork"] ?? false,
        tooMuchInteractionWithCustomers:
            json["atmosphere_tooMuchInteractionWithCustomers"] ?? false,
        lessInteractionWithCustomers:
            json["atmosphere_lessInteractionWithCustomers"] ?? false,
        lotsOfManualLabor: json["atmosphere_lotsOfManualLabor"] ?? false,
        littleOfManualLabor: json["atmosphere_littleOfManualLabor"] ?? false,
        knowledgeAndExperience:
            json["atmosphere_knowledgeAndExperience"] ?? false,
        noKnowledgeOrExperienceRequired:
            json["atmosphere_noKnowledgeOrExperienceRequired"] ?? false,
        dailyWorkFlow: json["dailyWorkFlow"] ?? "",
        exampleOfShiftAndIncome: json["exampleOfShiftAndIncome"] ?? "",
        messageFromSeniorStaff: json["messageFromSeniorStaff"] ?? "",
        applicationProcess: json["applicationProcess"] ?? "",
        expectedNumberOfRecruits: json["expectedNumberOfRecruits"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        infoToBeObtains: json["infoToBeObtains"] ?? "",
      );
}

class Locations {
  String? des;
  String? lat;
  String? lng;
  String? name;
  Locations({
    this.des,
    this.lat,
    this.lng,
    this.name,
  });
  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      des: json["des"].toString(),
      lat: json["lat"].toString(),
      lng: json["lng"].toString(),
      name: json["name"].toString(),
    );
  }
}

class Review {
  String? comment;
  String? id;
  String? name;
  String? rate;
  Review({
    this.comment,
    this.id,
    this.name,
    this.rate,
  });
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      comment: json["comment"].toString(),
      id: json["id"].toString(),
      name: json["name"].toString(),
      rate: json["rate"].toString(),
    );
  }
}
