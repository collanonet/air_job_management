import 'package:air_job_management/2_worker_page/chat/message_page.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
// import 'package:location/location.dart';
import 'package:provider/provider.dart';

class JobScreenDetial extends StatefulWidget {
  JobScreenDetial({key, required this.info, this.docId, this.index})
      : super(key: key);
  SearchJob info;
  var docId;
  int? index;

  //Review review;

  @override
  State<JobScreenDetial> createState() => _JobScreenDetialState();
}

class _JobScreenDetialState extends State<JobScreenDetial> {
  double ratingg = 0.0;
  late double lat;
  late double lng;
  late String des;
  late int indexx;

  //map
  late GoogleMapController mapController;
  double _originLatitude = 11.5635186, _originLongitude = 104.9267874;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  static const LatLng problem1 = LatLng(-5.159517091944005, 119.44694331116966);
  static const LatLng problem2 = LatLng(-5.167239534487095, 119.40174159126605);

  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  String googleAPiKey = "Please provide your api key";

  static const snackBar = SnackBar(
    content: Text(
        "Problem Ahead Please Change Route, if you cannot change route then please proceed with carefull"),
  );

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    // _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider fa = Provider.of<FavoriteProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("search_job").snapshots(),
          builder: (context, snapshot) {
            return SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: AppSize.getDeviceWidth(context),
                        height: AppSize.getDeviceHeight(context) * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.info.image.toString()),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Center(
                                child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.arrow_back_rounded)))),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Center(
                                child: LikeButton(
                                  onTap: (isLiked) async {
                                    fa.ontap(widget.docId, widget.info);
                                  },
                                  size: 30,
                                  circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor:
                                        Color.fromARGB(255, 229, 51, 51),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  isLiked: fa.isfav,
                                  likeBuilder: (isLiked) {
                                    fa.isfav = isLiked;
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked
                                          ? Color.fromARGB(255, 255, 170, 0)
                                          : Colors.grey,
                                      size: 30,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    MyPageRoute.goTo(
                                      context,
                                      MessagePage(
                                        companyID:
                                            widget.info.companyId ?? "ABC",
                                        companyName: widget.info.company,
                                        companyImageUrl: widget.info.image,
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.chat_bubble,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.info.title.toString(),
                          style: kNormalText,
                        ),
                        Text(widget.info.dailyWorkFlow.toString()),
                        Row(
                          children: [
                            Text(
                              'Condition',
                              style: kNormalText,
                            ),
                          ],
                        ),
                        condition(),
                        divider(),
                        title(JapaneseText.aboutApplication),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "企業: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.company ?? "", style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.employmentStatus}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.employmentType ?? "",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.occupationMajor}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.occupationType ?? "",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.occupation}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.occupationType ?? "",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.salaryFrom}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.salaryType ?? "",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.salaryFrom}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(widget.info.salaryRange ?? "",
                                  style: kNormalText),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.salaryFrom}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(
                                "${widget.info.amountOfPayrollFrom ?? ""} ~ ${widget.info.amountOfPayrollTo ?? ""}",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.supplementaryExplanationOfSalary}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(
                                widget.info.supplementaryExplanationOfSalary ??
                                    "",
                                style: kNormalText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.eligibilityForApplication}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                                child: Text(
                              widget.info.eligibilityForApplication ?? "",
                              style: kNormalText,
                              overflow: TextOverflow.fade,
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.offHours}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Text(widget.info.offHours ?? "",
                                style: kNormalText),
                          ],
                        ),
                        divider(),
                        title(JapaneseText.aboutEmployee),
                        //  月 火 水 木 金 土 日
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.workDay}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.mon == true ? "月, " : ""} ${widget.info.tue == true ? "火, " : ""},${widget.info.wed == true ? "水, " : ""}${widget.info.thu == true ? "木, " : ""}${widget.info.fri == true ? "金, " : ""}${widget.info.sat == true ? "土, " : ""}${widget.info.sun == true ? "日" : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.holidayLeave}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.shiftSystem2 == true ? "${JapaneseText.shiftSystem}, " : ""}${widget.info.paidHoliday2 == true ? "${JapaneseText.paidHoliday2}, " : ""}${widget.info.summerVacation == true ? "${JapaneseText.summerVacation}, " : ""}${widget.info.winterVacation == true ? "${JapaneseText.winterVacation}, " : ""}${widget.info.nurseCareLeave == true ? "${JapaneseText.nurseCareLeave}, " : ""}${widget.info.childCareLeave == true ? "${JapaneseText.childCareLeave}, " : ""}${widget.info.prenatalAndPostnatalLeave == true ? "${JapaneseText.prenatalAndPostnatalLeave}, " : ""}${widget.info.accordingToOurCalendar == true ? "${JapaneseText.accordingToOurCalendar}, " : ""}${widget.info.sundayAndPublicHoliday == true ? "${JapaneseText.sundayAndPublicHoliday}, " : ""}${widget.info.fourTwoFiveTwoOff == true ? "${JapaneseText.fourTwoFiveTwoOff}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.remark}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.holidayRemark ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.bonus}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.salaryIncrease == true ? "${JapaneseText.salaryIncrease}, " : ""}${widget.info.uniform == true ? "${JapaneseText.uniform}, " : ""}${widget.info.socialInsurance2 == true ? "${JapaneseText.socialInsurance2}, " : ""}${widget.info.bonuses == true ? "${JapaneseText.bonuses}, " : ""}${widget.info.mealsAssAvailable == true ? "${JapaneseText.mealsAssAvailable}, " : ""}${widget.info.companyDiscountAvailable == true ? "${JapaneseText.companyDiscountAvailable}, " : ""}${widget.info.employeePromotionAvailable == true ? "${JapaneseText.employeePromotionAvailable}, " : ""}${widget.info.qualificationAcqSupportSystem == true ? "${JapaneseText.qualificationAcqSupportSystem}, " : ""}${widget.info.overtimeAllowance == true ? "${JapaneseText.overtimeAllowance}, " : ""}${widget.info.lateNightAllowance == true ? "${JapaneseText.lateNightAllowance}, " : ""}${widget.info.holidayAllowance == true ? "${JapaneseText.holidayAllowance}, " : ""}${widget.info.dormCompanyHouseHousingAllowanceAvailable == true ? "${JapaneseText.dormCompanyHouseHousingAllowanceAvailable}, " : ""}${widget.info.qualificationAllowance == true ? "${JapaneseText.qualificationAllowance}, " : ""}${widget.info.perfectAttendanceAllowance == true ? "${JapaneseText.perfectAttendanceAllowance}, " : ""}${widget.info.familyAllowance == true ? "${JapaneseText.familyAllowance}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.remark}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.bonusRemark ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.transportExpense}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.transportExpense == true
                                    ? JapaneseText.yes
                                    : JapaneseText.no,
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.remark}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.transportRemark ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.minimumWorkTerm}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.minimumWorkTerm ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.minimumNumberOfWorkingDays}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.minimumNumberOfWorkingDays ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.minimumNumberOfWorkingTime}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.minimumNumberOfWorkingTime ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.shiftCycle}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.shiftCycle ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.shiftSubPeriod}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.shiftSubPeriod ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.shiftFixingPeriod}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.shiftFixingPeriod ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        title(JapaneseText.aboutJobContent),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.supplementaryExplanationOfSalary}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.supplementaryExplanationOfSalary ??
                                    "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.occupationAndExp}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.houseWivesHouseHusbandsWelcome == true ? "${JapaneseText.houseWivesHouseHusbandsWelcome}, " : ""}${widget.info.partTimeWelcome == true ? "${JapaneseText.partTimeWelcome}, " : ""}${widget.info.universityStudentWelcome == true ? "${JapaneseText.universityStudentWelcome}, " : ""}${widget.info.highSchoolStudent == true ? "${JapaneseText.highSchoolStudent}, " : ""}${widget.info.seniorSupport == true ? "${JapaneseText.seniorSupport}, " : ""}${widget.info.noEducationRequire == true ? "${JapaneseText.noEducationRequire}, " : ""}${widget.info.noExpBeginnerIsOk == true ? "${JapaneseText.noExpBeginnerIsOk}, " : ""}${widget.info.blankOk == true ? "${JapaneseText.blankOk}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.shiftDayOfTheWeek}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.shiftSystem == true ? "${JapaneseText.shiftSystem}, " : ""}${widget.info.youCanChooseTheTimeAndDayOfTheWeek == true ? "${JapaneseText.youCanChooseTheTimeAndDayOfTheWeek}, " : ""}${widget.info.onlyOnWeekDayOK == true ? "${JapaneseText.onlyOnWeekDayOK}, " : ""}${widget.info.satSunHolidayOK == true ? "${JapaneseText.satSunHolidayOK}, " : ""}${widget.info.fourAndMoreDayAWeekOK == true ? "${JapaneseText.fourAndMoreDayAWeekOK}, " : ""}${widget.info.singleDayOK == true ? "${JapaneseText.singleDayOK}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.wayOfWorking}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.sameDayWorkOK == true ? "${JapaneseText.sameDayWorkOK}, " : ""}${widget.info.fullTimeWelcome == true ? "${JapaneseText.fullTimeWelcome}, " : ""}${widget.info.workDependentsOK == true ? "${JapaneseText.workDependentsOK}, " : ""}${widget.info.longTermWelcome == true ? "${JapaneseText.longTermWelcome}, " : ""}${widget.info.sideJoBDoubleWorkOK == true ? "${JapaneseText.sideJoBDoubleWorkOK}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.commutingStyle}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.nearOrInsideStation == true ? "${JapaneseText.nearOrInsideStation}, " : ""}${widget.info.commutingNearByOK == true ? "${JapaneseText.commutingNearByOK}, " : ""}${widget.info.commutingByBikeOK == true ? "${JapaneseText.commutingByBikeOK}, " : ""}${widget.info.hairStyleColorFree == true ? "${JapaneseText.hairStyleColorFree}, " : ""}${widget.info.clothFree == true ? "${JapaneseText.clothFree}, " : ""}${widget.info.canApplyWithFri == true ? "${JapaneseText.canApplyWithFri}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "その他: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.ovenStaff == true ? "${JapaneseText.ovenStaff}, " : ""}${widget.info.shortTerm == true ? "${JapaneseText.shortTerm}, " : ""}${widget.info.trainingAvailable == true ? "${JapaneseText.trainingAvailable}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        title(JapaneseText.workEnvAtmosphere),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.areGroup}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.manyTeenagers == true ? "${JapaneseText.manyTeenagers}, " : ""}${widget.info.manyInTheir20 == true ? "${JapaneseText.manyInTheir20}, " : ""}${widget.info.manyInTheir30 == true ? "${JapaneseText.manyInTheir30}, " : ""}${widget.info.manyInTheir40 == true ? "${JapaneseText.manyInTheir40}, " : ""}${widget.info.manyInTheir50 == true ? "${JapaneseText.manyInTheir50}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.genderRatio}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.manyMen == true ? "${JapaneseText.manyMen}, " : ""}${widget.info.manyWomen == true ? "${JapaneseText.manyWomen}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.atmosphere}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.info.livelyWorkplace == true ? "${JapaneseText.livelyWorkplace}, " : ""}${widget.info.calmWorkplace == true ? "${JapaneseText.calmWorkplace}, " : ""}${widget.info.manyInteractionsOutsideOfWork == true ? "${JapaneseText.manyInteractionsOutsideOfWork}, " : ""}${widget.info.fewInteractionsOutsideOfWork == true ? "${JapaneseText.fewInteractionsOutsideOfWork}, " : ""}${widget.info.atHome == true ? "${JapaneseText.atHome}, " : ""}${widget.info.businessLike == true ? "${JapaneseText.businessLike}, " : ""}${widget.info.beginnersAreActivelyWorking == true ? "${JapaneseText.beginnersAreActivelyWorking}, " : ""}${widget.info.youCanWorkForAlongTime == true ? "${JapaneseText.youCanWorkForAlongTime}, " : ""}${widget.info.easyToAdjustToYourConvenience == true ? "${JapaneseText.easyToAdjustToYourConvenience}, " : ""}${widget.info.scheduledTimeExactly == true ? "${JapaneseText.scheduledTimeExactly}, " : ""}${widget.info.collaborative == true ? "${JapaneseText.collaborative}, " : ""}${widget.info.individualityCanBeUtilized == true ? "${JapaneseText.individualityCanBeUtilized}, " : ""}${widget.info.standingWork == true ? "${JapaneseText.standingWork}, " : ""}${widget.info.deskWork == true ? "${JapaneseText.deskWork}, " : ""}${widget.info.tooMuchInteractionWithCustomers == true ? "${JapaneseText.tooMuchInteractionWithCustomers}, " : ""}${widget.info.lessInteractionWithCustomers == true ? "${JapaneseText.lessInteractionWithCustomers}, " : ""}${widget.info.lotsOfManualLabor == true ? "${JapaneseText.lotsOfManualLabor}, " : ""}${widget.info.littleOfManualLabor == true ? "${JapaneseText.littleOfManualLabor}, " : ""}${widget.info.knowledgeAndExperience == true ? "${JapaneseText.knowledgeAndExperience}, " : ""}${widget.info.noKnowledgeOrExperienceRequired == true ? "${JapaneseText.noKnowledgeOrExperienceRequired}, " : ""}",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.remark}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.atmosphereRemark ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.oneDayWorkFlow}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.dailyWorkFlow ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.shiftIncomeExample}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.exampleOfShiftAndIncome ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.aWordFromASeniorStaffMember}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.messageFromSeniorStaff ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        title(JapaneseText.aboutApplication),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.flowAfterApplication}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.applicationProcess ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.plannedNumberOfEmployee}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.expectedNumberOfRecruits ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.inquiryPhoneNumber}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.phoneNumber ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${JapaneseText.informationToObtain}: ",
                              style: kNormalText.copyWith(color: Colors.grey),
                            ),
                            Expanded(
                              child: Text(
                                widget.info.infoToBeObtains ?? "",
                                style: kNormalText,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        title('Working Place'),
                        googlemap(context),
                        divider(),
                        title('Access'),
                        Text(widget.info.remarkOfRequirement.toString()),
                        divider(),
                        Row(
                          children: [
                            Text(
                              'Reputation',
                              style: kNormalText,
                            ),
                          ],
                        ),
                        rattingstar(),
                        divider(),
                        Row(
                          children: [
                            Text(
                              'Review',
                              style: kNormalText,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: AppSize.getDeviceWidth(context),
                          height: AppSize.getDeviceHeight(context) * 0.5,
                          child: ListView.builder(
                            itemCount: widget.info.reviews!.length,
                            itemBuilder: (context, index) {
                              indexx = index;
                              return revieww(widget.info, index);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: kNormalText,
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: AppColor.primaryColor.withOpacity(0.5),
        height: 3,
      ),
    );
  }

  Widget rattingstar() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.3,
      // color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${ratingg * 20} %',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                ratingg = rating;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget googlemap(BuildContext context) {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.4,
      // color: Colors.amber,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(_originLatitude, _originLongitude), zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  Widget condition() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context) * 0.1,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Card(
                    child: Container(
                      width: 80,
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-1, -1),
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget revieww(SearchJob review, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Center(
          child: Icon(Icons.person),
        ),
      ),
      title: Text(review.reviews![index].comment.toString()),
      subtitle: Text(review.reviews![index].name.toString()),
    );
  }

  // map

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
