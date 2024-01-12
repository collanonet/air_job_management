import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

import '../api/company.dart';
import '../models/company.dart';
import '../utils/date_time_utils.dart';

class JobPostingProvider with ChangeNotifier {
  //For Job Posting List
  List<JobPosting> jobPostingList = [];
  List<String> statusList = [
    JapaneseText.allData,
    JapaneseText.duringCorrespondence,
    JapaneseText.end
  ];

  String? selectedStatus;
  DateTime? startDateForFilter;
  DateTime? endDateForFilter;

  List<String> newArrivalList = [
    JapaneseText.allData,
    JapaneseText.newArrival,
    JapaneseText.interview
  ];
  String? selectedNewArrival;

  //For Job Posting Detail
  JobPosting? jobPosting;
  List<Company> allCompany = [];
  String? selectedCompany;
  String? selectedCompanyId;
  String imageUrl = "";

  bool isLoading = false;

  late TextEditingController title;
  late TextEditingController overview;
  late TextEditingController content;
  late TextEditingController startRecruitDate;
  late TextEditingController endRecruitDate;
  late TextEditingController companyLocation;
  late TextEditingController companyLocationLatLng;
  late TextEditingController numberOfRecruitPeople;
  late TextEditingController breakTimeMinute;
  late TextEditingController startWorkTime;
  late TextEditingController endWorkTime;
  late TextEditingController numberOfAnnualHolidays;
  late TextEditingController holidayDetail;
  late TextEditingController interviewLocation;
  late TextEditingController interviewLocationLatLng;
  late TextEditingController otherQualification;
  late TextEditingController remark;

  String? selectedOccupation;
  bool chooseOccupationSkill = false;

  List<String> occupationList = [
    JapaneseText.constructionWorker,
    JapaneseText.worker,
    JapaneseText.teacher,
    JapaneseText.hotelStaff,
    JapaneseText.barista
  ];

  String? selectedEmploymentType;
  String contractProvisioning = JapaneseText.no;
  List<String> employmentType = [
    EmploymentStatus.part,
    EmploymentStatus.contract,
    EmploymentStatus.fullTime,
    EmploymentStatus.partTime,
  ];

  String salaryType = JapaneseText.monthlySalary;
  bool trailPeriod = false;
  bool bonus = false;
  bool raise = false;
  bool offHour = false;
  bool paidHoliday = false;
  bool wifi = false;
  bool dorm = false;
  bool meals = false;
  bool transportExpense = false;

  bool isThereRemoteInterview = false;

  DateTime? startTime;
  DateTime? endTime;

  List<String> contentOfTestStaff = [
    JapaneseText.entrySheet,
    JapaneseText.cv,
    JapaneseText.interview,
    JapaneseText.appropriateTest,
    JapaneseText.writtenTest,
  ];

  List<String> contentOfTestPartTimeStaff = [
    JapaneseText.cv,
    JapaneseText.interview,
  ];

  List<String> selectedContentOfTest = [
    JapaneseText.cv,
    JapaneseText.interview,
  ];

  List<String> statusOfRecident = [
    JapaneseText.diplomat,
    JapaneseText.public,
    JapaneseText.professional,
    JapaneseText.art,
    JapaneseText.religion,
    JapaneseText.newsCoverage,
  ];

  List<String> selectedStatusOfRecident = [
    JapaneseText.diplomat,
    JapaneseText.public,
  ];

  List<String> hotelCleaningItemLearn = [
    JapaneseText.bedMaking,
    JapaneseText.bathRoomCleaning,
  ];

  List<String> selectedHotelCleaningItemLearn = [];

  String selectedDesiredGender = JapaneseText.bothGender;
  List<String> nationalityList = [
    "Japanese",
    "Cambodian",
    "Vietnamese",
    "Thai",
    "Singapour"
  ];
  String? selectedNationality;

  List<String> necessaryJapanSkillList = [
    JapaneseText.notRequire,
    JapaneseText.native,
    JapaneseText.good,
    JapaneseText.normal,
    JapaneseText.poor,
  ];
  String? selectedNecessaryJapanSkill;

