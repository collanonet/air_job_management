import 'package:air_job_management/2_worker_page/myjob/job_detial.dart';
import 'package:air_job_management/api/worker_api/search_api.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/worker_model/job.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  DateTime date = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  SearchJob? infoo;
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  onGetData() async {
    shiftList = [];
    if (user?.uid != null) {
      var data =
          await FirebaseFirestore.instance.collection("job").where("status", isEqualTo: "pending").where("user_id", isEqualTo: user!.uid).get();
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        info.uid = d.id;
        var job = await SearchJobApi().getASearchJob(info.jobId!);
        print("Get job suscc ${job?.title}");
        for (var d in info.shiftList!) {
          shiftList.add(ShiftModel(
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
    return Scaffold(
      body: loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : shiftList.isEmpty
              ? const Center(
                  child: EmptyDataWidget(),
                )
              : ListView.builder(
                  itemCount: shiftList.length,
                  itemBuilder: (context, index) {
                    var info = shiftList[index];
                    //var data = jobSearchList[index];
                    return item(info);
                  },
                ),
    );
  }

  Widget item(var info) {
    return InkWell(
      onTap: () => MyPageRoute.goTo(
          context,
          ViewJobDetail(
            info: info.myJob,
          )),
      child: SizedBox(
        height: 80,
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
              Container(
                width: 330,
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
                            Text(
                              info.title ?? "",
                              style: kNormalText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
