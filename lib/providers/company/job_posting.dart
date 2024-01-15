import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/company.dart';

class JobPostingForCompanyProvider with ChangeNotifier {
  //For Job Posting List
  List<JobPosting> jobPostingList = [];
  List<dynamic> jobPosterProfile = [null];

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

  String? selectedLocation;
  List<String> locationList = <String>[
    '海外 ',
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県 ',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県 ',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];

  String? selectedDeadline = "【推奨】開始時間と同時";
  List<String> applicationDeadlineList = <String>[
    "【推奨】開始時間と同時",
  ];

  String selectSmokingInDoor = JapaneseText.noSmokingInDoor;
  List<String> allowSmokingInDoor = <String>[JapaneseText.noSmokingInDoor, JapaneseText.canSmokingInDoor];

  bool isAllowSmokingInArea = false;

  onChangeAllowSmokingInDoor(String menu) {
    selectSmokingInDoor = menu;
    notifyListeners();
  }

  onChangeAllowSmokingInArea(bool val) {
    isAllowSmokingInArea = val;
    notifyListeners();
  }

  onChangeSelectDeadline(String menu) {
    selectedDeadline = menu;
    notifyListeners();
  }

  onChangeSelectMenu(String menu) {
    selectedMenu = menu;
    notifyListeners();
  }

  String? selectedStatus;

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
  late TextEditingController jobDescription;
  late TextEditingController notes;
  late TextEditingController belongings;
  late TextEditingController conditionForWork;
  late TextEditingController postalCode;
  late TextEditingController street;
  late TextEditingController building;
  late TextEditingController accessAddress;
  late TextEditingController latLong;
  late TextEditingController numberOfRecruitPeople;
  late TextEditingController hourlyWag;
  late TextEditingController transportExp;
  late TextEditingController emergencyContact;

  bool expWelcome = false;
  bool mealsAvailable = false;
  bool freeClothing = false;
  bool freeHairStyleAndColor = false;
  bool transportationProvided = false;
  bool motorCycleCarCommutingPossible = false;
  bool bicycleCommutingPossible = false;
  String selectedPublicSetting = JapaneseText.openToPublic;

  onChangeSelectPublicSetting(String setting) {
    selectedPublicSetting = setting;
    notifyListeners();
  }

  static DateTime now = DateTime.now();
  DateTime currentDate = DateTime.now();

  DateTime startWorkDate = DateTime.now();
  DateTime endWorkDate = DateTime.now();
  DateTime startWorkingTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
  DateTime endWorkingTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
  DateTime startBreakTime = DateTime(now.year, now.month, now.day, 12, 0, 0);
  DateTime endBreakTime = DateTime(now.year, now.month, now.day, 13, 0, 0);

  getAllJobPost(String id) async {
    jobPostingList = await JobPostingApiService().getAllJobPostByCompany(id);
    notifyListeners();
  }

  onInitForList() {
    selectedStatus = null;
    isLoading = true;
    imageUrl = "";
  }

  set setAllController(List<dynamic> dynamicList) {
    title = TextEditingController(text: "");
    jobDescription = TextEditingController(text: "");
    belongings = TextEditingController(text: "");
    notes = TextEditingController(text: "");
    conditionForWork = TextEditingController(text: "");
    postalCode = TextEditingController(text: "");
    street = TextEditingController(text: "");
    building = TextEditingController(text: "");
    accessAddress = TextEditingController(text: "");
    latLong = TextEditingController(text: "");
    numberOfRecruitPeople = TextEditingController(text: "");
    hourlyWag = TextEditingController(text: "");
    transportExp = TextEditingController(text: "");
    emergencyContact = TextEditingController(text: "");
  }

  final formatter = NumberFormat.simpleCurrency(locale: "ja", name: "");

  initialData() {
    startWorkDate = DateTime.now();
    endWorkDate = DateTime.now();
    startWorkingTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
    endWorkingTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
    startBreakTime = DateTime(now.year, now.month, now.day, 12, 0, 0);
    endBreakTime = DateTime(now.year, now.month, now.day, 13, 0, 0);
    jobPosterProfile = [null];
    jobPosting = JobPosting(location: Location());
  }

