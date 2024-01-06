import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/worker_page/search/search_screen_dedial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

class FavoriteSreen extends StatefulWidget {
  final String uid;
  FavoriteSreen({super.key, required this.uid});

  @override
  State<FavoriteSreen> createState() => _FavoriteSreenState();
}

class _FavoriteSreenState extends State<FavoriteSreen> {
  var db = FirebaseFirestore.instance;

  List<SearchJob> jobSearchList = [];

  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  onGetData() async {
    jobSearchList = [];
    try {
      var favData = await FirebaseFirestore.instance
          .collection("favourite")
          .doc(widget.uid)
          .get();
      if (favData.exists) {
        List<String> jobIdListFromFav = List<String>.from(
            favData.data()!["search_job_id"].map((e) => e.toString()));
        var data =
            await FirebaseFirestore.instance.collection("search_job").get();
        if (data.size > 0) {
          for (var d in data.docs) {
            if (jobIdListFromFav.contains(d.id)) {
              var info = SearchJob.fromJson(d.data());
              info.uid = d.id;
              jobSearchList.add(info);
            }
          }
          refreshLoadingFalse();
        } else {
          refreshLoadingFalse();
        }
      } else {
        refreshLoadingFalse();
      }
    } catch (e) {
      print("Fav screen Error is $e");
      refreshLoadingFalse();
    }
  }

  refreshLoadingFalse() {
    loading.value = false;
    setState(() {});
  }

  @override
  void initState() {
    onGetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favorite =
        Provider.of<FavoriteProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          'お気に入り',
          style: TextStyle(fontSize: 30, color: AppColor.primaryColor),
        ),
      ),
      body: loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : jobSearchList.isEmpty
              ? Center(child: EmptyDataWidget())
              : SafeArea(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomScrollView(
                              slivers: [
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 350,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 2,
                                          childAspectRatio: 10 / 15,
                                          mainAxisExtent: 300),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      var info = jobSearchList[index];
                                      return product(context, info, info.uid,
                                          favorite, index);
                                    },
                                    childCount: jobSearchList.length,
                                  ),
                                ),
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

  Widget product(BuildContext context, var info, var docId, var fa, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreenDetial(
              isFullTime: true,
              info: info,
              docId: docId,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.whiteColor),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      // color: Colors.black,
                      image: DecorationImage(
                          image: NetworkImage(info.image.toString()),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  info.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: kNormalText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      info.startDate.toString() +
                          " ~ \n${info.endDate.toString()}",
                      style: kNormalText,
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
                    child: Text('${info.fee ?? info.salaryRange}',
                        style: kNormalText.copyWith(fontSize: 13),
                        overflow: TextOverflow.fade)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headay(var itemdata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            itemdata,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  var favoritecollection = FirebaseFirestore.instance.collection('favourite');

  favoriteData({text}) {
    favoritecollection.add(text);
  }
}
