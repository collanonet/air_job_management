import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

import '../api/company.dart';
import '../models/company.dart';

class JobPostingProvider with ChangeNotifier {
  //For Job Posting List
  List<JobPosting> jobPostingList = [];
  List<String> statusList = [
    JapaneseText.allData,
    JapaneseText.duringCorrespondence,
    JapaneseText.noContact,
    JapaneseText.contact
  ];

  String? selectedStatus;

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
  late TextEditingController profileCom;
  late TextEditingController homePage;
  late TextEditingController affiliate;
  late TextEditingController startRecruitDate;
  late TextEditingController endRecruitDate;
  late TextEditingController companyLocation;
  late TextEditingController numberOfRecruitPeople;
  late TextEditingController breakTimeMinute;
  late TextEditingController startWorkTime;
  late TextEditingController endWorkTime;
  late TextEditingController numberOfAnnualHolidays;
  late TextEditingController holidayDetail;
  late TextEditingController interviewLocation;
  late TextEditingController otherQualification;

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
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
    imageUrl = "";
  }

  set setAllController(List<dynamic> dynamicList) {
    title = TextEditingController(text: "");
    overview = TextEditingController(text: "");
    content = TextEditingController(text: "");
    profileCom = TextEditingController(text: "");
    homePage = TextEditingController(text: "");
    affiliate = TextEditingController(text: "");
    startRecruitDate = TextEditingController(text: "");
    endRecruitDate = TextEditingController(text: "");
    companyLocation = TextEditingController(text: "");
    numberOfRecruitPeople = TextEditingController(text: "");
    breakTimeMinute = TextEditingController(text: "");
    startWorkTime = TextEditingController(text: "");
    endWorkTime = TextEditingController(text: "");
    numberOfAnnualHolidays = TextEditingController(text: "");
    holidayDetail = TextEditingController(text: "");
    interviewLocation = TextEditingController(text: "");
    otherQualification = TextEditingController(text: "");
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
    onChangeLoading(false);
  }

  onChangeSelectCompanyForDetail(String? val) {
    selectedCompany = val;
    for (var c in allCompany) {
      if (c.companyName!.contains(selectedCompany.toString())) {
        selectedCompanyId = c.uid;
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
    profileCom.dispose();
    homePage.dispose();
    affiliate.dispose();
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
  }
}
