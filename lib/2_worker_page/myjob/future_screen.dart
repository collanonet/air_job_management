import 'package:air_job_management/2_worker_page/myjob/job_detial.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/worker_model/job.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/widgets/custom_listview_job.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FutureJob extends StatefulWidget {
  final String uid;
  const FutureJob({super.key, required this.uid});

  @override
  State<FutureJob> createState() => _FutureJobState();
}

class _FutureJobState extends State<FutureJob> {
  final List<bool> _selected = <bool>[true, false, false];
  bool vertical = false;

  //get Day
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime date = DateTime.now();
  //future
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  onGetData() async {
    jobSearchList = [];
    var bigdata =
        await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance
        .collection("job")
        .where("status", isEqualTo: "pending")
        .where("user_id", isEqualTo: widget.uid)
        .get();
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
            body: jobSearchList.isEmpty
                ? const Center(child: EmptyDataWidget())
                : ListView.builder(
                    itemCount: jobSearchList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var info = jobSearchList[index];
                      return item(info);
                    },
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
          salary:
              "${info.salaryRange.toString()} ${info.amountOfPayrollFrom} ${info.amountOfPayrollTo}",
          thumbnail: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(info.image != null && info.image != ""
                        ? info.image
                        : ConstValue.defaultBgImage),
                    fit: BoxFit.cover),
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