  bool isEmployment = false;
  bool isIndustrialAccident = false;
  bool isHealth = false;
  bool isWelfare = false;

  bool isChildCareSystem = false;
  bool isRetirementSystem = false;
  bool isReemployment = false;
  bool isRetirementBenefits = false;

  onFilterData() async {
    jobPostingList = await JobPostingApiService().getAllJobPost();
    List<JobPosting> filteredJobByStatus = [];
    if (selectedStatus == statusList[0]) {
      filteredJobByStatus = jobPostingList;
    } else {
      for (var job in jobPostingList) {
        DateTime now = DateTime.now();
        DateTime endDate =
            MyDateTimeUtils.fromApiToLocal(job.endDate ?? job.startDate!);
        String status = endDate.isBefore(now)
            ? JapaneseText.end
            : JapaneseText.duringCorrespondence;
        if (selectedStatus == status) {
          filteredJobByStatus.add(job);
        } else if (selectedStatus == status) {
          filteredJobByStatus.add(job);
        }
      }
    }
    List<JobPosting> filteredJobByDate = [];
    if (startDateForFilter != null && endDateForFilter != null) {
      for (var job in filteredJobByStatus) {
        if (job.startDate != null && job.endDate != null) {
          DateTime startDate = MyDateTimeUtils.fromApiToLocal(job.startDate!);
          DateTime endDate = MyDateTimeUtils.fromApiToLocal(job.endDate!);
          final isInRange = isBetweenRangeDates(
              startDateForFilter!, endDateForFilter!, startDate, endDate);
          if (isInRange) {
            filteredJobByDate.add(job);
          }
        } else if (job.startDate != null) {
          DateTime startDate = MyDateTimeUtils.fromApiToLocal(job.startDate!);
          final isInRange = isDateWithinRangeDates(
              startDate, startDateForFilter!, endDateForFilter!);
          if (isInRange) {
            filteredJobByDate.add(job);
          }
        } else if (job.endDate != null) {
          DateTime endDate = MyDateTimeUtils.fromApiToLocal(job.startDate!);
          final isInRange = isDateWithinRangeDates(
              endDate, startDateForFilter!, endDateForFilter!);
          if (isInRange) {
            filteredJobByDate.add(job);
          }
        }
      }
    } else {
      filteredJobByDate = filteredJobByStatus;
    }
    jobPostingList = filteredJobByDate;
    notifyListeners();
  }

  bool isBetweenRangeDates(DateTime startDate1, DateTime endDate1,
      DateTime startDate2, DateTime endDate2) {
    return (startDate1.isAfter(startDate2) || startDate1 == startDate2) &&
        (startDate1.isBefore(endDate2) || startDate1 == endDate2) &&
        (endDate1.isAfter(startDate2) || endDate1 == startDate2) &&
        (endDate1.isBefore(endDate2) || endDate1 == endDate2);
  }

  bool isDateWithinRangeDates(
      DateTime selectedDate, DateTime startDate1, DateTime endDate1) {
    return ((selectedDate.isAfter(startDate1) || selectedDate == startDate1) &&
        (selectedDate.isBefore(endDate1) || selectedDate == endDate1));
  }

  onChangeStartDate(DateTime? date) {
    startDateForFilter = date;
    onFilterData();
    notifyListeners();
  }

  onChangeEndDate(DateTime? date) {
    endDateForFilter = date;
    onFilterData();
    notifyListeners();
  }

  onChangeRetirementBenefits(bool val) {
    isRetirementBenefits = val;
    notifyListeners();
  }

  onChangeEmployment(bool val) {
    isEmployment = val;
    notifyListeners();
  }

  onChangeIndustrialAccident(bool val) {
    isIndustrialAccident = val;
    notifyListeners();
  }

  onChangeHealth(bool val) {
    isHealth = val;
    notifyListeners();
  }

  onChangeWelfare(bool val) {
    isWelfare = val;
    notifyListeners();
  }

  onChangeChildCare(bool val) {
    isChildCareSystem = val;
    notifyListeners();
  }

  onChangeRetirement(bool val) {
    isRetirementSystem = val;
    notifyListeners();
  }

  onChangeReemployment(bool val) {
    isReemployment = val;
    notifyListeners();
  }

