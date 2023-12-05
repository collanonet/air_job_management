import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/worker_model/job.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:air_job_management/widgets/custom_listview_job.dart';
import 'package:air_job_management/worker_page/myjob/job_detial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FutureJob extends StatefulWidget {
  const FutureJob({super.key});

  @override
  State<FutureJob> createState() => _FutureJobState();
}

class _FutureJobState extends State<FutureJob> {
  final List<bool> _selected = <bool>[true, false, false];
  bool vertical = false;

  //get Day
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime date = DateTime.now();
  List<Widget> catecery = <Widget>[Text('DAY'), Text('WEEK'), Text('MONTH')];
  onGetDay() async {
    jobSearchList = [];
    var bigdata = await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance.collection("job").get();

    if (data.size > 0) {
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        for (var d in bigdata.docs) {
          var infoto = SearchJob.fromJson(d.data());
          infoto.uid = d.id;
          final created = MyDateTimeUtils.convertDateToString(info.createAt!);
          final datetime = MyDateTimeUtils.convertDateToString(date);
          if (info.jobId == infoto.uid && created == datetime) {
            jobSearchList.add(infoto);
          }
        }
      }

      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  // get Wekk
  onGetWeek() async {
    jobSearchList = [];
    var bigdata = await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance.collection("job").get();

    if (data.size > 0) {
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        for (var d in bigdata.docs) {
          var infoto = SearchJob.fromJson(d.data());
          infoto.uid = d.id;

          DateTime start = getDate(date.subtract(Duration(days: date.weekday - 1)));
          DateTime end = getDate(date.add(Duration(days: 7)));
          final created = MyDateTimeUtils.convertDateToString(info.createAt!);
          final datetime = MyDateTimeUtils.convertDateToString(date);
          final s = MyDateTimeUtils.convertDateToString(start);
          final e = MyDateTimeUtils.convertDateToString(end);
          Duration differenceStart = info.createAt!.difference(start);
          Duration differenceEnd = info.createAt!.difference(end);
          if (info.jobId == infoto.uid && (differenceStart.inDays > 0 && differenceEnd.inDays < 0)) {
            jobSearchList.add(infoto);
          }
        }
      }

      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  //get Month
  onGetMonth() async {
    jobSearchList = [];
    var bigdata = await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance.collection("job").get();

    if (data.size > 0) {
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        for (var d in bigdata.docs) {
          var infoto = SearchJob.fromJson(d.data());
          infoto.uid = d.id;

          DateTime start = getDate(date.subtract(Duration(days: date.weekday - 1)));
          DateTime end = getDate(date.add(Duration(days: 31)));
          final created = MyDateTimeUtils.convertDateToString(info.createAt!);
          final datetime = MyDateTimeUtils.convertDateToString(date);
          final s = MyDateTimeUtils.convertDateToString(start);
          final e = MyDateTimeUtils.convertDateToString(end);
          Duration differenceStart = info.createAt!.difference(start);
          Duration differenceEnd = info.createAt!.difference(end);
          if (info.jobId == infoto.uid && (differenceStart.inDays > 0 && differenceEnd.inDays < 0)) {
            jobSearchList.add(infoto);
          }
        }
      }

      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  //future
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  onGetData() async {
    jobSearchList = [];
    var bigdata = await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance.collection("job").where("status", isEqualTo: "pending").get();
    if (data.size > 0) {
      for (var d in data.docs) {
        var info = Myjob.fromJson(d.data());
        for (var d in bigdata.docs) {
          var infoto = SearchJob.fromJson(d.data());
          infoto.uid = d.id;
          if (info.jobId == infoto.uid) {
            jobSearchList.add(infoto);
          }
        }
      }

      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    onGetData();
    super.initState();
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return loading.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ToggleButtons(
                          direction: vertical ? Axis.vertical : Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _selected.length; i++) {
                                _selected[i] = i == index;
                              }
                            });
                            if (index == 0 || index == 1 || index == 2) {
                              isVisible = true;
                            }
                            if (index == 0) {
                              onGetDay();
                            } else if (index == 1) {
                              onGetWeek();
                            } else if (index == 2) {
                              onGetMonth();
                            }
                          },
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          //selectedBorderColor: AppColor.yello,
                          selectedColor: Colors.white,
                          fillColor: AppColor.primaryColor,
                          color: AppColor.primaryColor,
                          constraints: const BoxConstraints(
                            minHeight: 60,
                            minWidth: 100,
                          ),
                          isSelected: _selected,
                          children: catecery,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        onGetData();
                        isVisible = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Clear Filter',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: jobSearchList.length,
                    itemBuilder: (context, index) {
                      var info = jobSearchList[index];
                      return item(info);
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget item(var info) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobScreenDetial(info: info),
            ));
      },
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: CustomListItem(
          subtitle: "${info.startDate.toString()}~${info.endDate.toString()}",
          salary: "${info.salaryRange.toString()} ${info.amountOfPayrollFrom} ${info.amountOfPayrollTo}",
          thumbnail: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(info.image != null && info.image != "" ? info.image : ConstValue.defaultBgImage), fit: BoxFit.cover),
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
          ),
          title: info.title.toString(),
        ),
      ),
    );
  }
}
