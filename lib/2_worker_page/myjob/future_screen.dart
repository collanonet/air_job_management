import 'package:air_job_management/2_worker_page/myjob/job_detial.dart';
import 'package:air_job_management/api/worker_api/search_api.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/worker_model/job.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/common_utils.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../helper/currency_format.dart';
import '../../helper/japan_date_time.dart';
import '../../models/worker_model/shift.dart';
import '../../utils/app_color.dart';
import '../../utils/style.dart';

class FutureJob extends StatefulWidget {
  final String uid;
  const FutureJob({super.key, required this.uid});

  @override
  State<FutureJob> createState() => _FutureJobState();
}

class _FutureJobState extends State<FutureJob> {
  //get Day
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime selectedDate = DateTime.now();
  DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  SearchJob? infoo;
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  onGetData() async {
    shiftList = [];
    if (user?.uid != null) {
      var data =
          await FirebaseFirestore.instance.collection("job").where("status", isEqualTo: "approved").where("user_id", isEqualTo: user!.uid).get();
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        info.uid = d.id;
        var job = await SearchJobApi().getASearchJob(info.jobId!);
        for (var d in info.shiftList!) {
          shiftList.add(ShiftModel(
              status: d.status,
              myJob: job,
              image: info.image,
              title: info.jobTitle,
              startBreakTime: d.startBreakTime,
              date: d.date,
              endBreakTime: d.endBreakTime,
              endWorkTime: d.endWorkTime,
              price: d.price,
              startWorkTime: d.startWorkTime));
        }
      }
      shiftList.sort((a, b) => a.date!.compareTo(b.date!));
    } else {
      print("User is empty");
    }
    loading.value = false;
    setState(() {});
  }

  @override
  void initState() {
    onGetData();
    super.initState();
  }

  bool isVisible = false;
  List<ShiftModel> shiftList = [];

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
      isLoading: loading.value,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SizedBox(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context),
          child: loading.value
              ? const SizedBox()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCalendarWidget(),
                      shiftList.isEmpty
                          ? const Center(
                              child: EmptyDataWidget(),
                            )
                          : ListView.builder(
                              itemCount: shiftList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var info = shiftList[index];
                                //var data = jobSearchList[index];
                                return item(info);
                              },
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget item(var info) {
    return !CommonUtils.isTheSameDate(selectedDate, info.date)
        ? SizedBox()
        : InkWell(
            onTap: () => MyPageRoute.goTo(
                context,
                ViewJobDetail(
                  shiftModel: info,
                  info: info.myJob,
                )),
            child: SizedBox(
              height: 80,
              width: AppSize.getDeviceWidth(context),
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 5, right: 10),
                      child: Column(
                        children: [
                          Text(
                            dateTimeToMonthDay(info.date),
                            style: kNormalText.copyWith(fontFamily: "Bold", fontSize: 13, color: AppColor.primaryColor),
                          ),
                          Text(
                            toJapanWeekDayWithInt(info.date!.weekday),
                            style: kNormalText.copyWith(fontFamily: "Normal", fontSize: 9, color: AppColor.primaryColor),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 67,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.whiteColor, boxShadow: [
                          BoxShadow(offset: const Offset(1, 1), color: AppColor.greyColor.withOpacity(0.2), blurRadius: 5),
                          BoxShadow(offset: const Offset(-1, -1), color: AppColor.greyColor.withOpacity(0.2), blurRadius: 5)
                        ]),
                        child: Row(
                          children: [
                            Container(
                              width: 94,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                                image: DecorationImage(image: NetworkImage(info.image ?? ConstValue.defaultBgImage), fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        info.title ?? "",
                                        style: kNormalText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${info.startWorkTime} 〜 ${info.endWorkTime}",
                                          style: kNormalText.copyWith(fontSize: 12, fontFamily: "Normal"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          CurrencyFormatHelper.displayData(info.price),
                                          style: kNormalText.copyWith(
                                            color: AppColor.primaryColor,
                                            fontFamily: "Bold",
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  final CalendarController _calendarController = CalendarController();

  _buildCalendarWidget() {
    return SizedBox(
      height: AppSize.getDeviceHeight(context) * 0.6,
      child: SfCalendar(
        headerDateFormat: "yyyy年 MMM",
        maxDate: now.add(const Duration(days: 365)),
        minDate: DateTime(now.year - 1, now.month, now.day),
        showNavigationArrow: true,
        selectionDecoration: BoxDecoration(border: Border.all(width: 2, color: AppColor.primaryColor)),
        headerStyle: CalendarHeaderStyle(
            backgroundColor: AppColor.whiteColor,
            textAlign: TextAlign.center,
            textStyle: kNormalText.copyWith(color: AppColor.primaryColor, fontSize: 18, fontFamily: "Bold")),
        appointmentTextStyle: const TextStyle(fontSize: 30),
        controller: _calendarController,
        view: CalendarView.month,
        onViewChanged: (view) {},
        onTap: (data) {
          setState(() {
            selectedDate = data.date!;
          });
        },
        monthCellBuilder: (context, month) {
          return _buildMonthCellWidget(month);
        },
        headerHeight: 50,
        monthViewSettings: const MonthViewSettings(
            dayFormat: 'EEE',
            agendaStyle: AgendaStyle(dateTextStyle: TextStyle(fontSize: 4), appointmentTextStyle: TextStyle(fontSize: 10)),
            navigationDirection: MonthNavigationDirection.horizontal,
            monthCellStyle:
                MonthCellStyle(trailingDatesTextStyle: TextStyle(color: Colors.grey), leadingDatesTextStyle: TextStyle(color: Colors.grey)),
            agendaItemHeight: 40,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
    );
  }

  _buildMonthCellWidget(month) {
    List<ShiftModel> dataDisplay = [];
    for (int i = 0; i < shiftList.length; i++) {
      if (CommonUtils.isTheSameDate(month.date, shiftList[i].date)) {
        dataDisplay.add(shiftList[i]);
      }
    }
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 1.5, color: Colors.grey.withOpacity(0.3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: Row(
                children: [
                  Text(
                    month.date.day.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: DateTime.now().month != month.date.month
                            ? Colors.grey
                            : DateTime.now().day == month.date.day
                                ? AppColor.primaryColor
                                : Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dataDisplay.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < 2) {
                      return Container(
                        margin: EdgeInsets.only(left: 3, right: 3, top: index > 0 ? 2 : 0),
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(1)),
                        child: Text(
                          "${dataDisplay[index].startWorkTime} ~ ${dataDisplay[index].endWorkTime}",
                          overflow: TextOverflow.ellipsis,
                          style: kNormalText.copyWith(color: Colors.white),
                        ),
                      );
                    } else if (index == 2) {
                      return const Center(
                        child: Text(
                          "...",
                          style: TextStyle(height: 0.4),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: 0,
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
