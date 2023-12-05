import 'package:air_job_management/models/worker_model/penalty_worker_model.dart';
import 'package:air_job_management/models/worker_model/review_worker_model.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TabReviewPenalty extends StatefulWidget {
  const TabReviewPenalty({Key? key}) : super(key: key);

  @override
  State<TabReviewPenalty> createState() => _TabReviewPenaltyState();
}

class _TabReviewPenaltyState extends State<TabReviewPenalty> {
  double screenWidth = 0;
  double screenHeight = 0;
  List<ReviewWorkModel> reviewList = [];
  List<PenaltyWorkModel> penaltyList = [];
  late AuthProvider authProvider;
  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    ;
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("レビューとペナルティ"),
        centerTitle: true,
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Material(
                child: Container(
                  height: 50,
                  child: TabBar(
                    physics: const ClampingScrollPhysics(),
                    labelColor: const Color(0xFFEDAD34),
                    unselectedLabelColor: Colors.grey,
                    indicator: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2, color: Color(0xFFEDAD34)),
                      ),
                    ),
                    tabs: [
                      Tab(
                        child: Container(
                          color: const Color(0xF2F2F2),
                          height: 50,
                          width: screenWidth * 0.5,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Review",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          color: const Color(0xF2F2F2),
                          width: screenWidth * 0.5,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Penalty",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TabBar(
              //   tabs: [
              //     //Tab(text: 'Review'),
              //     Tab(
              //       child: Container(
              //         height: 50,
              //         child: const Align(
              //           alignment: Alignment.center,
              //           child: Text("Review"),
              //         ),
              //       ),
              //     ),
              //     const Tab(text: 'Penalty'),
              //   ],
              // ),
              Expanded(
                  child: TabBarView(children: [
                // Column(
                //   children: <Widget>[
                //     SizedBox( height :50, child: actionWidgetReview())
                //   ],
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("review_worker")
                            .where("worker_id", isEqualTo: authProvider.myUser?.uid ?? "")
                            .orderBy("created_at", descending: true)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong, please go back and turn in again!!!');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                              return Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ListTile(
                                    //   title: Text(data["title"],style: const TextStyle(color: Color(0xFFEDAD34)) ),
                                    //   subtitle: Text(data["star"],style: const TextStyle(color: Color(0xFFEDAD34)) ),
                                    // ),
                                    //Text(DateFormat('yyyy-MM-dd').format((data['created_at'] as Timestamp).toDate()))

                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: Text(data["title"], style: const TextStyle(color: Color(0xFFEDAD34), fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("${data["star"]} stars", style: const TextStyle(color: Color(0xFFEDAD34))),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                                        child: Text(
                                          DateFormat('yyyy/MM/dd hh:mma').format((data['created_at'] as Timestamp).toDate()),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //Center(child: Text("Review")),
                //const Center(child: Text("Penalty"))
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("penalty_worker")
                            .where("worker_id", isEqualTo: authProvider.myUser?.uid ?? "")
                            .orderBy("created_at", descending: true)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong, please go back and turn in again!!!');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                              return Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ListTile(
                                    //   title: Text(data["title"],style: const TextStyle(color: Color(0xFFEDAD34)) ),
                                    //   subtitle: Text(data["reason"],style: const TextStyle(color: Color(0xFFEDAD34)) ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: Text(data["title"], style: const TextStyle(color: Color(0xFFEDAD34), fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(data["reason"], style: const TextStyle(color: Color(0xFFEDAD34))),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                                        child: Text(
                                          DateFormat('yyyy/MM/dd hh:mma').format((data['created_at'] as Timestamp).toDate()),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]))
            ],
          )),
    );
  }
}
