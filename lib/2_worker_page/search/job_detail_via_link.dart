import 'package:air_job_management/2_worker_page/search/confirm_apply_job_dialog.dart';
import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/currency_format.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_back_button.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../models/user.dart';
import '../../models/worker_model/search_job.dart';
import '../../pages/login.dart';

class ViewJobDetailViaLinkPage extends StatefulWidget {
  final String jobId;
  const ViewJobDetailViaLinkPage({key, required this.jobId}) : super(key: key);
  //Review review;

  @override
  State<ViewJobDetailViaLinkPage> createState() => _ViewJobDetailViaLinkPageState();
}

class _ViewJobDetailViaLinkPageState extends State<ViewJobDetailViaLinkPage> with AfterBuildMixin {
  double ratingg = 0.0;
  ScrollController scrollController = ScrollController();
  List<dynamic> conditionList = [
    {"title": "交通機関", "icon": Icon(Icons.car_crash_rounded)},
    {"title": "服", "icon": Icon(FontAwesome5Brands.shirtsinbulk)},
    {"title": "自転車", "icon": Icon(FontAwesome.bicycle)},
    {"title": "バイク", "icon": Icon(Icons.directions_bike)},
    {"title": "保険", "icon": Icon(Icons.shield_outlined)}
  ];
  List<ShiftModel> shiftList = [];
  List<ShiftModel> selectedShiftList = [];
  Company? company;
  //map
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  LatLng? companyLatLng;
  late FavoriteProvider fa;
  SearchJob? job;
  bool isLoading = true;

