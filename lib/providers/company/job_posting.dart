import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/company.dart';

class JobPostingForCompanyProvider with ChangeNotifier {
  //For Job Posting List
  List<JobPosting> jobPostingList = [];
  List<FilePickerResult?> jobPosterProfile = [null];
  List<String> statusList = [JapaneseText.allData, JapaneseText.duringCorrespondence, JapaneseText.noContact, JapaneseText.contact];

  String selectedMenu = JapaneseText.companyJobInformation;

  List<String> tabMenu = [JapaneseText.companyJobInformation, JapaneseText.companyShiftFrame, JapaneseText.companyShiftList];

  List<String> occupationType = [
    JapaneseText.constructionWorker,
    JapaneseText.worker,
    JapaneseText.teacher,
    JapaneseText.hotelStaff,
    JapaneseText.barista
  ];
  String? selectedOccupationType;

  List<String> specificOccupationList = [
    JapaneseText.constructionWorker,
    JapaneseText.worker,
    JapaneseText.teacher,
    JapaneseText.hotelStaff,
    JapaneseText.barista
  ];
  String? selectedSpecificOccupation;

  onChangeSelectMenu(String menu) {
    selectedMenu = menu;
    notifyListeners();
  }

  String? selectedStatus;

  List<String> newArrivalList = [JapaneseText.allData, JapaneseText.newArrival, JapaneseText.interview];
  String? selectedNewArrival;

  //For Job Posting Detail
  JobPosting? jobPosting;
  List<Company> allCompany = [];
  String? selectedCompany;
  String? selectedCompanyId;
  String imageUrl = "";

  bool isLoading = false;

  set setLoading(bool isLoading) {
    this.isLoading = isLoading;
  }

  late TextEditingController title;
  late TextEditingController supplementary;
  late TextEditingController eligibilityForApp;
  late TextEditingController offHours;
  late TextEditingController overview;
  late TextEditingController content;
  late TextEditingController startRecruitDate;
  late TextEditingController endRecruitDate;
  late TextEditingController companyLocation;
  late TextEditingController companyLocationLatLng;
  late TextEditingController numberOfRecruitPeople;
  late TextEditingController fromSalaryAmount;
  late TextEditingController toSalaryAmount;
  late TextEditingController breakTimeMinute;
  late TextEditingController startWorkTime;
  late TextEditingController endWorkTime;
  late TextEditingController numberOfAnnualHolidays;
  late TextEditingController holidayDetail;
  late TextEditingController interviewLocation;
  late TextEditingController interviewLocationLatLng;
  late TextEditingController otherQualification;
  late TextEditingController remark;
  late TextEditingController remarkHoliday;
  late TextEditingController remarkBonus;
  late TextEditingController remarkTransport;
  late TextEditingController minimumWorkTerm;
  late TextEditingController minimumNumberOfWorkingDays;
  late TextEditingController minimumNumberOfWorkingTime;
  late TextEditingController shiftCycle;
  late TextEditingController shiftSubPeriod;
  late TextEditingController shiftFixingPeriod;
  late TextEditingController remarkAtmosphere;
  late TextEditingController oneDayWorkFlow;
  late TextEditingController shiftIncomeExample;
  late TextEditingController aWordFromASeniorStaffMember;
  late TextEditingController flowAfterApplication;
  late TextEditingController plannedNumberOfEmployee;
  late TextEditingController inquiryPhoneNumber;

  bool expWelcome = false;
  bool mealsAvailable = false;
  bool freeClothing = false;
  bool freeHairStyleAndColor = false;
  bool transportationProvided = false;
  bool motorCycleCarCommutingPossible = false;
  bool bicycleCommutingPossible = false;

  getAllJobPost(String id) async {
    debugPrint("Company ID is $id");
    jobPostingList = await JobPostingApiService().getAllJobPostByCompany(id);
    notifyListeners();
  }

  onInitForList() {
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
    imageUrl = "";
  }

  set setAllController(List<dynamic> dynamicList) {
    offHours = TextEditingController(text: "");
    title = TextEditingController(text: "");
    overview = TextEditingController(text: "");
    eligibilityForApp = TextEditingController(text: "");
    supplementary = TextEditingController(text: "");
    content = TextEditingController(text: "");
    startRecruitDate = TextEditingController(text: "");
    endRecruitDate = TextEditingController(text: "");
    companyLocation = TextEditingController(text: "");
    fromSalaryAmount = TextEditingController(text: "");
    toSalaryAmount = TextEditingController(text: "");
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
    remarkHoliday = TextEditingController(text: "");
    remarkBonus = TextEditingController(text: "");
    remarkTransport = TextEditingController(text: "");
    minimumWorkTerm = TextEditingController(text: "");
    minimumNumberOfWorkingDays = TextEditingController(text: "");
    minimumNumberOfWorkingTime = TextEditingController(text: "");
    shiftCycle = TextEditingController(text: "");
    shiftSubPeriod = TextEditingController(text: "");
    shiftFixingPeriod = TextEditingController(text: "");
    remarkAtmosphere = TextEditingController(text: "");
    oneDayWorkFlow = TextEditingController(text: "");
    shiftIncomeExample = TextEditingController(text: "");
    aWordFromASeniorStaffMember = TextEditingController(text: "");
    flowAfterApplication = TextEditingController(text: "");
    plannedNumberOfEmployee = TextEditingController(text: "");
    inquiryPhoneNumber = TextEditingController(text: "");
  }

  final formatter = NumberFormat.simpleCurrency(locale: "ja", name: "");

  onInitForJobPostingDetail(String? id) async {
    jobPosterProfile = [null];
    jobPosting = await JobPostingApiService().getAJobPosting(id.toString());
    onChangeLoading(false);
  }

  onAddNewFile(FilePickerResult filePickerResult) {
    jobPosterProfile.add(filePickerResult);
    notifyListeners();
  }

  onRemoveFile(int index) {
    jobPosterProfile.removeAt(index);
    notifyListeners();
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

  onChangeOccupationType(String? val) {
    selectedOccupationType = val;
    notifyListeners();
  }

  onChangeMajorOccupation(String? val) {
    selectedSpecificOccupation = val;
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
    fromSalaryAmount.dispose();
    toSalaryAmount.dispose();
    remark.dispose();
  }
}
