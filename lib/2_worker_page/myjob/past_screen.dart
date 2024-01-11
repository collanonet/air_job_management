import 'package:air_job_management/models/worker_model/job.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_listview_job.dart';

class PastJobScreen extends StatefulWidget {
  final String uid;
  const PastJobScreen({super.key, required this.uid});

  @override
  State<PastJobScreen> createState() => _PastJobScreenState();
}

class _PastJobScreenState extends State<PastJobScreen> {
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  onGetData() async {
    jobSearchList = [];

    var bigdata =
        await FirebaseFirestore.instance.collection("search_job").get();
    var data = await FirebaseFirestore.instance
        .collection("job")
        .where("status", isEqualTo: "completed")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : jobSearchList.length == 0
              ? const Center(
                  child: EmptyDataWidget(),
                )
              : ListView.builder(
                  itemCount: jobSearchList.length,
                  itemBuilder: (context, index) {
                    var info = jobSearchList[index];
                    return item(info);
                  },
                ),
    );
  }

  Widget item(var info) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: CustomListItem(
        subtitle: "${info.startDate.toString()}~${info.endDate.toString()}",
        salary:
            "${info.salaryRange.toString()} ${info.amountOfPayrollFrom} ${info.amountOfPayrollTo}",
        thumbnail: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(info.image.toString()),
                  fit: BoxFit.cover),
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )),
        ),
        title: info.title.toString(),
      ),
    );
  }
}
