import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/currency_format.dart';
import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/models/worker_model/shift.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ViewJobDetail extends StatefulWidget {
  ViewJobDetail({key, required this.info}) : super(key: key);
  SearchJob info;

  //Review review;

  @override
  State<ViewJobDetail> createState() => _ViewJobDetailState();
}

class _ViewJobDetailState extends State<ViewJobDetail> {
  double ratingg = 0.0;
  ScrollController scrollController = ScrollController();
  List<dynamic> conditionList = [
    {"title": "交通機関", "icon": Icon(Icons.car_crash_rounded)},
    {"title": "服", "icon": Icon(FontAwesome5Brands.shirtsinbulk)},
    {"title": "自転車", "icon": Icon(FontAwesome.bicycle)},
    {"title": "自転車", "icon": Icon(Icons.directions_bike)},
    {"title": "保険", "icon": Icon(Icons.shield_outlined)}
  ];
  List<ShiftModel> shiftList = [];
  List<ShiftModel> selectedShiftList = [];
  Company? company;
  //map
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  LatLng? companyLatLng;

  @override
  void initState() {
    super.initState();
    getCompany();
    DateTime startDate = DateToAPIHelper.fromApiToLocal(widget.info.startDate!);
    DateTime endDate = DateToAPIHelper.fromApiToLocal(widget.info.endDate!);
    List<DateTime> dateList = [DateToAPIHelper.timeToDateTime(widget.info.startTimeHour!, dateTime: startDate)];
    for (var i = 1; i <= (startDate.difference(endDate).inDays * -1); ++i) {
      dateList.add(DateTime(startDate.year, startDate.month, startDate.day + i));
    }
    for (var date in dateList) {
      if (date.isAfter(DateTime.now())) {
        shiftList.add(ShiftModel(
            startBreakTime: widget.info.startBreakTimeHour!,
            date: date,
            endBreakTime: widget.info.endBreakTimeHour!,
            endWorkTime: widget.info.endTimeHour!,
            price: widget.info.hourlyWag!,
            startWorkTime: widget.info.startTimeHour!));
      }
    }
    companyLatLng = LatLng(double.parse(widget.info.location!.lat!), double.parse(widget.info.location!.lng!));
    _addMarker(companyLatLng!, "origin", BitmapDescriptor.defaultMarker);
  }

  getCompany() async {
    company = await CompanyApiServices().getACompany(widget.info.companyId ?? "");
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
    FavoriteProvider fa = Provider.of<FavoriteProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("search_job").snapshots(),
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
                                image: NetworkImage(
                                    widget.info.image != null && widget.info.image != "" ? widget.info.image! : ConstValue.defaultBgImage),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                              child: Center(child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)))),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              // Container(
                              //   width: 40,
                              //   height: 40,
                              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                              //   child: Center(
                              //     child: IconButton(
                              //       onPressed: () {
                              //         MyPageRoute.goTo(
                              //           context,
                              //           MessagePage(
                              //             companyID: widget.info.companyId ?? "ABC",
                              //             companyName: widget.info.company,
                              //             companyImageUrl: widget.info.image,
                              //           ),
                              //         );
                              //       },
                              //       icon: const Icon(
                              //         Icons.chat_bubble,
                              //         color: Colors.black,
                              //         size: 25,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
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
                                CurrencyFormatHelper.displayData(widget.info.hourlyWag),
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
                              widget.info.title.toString(),
                              style: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 15),
                            ),
                          ),
                          AppSize.spaceHeight8,
                          Text(widget.info.notes.toString()),
                          AppSize.spaceHeight16,
                          buildShiftList(),
                          title("状態"),
                          condition(),
                          divider(),
                          title(JapaneseText.jobDescription),
                          Text(
                            widget.info.description.toString(),
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          title(JapaneseText.belongings),
                          Text(
                            widget.info.belongings.toString(),
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          title("注意事項"),
                          Text(
                            widget.info.notes.toString(),
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          title("持ち物"),
                          Text(
                            "${widget.info.occupationType.toString()}   ${widget.info.majorOccupation.toString()}",
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          title("働くための条件"),
                          Text(
                            "${widget.info.workCatchPhrase}",
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          title('働く場所'),
                          Text(
                            "${widget.info.location?.postalCode}   ${widget.info.jobLocation}\n${widget.info.location?.street} ${widget.info.location?.building}\n${widget.info.location?.accessAddress}",
                            style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                          ),
                          divider(),
                          googlemap(context),
                          divider(),
                          title('アクセス'),
                          Text(widget.info.remarkOfRequirement.toString()),
                          divider(),
                          title("評価"),
                          rattingstar(),
                          divider(),
                          title('レビュー'),
                          SizedBox(
                            width: AppSize.getDeviceWidth(context),
                            height: AppSize.getDeviceHeight(context) * 0.5,
                            child: ListView.builder(
                              itemCount: widget.info.reviews!.length,
                              itemBuilder: (context, index) {
                                return revieww(widget.info, index);
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
              );
            },
          ),
        ),
      ),
    );
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
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selectedShiftList.contains(shiftList[index])) {
                      selectedShiftList.remove(shiftList[index]);
                    } else {
                      selectedShiftList.add(shiftList[index]);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 51,
                        height: 51,
                        decoration: boxDecoration7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dateTimeToMonthDay(shiftList[index].date),
                              style: kNormalText.copyWith(fontFamily: "Bold", fontSize: 13, color: AppColor.primaryColor),
                            ),
                            Text(
                              toJapanWeekDayWithInt(shiftList[index].date!.weekday),
                              style: kNormalText.copyWith(fontFamily: "Normal", fontSize: 9, color: AppColor.primaryColor),
                            )
                          ],
                        ),
                      ),
                      AppSize.spaceWidth16,
                      Text(
                        "${shiftList[index].startWorkTime} 〜 ${shiftList[index].endWorkTime}\n${CurrencyFormatHelper.displayDataRightYen(shiftList[index].price)}",
                        style: kNormalText.copyWith(fontSize: 15, fontFamily: "Normal"),
                      ),
                      AppSize.spaceWidth16,
                      if (selectedShiftList.contains(shiftList[index]))
                        Icon(
                          Icons.check,
                          color: AppColor.primaryColor,
                        )
                      else
                        const SizedBox()
                    ],
                  ),
                ),
              );
            }),
        AppSize.spaceHeight20,
        Text(
          "${toJapanDate(DateTime.now())} ${widget.info.startTimeHour}〜${widget.info.endTimeHour}    ${widget.info.majorOccupation}    ${CurrencyFormatHelper.displayDataRightYen(widget.info.hourlyWag)}",
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
}