  onInitForJobPostingDetail(String? id) async {
    startWorkDate = DateTime.now();
    endWorkDate = DateTime.now();
    startWorkingTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
    endWorkingTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
    startBreakTime = DateTime(now.year, now.month, now.day, 12, 0, 0);
    endBreakTime = DateTime(now.year, now.month, now.day, 13, 0, 0);
    jobPosterProfile = [null];
    jobPosting = await JobPostingApiService().getAJobPosting(id.toString());
    if (jobPosting != null) {
      jobPosterProfile.addAll(jobPosting!.coverList!);
      title.text = jobPosting?.title ?? "";
      jobDescription.text = jobPosting?.description ?? "";
      belongings.text = jobPosting?.belongings ?? "";
      notes.text = jobPosting?.notes ?? "";
      conditionForWork.text = jobPosting?.workCatchPhrase ?? "";
      postalCode.text = jobPosting?.location?.postalCode ?? "";
      street.text = jobPosting?.location?.street ?? "";
      building.text = jobPosting?.location?.building ?? "";
      accessAddress.text = jobPosting?.location?.accessAddress ?? "";
      latLong.text = jobPosting!.location!.lat.toString() + ", " + jobPosting!.location!.lng.toString();
      numberOfRecruitPeople.text = jobPosting?.numberOfRecruit ?? "0";
      hourlyWag.text = jobPosting?.hourlyWag ?? "";
      transportExp.text = jobPosting?.transportExpenseFee ?? "";
      emergencyContact.text = jobPosting?.emergencyContact ?? "";
      expWelcome = jobPosting?.expAndQualifiedPeopleWelcome ?? false;
      mealsAvailable = jobPosting?.mealsAssAvailable ?? false;
      freeClothing = jobPosting?.clothFree ?? false;
      freeHairStyleAndColor = jobPosting?.hairStyleColorFree ?? false;
      transportationProvided = jobPosting?.transportExpense ?? false;
      motorCycleCarCommutingPossible = jobPosting?.motorCycleCarCommutingPossible ?? false;
      bicycleCommutingPossible = jobPosting?.bicycleCommutingPossible ?? false;
      selectedPublicSetting = jobPosting?.selectedPublicSetting ?? JapaneseText.openToPublic;
      if (occupationType.contains(jobPosting?.occupationType)) {
        selectedOccupationType = jobPosting?.occupationType;
      }
      if (specificOccupationList.contains(jobPosting?.majorOccupation)) {
        selectedSpecificOccupation = jobPosting?.majorOccupation;
      }

      if (applicationDeadlineList.contains(jobPosting?.applicationDateline)) {
        selectedDeadline = jobPosting?.applicationDateline;
      }
      if (locationList.contains(jobPosting?.jobLocation)) {
        selectedLocation = jobPosting?.jobLocation;
      }

      if (jobPosting?.startDate != null && jobPosting?.startDate != "") {
        startWorkDate = DateToAPIHelper.fromApiToLocal(jobPosting!.startDate!);
      }

      if (jobPosting?.endDate != null && jobPosting?.endDate != "") {
        endWorkDate = DateToAPIHelper.fromApiToLocal(jobPosting!.endDate!);
      }

      if (jobPosting!.startTimeHour != null && jobPosting!.startTimeHour != "") {
        startWorkingTime = DateTime(now.year, now.month, now.day, int.parse(jobPosting!.startTimeHour.toString().split(":")[0]),
            int.parse(jobPosting!.startTimeHour.toString().split(":")[1]), 0);
      }
      if (jobPosting?.endTimeHour != null && jobPosting?.endTimeHour != "") {
        endWorkingTime = DateTime(now.year, now.month, now.day, int.parse(jobPosting!.endTimeHour.toString().split(":")[0]),
            int.parse(jobPosting!.endTimeHour.toString().split(":")[1]), 0);
      }
      if (jobPosting?.startBreakTimeHour != null && jobPosting?.startBreakTimeHour != "") {
        startBreakTime = DateTime(now.year, now.month, now.day, int.parse(jobPosting!.startBreakTimeHour.toString().split(":")[0]),
            int.parse(jobPosting!.startBreakTimeHour.toString().split(":")[1]), 0);
      }
      if (jobPosting?.endBreakTimeHour != null && jobPosting?.endBreakTimeHour != "") {
        endBreakTime = DateTime(now.year, now.month, now.day, int.parse(jobPosting!.endBreakTimeHour.toString().split(":")[0]),
            int.parse(jobPosting!.endBreakTimeHour.toString().split(":")[1]), 0);
      }
    } else {
      jobPosting = JobPosting(location: Location());
    }
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

  onChangeLocation(String? val) {
    selectedLocation = val;
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

  disposeData() {
    title.dispose();
    jobDescription.dispose();
    belongings.dispose();
    conditionForWork.dispose();
    notes.dispose();
    street.dispose();
    postalCode.dispose();
    building.dispose();
    accessAddress.dispose();
    latLong.dispose();
    hourlyWag.dispose();
    transportExp.dispose();
    emergencyContact.dispose();
    numberOfRecruitPeople.dispose();
  }
}
