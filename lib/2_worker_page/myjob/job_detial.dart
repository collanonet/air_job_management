import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/helper/currency_format.dart';
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
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../api/company/worker_managment.dart';
import '../../const/const.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_dialog.dart';

class ViewJobDetail extends StatefulWidget {
  ViewJobDetail({key, required this.info, required this.shiftModel}) : super(key: key);
  SearchJob info;
  ShiftModel shiftModel;

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
    shiftList.add(widget.shiftModel);
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
    print("Status ${widget.info.status}");
    FavoriteProvider fa = Provider.of<FavoriteProvider>(context);
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => setState(() {
                fa.onfav(widget.info.uid);
                fa.ontap(widget.info.uid, widget.info);
              }),
              child: Icon(
                Icons.favorite,
                size: 30,
                color: fa.lists.contains(widget.info.uid) ? Colors.yellow : Colors.white,
              ),
            ),
          )
        ],
      ),
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
                          title("待遇"),
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomSheet: Visibility(
        visible: widget.shiftModel.status == "pending" ? true : false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: InkWell(
            onTap: () => cancelJob(),
            child: Container(
              width: AppSize.getDeviceWidth(context),
              height: AppSize.getDeviceHeight(context) * 0.075,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '応募求人のキャンセル',
                  style: kNormalText.copyWith(color: Colors.white),
                ),
              ),
            ),
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
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffFAFFD3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff00000010),
                        offset: Offset(0, 9), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: AppColor.secondaryColor)),
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
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                      )
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

  bool isLoading = false;

  cancelJob() async {
    CustomDialog.confirmDialog(
        context: context,
        onApprove: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          bool isSuccess = await WorkerManagementApiService().updateJobStatus(widget.shiftModel.jobId!, "canceled");
          if (isSuccess) {
            setState(() {
              isLoading = false;
            });
            toastMessageSuccess(JapaneseText.successUpdate, context);
            Navigator.pop(context, true);
          } else {
            setState(() {
              isLoading = false;
            });
            toastMessageSuccess(JapaneseText.failUpdate, context);
          }
        },
        title: "このリクエストをキャンセルしてもよろしいですか?",
        titleText: "ジョブのキャンセル");
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

  Widget googlemap(BuildContext context) {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.4,
      // color: Colors.amber,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: companyLatLng!, zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: false,
        compassEnabled: true,
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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