  onChangeNecessaryJapanSkill(String? val) {
    selectedNecessaryJapanSkill = val;
    notifyListeners();
  }

  onChangeNationality(String? val) {
    selectedNationality = val;
    notifyListeners();
  }

  onChangeChooseGender(String val) {
    selectedDesiredGender = val;
    notifyListeners();
  }

  onChangeHotelCleaningItemLearn(List<String> val) {
    selectedHotelCleaningItemLearn = val;
    notifyListeners();
  }

  onChangeStatusOfRecident(List<String> val) {
    selectedStatusOfRecident = val;
    notifyListeners();
  }

  set setImage(String val) {
    imageUrl = val;
  }

  set setLoading(bool val) {
    isLoading = val;
  }

  onChangeContentOfTest(List<String> val) {
    selectedContentOfTest = val;
    notifyListeners();
  }

  onChangeRemoteInterview(bool val) {
    isThereRemoteInterview = val;
    notifyListeners();
  }

  onChangeDorm(bool val) {
    dorm = val;
    notifyListeners();
  }

  onChangeWifi(bool val) {
    wifi = val;
    notifyListeners();
  }

  onChangeMeals(bool val) {
    meals = val;
    notifyListeners();
  }

  onChangeTransportExpense(bool val) {
    transportExpense = val;
    notifyListeners();
  }

  onChangeBonus(bool val) {
    bonus = val;
    notifyListeners();
  }

  onChangeRaise(bool val) {
    raise = val;
    notifyListeners();
  }

  onChangeOffHour(bool val) {
    offHour = val;
    notifyListeners();
  }

  onChangePaidHoliday(bool val) {
    paidHoliday = val;
    notifyListeners();
  }

  onChangeStartWorkTime(DateTime val) {
    startTime = val;
    notifyListeners();
  }

  onChangeEndWorkTime(DateTime val) {
    endTime = val;
    notifyListeners();
  }

  onChangeSalaryType(String val) {
    salaryType = val;
    notifyListeners();
  }

  onChangeTrailPeriod(bool val) {
    trailPeriod = val;
    notifyListeners();
  }

  onChangeContractProvisioning(String val) {
    contractProvisioning = val;
    notifyListeners();
  }

  onChangeOccupationSkill(bool val) {
    chooseOccupationSkill = val;
    notifyListeners();
  }

  onChangeOccupation(String val) {
    selectedOccupation = val;
    notifyListeners();
  }

  onChangeEmploymentType(String? val) {
    selectedEmploymentType = val;
    notifyListeners();
  }

  onChangeImageUrl(String val) {
    imageUrl = val;
    notifyListeners();
  }

  getAllJobPost() async {
    jobPostingList = await JobPostingApiService().getAllJobPost();
    notifyListeners();
  }

  onInitForList() {
    startDateForFilter = null;
    endDateForFilter = null;
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
    imageUrl = "";
  }

  set setAllController(List<dynamic> dynamicList) {
    title = TextEditingController(text: "");
    overview = TextEditingController(text: "");
    content = TextEditingController(text: "");
    startRecruitDate = TextEditingController(text: "");
    endRecruitDate = TextEditingController(text: "");
    companyLocation = TextEditingController(text: "");
    companyLocationLatLng = TextEditingController(text: "");
    numberOfRecruitPeople = TextEditingController(text: "");
    breakTimeMinute = TextEditingController(text: "");
    startWorkTime = TextEditingController(text: "");
    endWorkTime = TextEditingController(text: "");
    numberOfAnnualHolidays = TextEditingController(text: "");
    holidayDetail = TextEditingController(text: "");
    interviewLocation = TextEditingController(text: "");
    interviewLocationLatLng = TextEditingController(text: "");
    otherQualification = TextEditingController(text: "");
    remark = TextEditingController(text: "");
  }

