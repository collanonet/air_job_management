import 'package:air_job_management/2_worker_page/search/search_screen_dedial.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../helper/currency_format.dart';
import '../../providers/auth.dart';
import '../../utils/app_color.dart';
import '../../utils/my_route.dart';
import '../../widgets/loading.dart';

class FavoriteSreen extends StatefulWidget {
  final String uid;
  FavoriteSreen({super.key, required this.uid});

  @override
  State<FavoriteSreen> createState() => _FavoriteSreenState();
}

class _FavoriteSreenState extends State<FavoriteSreen> {
  // var db = FirebaseFirestore.instance;
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  onGetData() async {
    try {
      var data = await FirebaseFirestore.instance.collection("search_job").get();
      if (data.size > 0) {
        for (var d in data.docs) {
          var info = SearchJob.fromJson(d.data());
          info.uid = d.id;
          var user = AuthProvider().firebaseAuth.currentUser!.uid;
          var favdata = FirebaseFirestore.instance;
          final docRef = favdata.collection("favourite").doc(user);
          docRef.get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              var favjob = data["search_job_id"] ?? [];
              for (var i = 0; i < favjob.length; i++) {
                if (info.uid == favjob[i]) {
                  setState(() {
                    jobSearchList.add(info);
                  });
                }
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
        }
        loading.value = false;
        setState(() {});
      } else {
        loading.value = false;
        setState(() {});
      }
    } catch (e) {
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
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.bgPageColor,
        leading: SizedBox(),
        elevation: 0,
        title: Text(
          'お気に入り',
          style: TextStyle(fontSize: 30, color: AppColor.primaryColor),
        ),
      ),
      body: loading.value
          ? LoadingWidget(AppColor.primaryColor)
          : SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      child: jobSearchList.isEmpty
                          ? const EmptyDataWidget()
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomScrollView(
                                key: GlobalKey(),
                                slivers: [
                                  SliverGrid(
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 350,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 10 / 15,
                                        mainAxisExtent: 260),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        var info = jobSearchList[index];
                                        return product(context, info, info.uid, favorite, index, auth);
                                      },
                                      childCount: jobSearchList.length,
                                    ),
                                  ),
                                ],
                              )),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget product(BuildContext context, SearchJob info, var docId, FavoriteProvider fa, int index, var auth) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor.whiteColor),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreenDetial(
                    info: info,
                    docId: docId,
                    index: index,
                    isFullTime: false,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        height: 109,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                          child: Image.network(info.image != null && info.image != "" ? info.image! : ConstValue.defaultBgImage, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(color: AppColor.bgPageColor, shape: BoxShape.circle),
                            child: Center(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (FirebaseAuth.instance.currentUser != null) {
                                        fa.onfav(info.uid);
                                        fa.ontap(docId, info);
                                      } else {
                                        context.go(MyRoute.login);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    size: 25,
                                    color: fa.lists.contains(info.uid) ? Colors.yellow : Colors.white,
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    info.title.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: kNormalText.copyWith(fontSize: 14, color: AppColor.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " ${info.startTimeHour}~${info.endTimeHour}",
                        style: kNormalText.copyWith(fontSize: 10, color: AppColor.greyColor),
                      ),
                      // Text(info.totime.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(CurrencyFormatHelper.displayData(info.hourlyWag),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kNormalText.copyWith(fontSize: 16, color: AppColor.primaryColor, fontWeight: FontWeight.w600))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