  getCompany() async {
    company = await CompanyApiServices().getACompany(job!.companyId ?? "");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fa = Provider.of<FavoriteProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "仕事の詳細",
          style: kNormalText.copyWith(fontSize: 15),
        ),
        centerTitle: true,
        leading: CustomBackButtonWidget(textColor: AppColor.whiteColor),
        backgroundColor: AppColor.primaryColor,
        leadingWidth: 120,
      ),
      body: isLoading
          ? Center(
              child: LoadingWidget(AppColor.primaryColor),
            )
          : Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: SafeArea(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: AppSize.getDeviceWidth(context),
                            height: AppSize.getDeviceHeight(context) * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(job!.image != null && job!.image != "" ? job!.image! : ConstValue.defaultBgImage),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.greyColor, width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  CurrencyFormatHelper.displayData(job!.hourlyWag),
                                  style: kTitleText.copyWith(fontWeight: FontWeight.w600, color: AppColor.greyColor),
                                ),
                              ),
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
                            Center(
                              child: Text(
                                job!.title.toString(),
                                style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                              ),
                            ),
                            AppSize.spaceHeight8,
                            Text(job!.notes.toString()),
                            AppSize.spaceHeight16,
                            buildShiftList(),
                            title("待遇"),
                            condition(),
                            divider(),
                            title(JapaneseText.jobDescription),
                            Text(
                              job!.description.toString(),
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            title(JapaneseText.belongings),
                            Text(
                              job!.belongings.toString(),
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            title("注意事項"),
                            Text(
                              job!.notes.toString(),
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            title("持ち物"),
                            Text(
                              "${job!.occupationType.toString()}   ${job!.majorOccupation.toString()}",
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            title("働くための条件"),
                            Text(
                              "${job!.workCatchPhrase}",
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            title('働く場所'),
                            Text(
                              "${job!.location?.postalCode}   ${job!.jobLocation}\n${job!.location?.street} ${job!.location?.building}\n${job!.location?.accessAddress}",
                              style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                            ),
                            divider(),
                            googlemap(context),
                            divider(),
                            title('アクセス'),
                            Text(job!.remarkOfRequirement.toString()),
                            divider(),
                            title("評価"),
                            rattingstar(),
                            divider(),
                            title('レビュー'),
                            SizedBox(
                              width: AppSize.getDeviceWidth(context),
                              height: AppSize.getDeviceHeight(context) * 0.5,
                              child: ListView.builder(
                                itemCount: job!.reviews!.length,
                                itemBuilder: (context, index) {
                                  return revieww(job!, index);
                                },
                              ),
                            ),
                            AppSize.spaceHeight30,
                            Center(
                              child: Image.asset(
                                "assets/logo.png",
                                width: 200,
                              ),
                            ),
                            AppSize.spaceHeight30,
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Visibility(
        visible: (shiftList.isEmpty || users == null) ? false : true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: InkWell(
            onTap: () async {
              if (auth.myUser != null) {
                if (selectedShiftList.isEmpty) {
                  MessageWidget.show("少なくとも 1 つのシフトを選択してください");
                } else {
                  showConfirmOrderDialog();
                }
              } else {
                MyPageRoute.goTo(
                    context,
                    const LoginPage(
                      isFromWorker: true,
                      isFullTime: false,
                    ));
              }
            },
            child: Container(
              width: AppSize.getDeviceWidth(context),
              height: AppSize.getDeviceHeight(context) * 0.075,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'エアジョブに登録する',
                  style: kNormalText.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showConfirmOrderDialog() {
    showDialog(context: context, builder: (context) => ConfirmApplyJobDialog(selectedShiftList: selectedShiftList, info: job!));
  }

  buildShiftList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: shiftList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff00000010),
                        offset: Offset(0, 9), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(width: 1, color: selectedShiftList.contains(shiftList[index]) ? AppColor.secondaryColor : AppColor.bgPageColor),
                    color: selectedShiftList.contains(shiftList[index]) ? const Color(0xffFAFFD3) : AppColor.whiteColor),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedShiftList.contains(shiftList[index])) {
                        selectedShiftList.remove(shiftList[index]);
                      } else {
                        selectedShiftList.add(shiftList[index]);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 51,
                                height: 51,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      dateTimeToMonthDay(shiftList[index].date),
                                      style: kNormalText.copyWith(fontFamily: "Bold", fontSize: 13, color: AppColor.primaryColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3, left: 5),
                                      child: Text(
                                        toJapanWeekDayWithInt(shiftList[index].date!.weekday),
                                        style: kNormalText.copyWith(fontFamily: "Normal", fontSize: 9, color: AppColor.primaryColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              AppSize.spaceWidth16,
                              Text(
                                "${shiftList[index].startWorkTime} 〜 ${shiftList[index].endWorkTime}",
                                style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                              ),
                              AppSize.spaceWidth16,
                              Text(
                                "${CurrencyFormatHelper.displayDataRightYen(shiftList[index].price)}",
                                style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                              ),
                            ],
                          ),
                        ),
                        AppSize.spaceWidth16,
                        if (selectedShiftList.contains(shiftList[index]))
                          const Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                          )
                        else
                          const Icon(
                            Icons.check_rounded,
                            color: Colors.grey,
                          )
                      ],
                    ),
                  ),
                ),
              );
            }),
        AppSize.spaceHeight20,
        Text(
          "${toJapanDate(DateTime.now())} ${job!.startTimeHour}〜${job!.endTimeHour}    ${job!.majorOccupation}    ${CurrencyFormatHelper.displayDataRightYen(job!.hourlyWag)}",
          style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
        )
      ],
    );
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title, style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 15)),
        ],
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: const Color(0xff3786C6).withOpacity(0.5),
        height: 3,
      ),
    );
  }

  Widget rattingstar() {
    return company == null
        ? SizedBox()
        : SizedBox(
            width: AppSize.getDeviceWidth(context),
            height: AppSize.getDeviceHeight(context) * 0.3,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Image.network(
                      company?.companyProfile ?? ConstValue.defaultBgImage,
                      width: 110,
                      height: 110,
                    )),
                AppSize.spaceHeight16,
                Text(
                  "${company?.companyName}",
                  style: kNormalText.copyWith(fontFamily: "Bold", fontSize: 20, color: AppColor.primaryColor),
                ),
                AppSize.spaceHeight16,
                Container(
                  width: 56,
                  height: 26,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 2, color: AppColor.secondaryColor)),
                  child: Center(
                      child: Text(
                    "GOLD",
                    style: kNormalText.copyWith(fontFamily: "Bold", fontSize: 12, color: AppColor.secondaryColor),
                  )),
                ),
                // Text(
                //   '${ratingg * 20} %',
                //   style: TextStyle(
                //     fontSize: 60,
                //     fontWeight: FontWeight.bold,
                //     color: AppColor.primaryColor,
                //   ),
                // ),
                AppSize.spaceHeight5,
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
        initialCameraPosition: CameraPosition(target: companyLatLng!, zoom: 15),
        myLocationEnabled: false,
        tiltGesturesEnabled: false,
        compassEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
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
          itemCount: conditionList.length,
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.whiteColor, boxShadow: [
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [conditionList[index]["icon"], Text(conditionList[index]["title"])],
                      ),
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
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  MyUser? users;
  @override
  void afterBuild(BuildContext context) async {
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    users = await UserApiServices().getProfileUser(uid);
    var jobPost = await JobPostingApiService().getASearchJob(widget.jobId);
    if (jobPost != null) {
      job = jobPost;
      getCompany();
      DateTime startDate = DateToAPIHelper.fromApiToLocal(job!.startDate!);
      DateTime endDate = DateToAPIHelper.fromApiToLocal(job!.endDate!);
      List<DateTime> dateList = [DateToAPIHelper.timeToDateTime(job!.startTimeHour!, dateTime: startDate)];
      for (var i = 1; i <= (startDate.difference(endDate).inDays * -1); ++i) {
        dateList.add(DateTime(startDate.year, startDate.month, startDate.day + i));
      }
      for (var date in dateList) {
        if (date.isAfter(DateTime.now())) {
          shiftList.add(ShiftModel(
              startBreakTime: job!.startBreakTimeHour!,
              date: date,
              endBreakTime: job!.endBreakTimeHour!,
              endWorkTime: job!.endTimeHour!,
              price: job!.hourlyWag!,
              startWorkTime: job!.startTimeHour!));
        }
      }
      companyLatLng = LatLng(double.parse(job!.location!.lat!), double.parse(job!.location!.lng!));
      _addMarker(companyLatLng!, "origin", BitmapDescriptor.defaultMarker);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
