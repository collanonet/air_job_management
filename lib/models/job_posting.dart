class JobPosting {
  String? uid;
  String? status;
  String? company;
  String? companyId;
  String? workCatchPhrase;
  String? description;
  String? access;
  String? startDate;
  String? endDate;
  String? image;
  Location? location;
  String? numberOfRecruit;
  String? occupationType;
  String? occupation;
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
  String? transportExpense;
  bool? isRemoteInterview;
  Location? interviewLocation;
  String? contentOfTheTest;
  String? statusOfResidence;
  String? otherQualification;
  String? hotelCleaningLearningItem;
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

  JobPosting(
      {this.status,
      this.company,
      this.companyId,
      this.workCatchPhrase,
      this.description,
      this.access,
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
      this.uid});

  factory JobPosting.fromJson(Map<String, dynamic> json) => JobPosting(
        status: json["status"],
        company: json["company"],
        companyId: json["company_id"],
        workCatchPhrase: json["work_catch_phrase"],
        description: json["description"],
        access: json["access"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        image: json["image"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
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
            : Location.fromJson(json["interview_location"]),
        contentOfTheTest: json["content_of_the_test"],
        statusOfResidence: json["status_of_residence"],
        otherQualification: json["other_qualification"],
        hotelCleaningLearningItem: json["hotel_cleaning_learning_item"],
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
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "company": company,
        "company_id": companyId,
        "work_catch_phrase": workCatchPhrase,
        "description": description,
        "access": access,
        "start_date": startDate,
        "end_date": endDate,
        "image": image,
        "location": location?.toJson(),
        "number_of_recruit": numberOfRecruit,
        "occupation_type": occupationType,
        "occupation": occupation,
        "employment_contract_provisioning": employmentContractProvisioning,
        "employment_type": employmentType,
        "trail_period": trailPeriod,
        "salary_type": salaryType,
        "start_time_hour": startTimeHour,
        "end_time_hour": endTimeHour,
        "break_time_as_minute": breakTimeAsMinute,
        "bonus": bonus,
        "off_hour": offHour,
        "raise": raise,
        "paid_holiday": paidHoliday,
        "annual_holiday": annualHoliday,
        "holiday_detail": holidayDetail,
        "dorm_or_company_house": dormOrCompanyHouse,
        "wifi": wifi,
        "meals": meals,
        "transport_expense": transportExpense,
        "is_remote_interview": isRemoteInterview,
        "interview_location": interviewLocation?.toJson(),
        "content_of_the_test": contentOfTheTest,
        "status_of_residence": statusOfResidence,
        "other_qualification": otherQualification,
        "hotel_cleaning_learning_item": hotelCleaningLearningItem,
        "desired_gender": desiredGender,
        "desired_nationality": desiredNationality,
        "necessary_japan_skill": necessaryJapanSkill,
        "remark_of_requirement": remarkOfRequirement,
        "social_insurance": socialInsurance,
        "child_care_leave_system": childCareLeaveSystem,
        "retirement_system": retirementSystem,
        "rehire": rehire,
        "severance_pay": severancePay,
        "title": title,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Location {
  String? des;
  String? lat;
  String? lng;
  String? name;

  Location({
    this.des,
    this.lat,
    this.lng,
    this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        des: json["des"],
        lat: json["lat"],
        lng: json["lng"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "des": des,
        "lat": lat,
        "lng": lng,
        "name": name,
      };
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

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        comment: json["comment"],
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "id": id,
        "name": name,
        "rate": rate,
      };
}