  onInitForJobPostingDetail(String? id) async {
    selectedCompany = null;
    selectedCompanyId = null;
    jobPosting = null;
    allCompany = [];
    allCompany = await CompanyApiServices().getAllCompany();
    if (id != null) {
      jobPosting = await JobPostingApiService().getAJobPosting(id);
    }
    if (jobPosting?.companyId != null) {
      for (var c in allCompany) {
        if (c.uid == jobPosting!.companyId) {
          selectedCompany = c.companyName;
          selectedCompanyId = c.uid;
        }
      }
    }
    imageUrl = jobPosting?.image ?? "";
    title.text = jobPosting?.title ?? "";
    overview.text = jobPosting?.description ?? "";
    content.text = jobPosting?.content ?? "";
    startRecruitDate.text = jobPosting?.startDate ?? "";
    endRecruitDate.text = jobPosting?.endDate ?? "";
    if (jobPosting?.location != null) {
      companyLocation.text = jobPosting?.location?.name ?? "";
      if (jobPosting?.location?.lat != null &&
          jobPosting?.location?.lat != "") {
        companyLocationLatLng.text =
            "${jobPosting?.location?.lat}, ${jobPosting?.location?.lng}";
      }
    }
    numberOfRecruitPeople.text = jobPosting?.numberOfRecruit ?? "";
    breakTimeMinute.text = jobPosting?.breakTimeAsMinute ?? "";
    startWorkTime.text = jobPosting?.startTimeHour ?? "";
    endWorkTime.text = jobPosting?.endTimeHour ?? "";
    numberOfAnnualHolidays.text = jobPosting?.annualHoliday ?? "";
    holidayDetail.text = jobPosting?.holidayDetail ?? "";
    selectedOccupation = jobPosting?.occupationType;
    chooseOccupationSkill = jobPosting?.occupation ?? false;
    selectedEmploymentType = jobPosting?.employmentType;
    selectedNationality = jobPosting?.desiredNationality;
    selectedNecessaryJapanSkill = jobPosting?.necessaryJapanSkill;
    selectedContentOfTest = jobPosting?.contentOfTheTest ?? [];
    selectedStatusOfRecident = jobPosting?.statusOfResidence ?? [];
    selectedHotelCleaningItemLearn =
        jobPosting?.hotelCleaningLearningItem ?? [];
    contractProvisioning = jobPosting?.employmentContractProvisioning == true
        ? JapaneseText.yes
        : JapaneseText.no;
    if (jobPosting?.interviewLocation != null) {
      interviewLocation.text = jobPosting?.interviewLocation?.name ?? "";
      if (jobPosting?.interviewLocation?.lat != null &&
          jobPosting?.interviewLocation?.lat != "") {
        interviewLocationLatLng.text =
            "${jobPosting?.interviewLocation?.lat}, ${jobPosting?.interviewLocation?.lng}";
      }
    }
    otherQualification.text = jobPosting?.otherQualification ?? "";
    remark.text = jobPosting?.remarkOfRequirement ?? "";
    isIndustrialAccident = jobPosting?.industrialAccident ?? false;
    isEmployment = jobPosting?.employment ?? false;
    isHealth = jobPosting?.health ?? false;
    isWelfare = jobPosting?.publicWelfare ?? false;
    onChangeLoading(false);
  }

  onChangeSelectCompanyForDetail(String? val) {
    selectedCompany = val;
    for (var c in allCompany) {
      if (c.companyName!.contains(selectedCompany.toString())) {
        selectedCompanyId = c.uid;
        companyLocation.text = c.location ?? "";
        companyLocationLatLng.text = c.companyLatLng ?? "";
      }
    }
    notifyListeners();
  }

  onChangeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  onChangeStatus(String? val) {
    selectedStatus = val;
    onFilterData();
    notifyListeners();
  }

  onChangeNewArrival(String? val) {
    selectedNewArrival = val;
    notifyListeners();
  }

  disposeData() {
    title.dispose();
    overview.dispose();
    content.dispose();
    startRecruitDate.dispose();
    endRecruitDate.dispose();
    breakTimeMinute.dispose();
    numberOfRecruitPeople.dispose();
    companyLocation.dispose();
    holidayDetail.dispose();
    numberOfAnnualHolidays.dispose();
    startWorkTime.dispose();
    endWorkTime.dispose();
    otherQualification.dispose();
    interviewLocation.dispose();
    remark.dispose();
  }
}
