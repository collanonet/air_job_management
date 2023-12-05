import 'package:air_job_management/models/worker_model/penalty_worker_model.dart';
import 'package:air_job_management/models/worker_model/review_worker_model.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/review_penalty_provider.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewPenalty extends StatefulWidget {
  const ReviewPenalty({Key? key}) : super(key: key);

  @override
  State<ReviewPenalty> createState() => _ReviewPenaltyState();
}

class _ReviewPenaltyState extends State<ReviewPenalty> {
  double screenWidth = 0;
  double screenHeight = 0;
  late ReviewPenaltyProvider reviewPenaltyProvider;
  late AuthProvider authProvider;
  List<ReviewWorkModel> reviewList = [];
  List<PenaltyWorkModel> penaltyList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    onGetDataReview();
    onGetDataPenalty();
    super.initState();
  }

  bool isReview = true;
  onGetDataReview() async {
    reviewList = [];
    var dataReview = await FirebaseFirestore.instance
        .collection("review_worker")
        .where("worker_id", isEqualTo: authProvider.myUser?.uid ?? "")
        .orderBy("created_at", descending: true)
        .get();

    if (dataReview.size > 0) {
      for (var d in dataReview.docs) {
        var infoReview = ReviewWorkModel.fromJson(d.data());
        reviewList.add(infoReview);
      }
      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  onGetDataPenalty() async {
    penaltyList = [];
    var dataPenalty = await FirebaseFirestore.instance
        .collection("penalty_worker")
        .where("worker_id", isEqualTo: authProvider.myUser?.uid ?? "")
        .orderBy("created_at", descending: true)
        .get();
    if (dataPenalty.size > 0) {
      for (var d in dataPenalty.docs) {
        var infoPenalty = PenaltyWorkModel.fromJson(d.data());
        penaltyList.add(infoPenalty);
      }
      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    reviewPenaltyProvider = Provider.of<ReviewPenaltyProvider>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var item = reviewPenaltyProvider.tagList[index];
                    return GestureDetector(
                      onTap: () {
                        reviewPenaltyProvider.onChangeTage(item);
                        setState(() {
                          if (reviewPenaltyProvider.tagSelected == "Review") {
                            isReview = true;
                            //print(isReview);
                          } else {
                            isReview = false;
                            //print(isReview);
                          }
                        });
                      },
                      child: Container(
                        width: screenWidth * 0.5,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: reviewPenaltyProvider.tagSelected == item ? Color(0xFFEDAD34) : Colors.grey),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${reviewPenaltyProvider.tagList[index]}',
                          style: TextStyle(
                              color: reviewPenaltyProvider.tagSelected == item ? Color(0xFFEDAD34) : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    );
                  },
                  itemCount: reviewPenaltyProvider.tagList.length,
                ),
              ),
            ],
          ),
          isReview ? actionWidgetReview() : actionWidgetPenalty(),
        ],
      ),
    ));
  }

  Widget actionWidgetReview() {
    //print("reviewList count " + reviewList.length.toString());
    return
        // Expanded(
        // child:
        // ListView.builder(
        //   itemCount: 2,
        //   itemBuilder: (BuildContext context, int index) => ListTile(
        //     title: Text("List Item ${index + 1} "),
        //   ),
        // )
        // );

        reviewList.isEmpty
            ? const Center(child: EmptyDataWidget())
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: reviewList?.length ?? 0,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: //FirebaseFirestore.instance.collection("review_worker").doc().get(),
                        FirebaseFirestore.instance
                            .collection("review_worker")
                            .where("worker_id", isEqualTo: authProvider.myUser?.uid ?? "")
                            .orderBy("created_at", descending: true)
                            .get(),
                    builder: (context, snapshot) {
                      var data = snapshot.data!.docs[index].data();
                      //var data = snapshot.data?.data();
                      //print("data ${data?.length}");
                      var review = ReviewWorkModel.fromJson(data as Map<String, dynamic>);
                      bool isLoading = snapshot.connectionState == ConnectionState.waiting;
                      if (data == null) {
                        return const SizedBox();
                      }
                      return Text("Has Data")
                          //   ListTile(
                          //   title: Text(data["title"]),
                          //   //subtitle: ,
                          // )
                          ;
                    },
                  );
                },
              );
  }

  Widget actionWidgetPenalty() {
    //print("penaltyList count " + penaltyList.length.toString());
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // FutureBuilder(
          //     future: FirebaseFirestore.instance
          //         .collection("review_worker")
          //         .where("worker_id",
          //         isEqualTo: authProvider.myUser?.uid ?? "")
          //         .orderBy("created_at", descending: true)
          //         .get(),
          //     builder: (context,snapshot){
          //       if(snapshot.hasData)
          //       {print(snapshot.connectionState);
          //       print(snapshot.hasData);
          //       return CircularProgressIndicator();
          //       }else return ListView.builder(
          //           itemCount: snapshot.data?.docs.length ?? 0,
          //           itemBuilder: (context,index){
          //             var data = snapshot.data!.docs[index].data();
          //             var penalty = PenaltyWorkModel.fromJson(data as Map<String, dynamic>);
          //             print(penalty.title);
          //             //return SectionCard(snapshot: snapshot.data[index]);
          //             //     return Flexible(
          //             //       child: Card(child: ListTile(
          //             //         leading: ImageCard(imageSource: snapshot.data.image.toString(),),
          //             //         title: snapshot.data[index].title,
          //             //         subtitle: snapshot.data[index].pdf,
          //             //       ),),
          //             //     );
          //           });
          //     })
        ],
      ),
    );
  }
}
