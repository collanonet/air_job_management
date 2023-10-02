import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';

import '../api/company.dart';
import '../models/company.dart';

class JobPostingProvider with ChangeNotifier {
  //For Job Posting List
  List<JobPosting> jobPostingList = [];
  List<String> statusList = [JapaneseText.allData, JapaneseText.duringCorrespondence, JapaneseText.noContact, JapaneseText.contact];

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

  String trailPeriod = JapaneseText.no;
  String salaryType = JapaneseText.monthlySalary;

  set setImage(String val) {
    imageUrl = val;
  }

  set setLoading(bool val) {
    isLoading = val;
  }

  onChangeSalaryType(String val) {
    salaryType = val;
    notifyListeners();
  }

  onChangeTrailPeriod(String val) {
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
  }
}
