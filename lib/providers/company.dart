import 'dart:html';

import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/job_posting.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> companyList = [];

  List<String> statusList = [JapaneseText.allData, JapaneseText.duringCorrespondence, JapaneseText.noContact, JapaneseText.contact];

  String? selectedStatus;
  String imageUrl = "";

  List<String> newArrivalList = [JapaneseText.allData, JapaneseText.newArrival, JapaneseText.interview];
  String? selectedNewArrival;

  List<String> jobSeekerDetailTab = [JapaneseText.basicInformation, JapaneseText.chat, JapaneseText.newArrival, JapaneseText.interview];

  static CompanyProvider getProvider(BuildContext context, {bool listen = true}) => Provider.of<CompanyProvider>(context, listen: listen);

  late TextEditingController companyName;
  late TextEditingController profileCom;
  late TextEditingController postalCode;
  late TextEditingController location;
  late TextEditingController companyLatLng;
  late TextEditingController capital;
  late TextEditingController publicDate;
  late TextEditingController homePage;
  late TextEditingController affiliate;
  late TextEditingController tel;
  late TextEditingController tax;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController kanji;
  late TextEditingController kana;
  late TextEditingController content;
  late TextEditingController remark;
  late TextEditingController area;
  late TextEditingController industry;
  late TextEditingController nameKhanJi;
  late TextEditingController nameFu;
  late TextEditingController managerPhoneNumber;
  late TextEditingController managerEmail;
  late TextEditingController managerPassword;

  List<Map<String, TextEditingController>> managerList = [];
  File? fileImage;
  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.parse("2000-10-10");
  bool isLoadingForDetail = false;
  Company? company;

  getAllCompany({bool? isNotify}) async {
    companyList = await CompanyApiServices().getAllCompany();
    List<JobPosting> allJob = await JobPostingApiService().getAllJobPost();
    for (var com in companyList) {
      int num = 0;
      for (var job in allJob) {
        if (com.uid == job.companyId) {
          num++;
        }
      }
      companyList[companyList.indexOf(com)].numberOfJobOpening = num.toString();
    }
    if (isNotify == true) {
      notifyListeners();
    }
  }

  onInit() {
    selectedStatus = null;
    selectedNewArrival = null;
    isLoading = true;
    imageUrl = "";
  }

  onInitDataForDetail(String? id) async {
    company = null;
    managerList = [];
    if (id != null) {
      company = await CompanyApiServices().getACompany(id);
      password.text = "123456789";
      remark.text = company!.remark ?? "";
      nameKhanJi.text = company!.managerNameKhanJi ?? "";
      nameFu.text = company!.managerNameFu ?? "";
      managerPhoneNumber.text = company!.managerPhone ?? "";
      managerEmail.text = company!.managerEmail ?? "";
      managerPassword.text = company!.managerPassword ?? "";
      area.text = company!.area ?? "";
      industry.text = company!.industry ?? "";
      companyName.text = company!.companyName ?? "";
      profileCom.text = company!.companyProfile ?? "";
      postalCode.text = company!.postalCode ?? "";
      location.text = company!.location ?? "";
      companyLatLng.text = company!.companyLatLng ?? "";
      capital.text = company!.capital ?? "";
      publicDate.text = company!.publicDate ?? "";
      homePage.text = company!.homePage ?? "";
      affiliate.text = company!.affiliate ?? "";
      tax.text = company!.tax ?? "";
      tel.text = company!.tel ?? "";
      email.text = company!.email ?? "";
      kanji.text = company!.rePresentative?.kanji ?? "";
      kana.text = company!.rePresentative?.kana ?? "";
      content.text = company!.content ?? "";
      remark.text = company!.remark ?? "";
      imageUrl = company!.companyProfile ?? "";
      if (company!.manager != null) {
        managerList = [];
        for (var manager in company!.manager!) {
          managerList.add({
            "kanji": TextEditingController(text: manager.kanji),
            "kana": TextEditingController(text: manager.kana),
          });
        }
      }
    }
    onChangeLoadingForDetail(false);
  }

  initialController() {
    managerList = [];
    isLoadingForDetail = true;
    imageUrl = "";
    password = TextEditingController(text: "");
    area = TextEditingController(text: "");
    industry = TextEditingController(text: "");
    companyName = TextEditingController(text: "");
    profileCom = TextEditingController(text: "");
    postalCode = TextEditingController(text: "");
    location = TextEditingController(text: "");
    companyLatLng = TextEditingController(text: "");
    capital = TextEditingController(text: "");
    publicDate = TextEditingController(text: "");
    homePage = TextEditingController(text: "");
    affiliate = TextEditingController(text: "");
    tel = TextEditingController(text: "");
    tax = TextEditingController(text: "");
    email = TextEditingController(text: "");
    kanji = TextEditingController(text: "");
    kana = TextEditingController(text: "");
    content = TextEditingController(text: "");
    remark = TextEditingController(text: "");
    managerPassword = TextEditingController(text: "");
    managerEmail = TextEditingController(text: "");
    managerPhoneNumber = TextEditingController(text: "");
    nameKhanJi = TextEditingController(text: "");
    nameFu = TextEditingController(text: "");
    managerList.add({
      "kanji": TextEditingController(text: ""),
      "kana": TextEditingController(text: ""),
    });
  }

  disposeData() {
    companyName.dispose();
    profileCom.dispose();
    postalCode.dispose();
    location.dispose();
    capital.dispose();
    publicDate.dispose();
    homePage.dispose();
    affiliate.dispose();
    tel.dispose();
    tax.dispose();
    email.dispose();
    kanji.dispose();
    kana.dispose();
    content.dispose();
    area.dispose();
    industry.dispose();
    password.dispose();
  }

  set setImage(String val) {
    imageUrl = val;
  }

  onChangeImageUrl(String val) {
    imageUrl = val;
    notifyListeners();
  }

  onChangeLoadingForDetail(bool val) {
    isLoadingForDetail = val;
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
}
