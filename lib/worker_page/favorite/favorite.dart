import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/worker_page/search/search_screen_dedial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

class FavoriteSreen extends StatefulWidget {
  FavoriteSreen({super.key});

  @override
  State<FavoriteSreen> createState() => _FavoriteSreenState();
}

class _FavoriteSreenState extends State<FavoriteSreen> {
  var db = FirebaseFirestore.instance;

  List<SearchJob> jobSearchList = [];

  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  onGetData() async {
    jobSearchList = [];
    var data = await FirebaseFirestore.instance.collection("search_job").where("favorite", isEqualTo: true).get();
    if (data.size > 0) {
      for (var d in data.docs) {
        var info = SearchJob.fromJson(d.data());
        info.uid = d.id;
        jobSearchList.add(info);
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
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context, listen: true);
    print(favorite);
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
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 350, mainAxisSpacing: 5, crossAxisSpacing: 2, childAspectRatio: 10 / 15, mainAxisExtent: 300),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  var info = jobSearchList[index];
                                  return product(context, info, info.uid, favorite, index);
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColor.whiteColor),
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
                      image: DecorationImage(image: NetworkImage(info.image.toString()), fit: BoxFit.cover),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LikeButton(
                        size: 30,
                        circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color.fromARGB(255, 229, 51, 51),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        isLiked: info.favorite,
                        likeBuilder: (isLiked) {
                          fa.isfav = isLiked;
                          fa.ontap(docId, info);
                          return Icon(
                            Icons.favorite,
                            color: isLiked ? Color.fromARGB(255, 255, 170, 0) : Colors.grey,
                            size: 30,
                          );
                        },
                        countBuilder: (likeCount, bool isLiked, text) {
                          Widget result;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: result = Text(isLiked ? 'Added to favorites.' : 'Removed from favorites.'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          return result;
                        },
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     !fa.items.contains(info)
                      //         ? fa.add(info, docId)
                      //         : fa.remove(info, docId);
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(fa.items.contains(info)
                      //             ? 'Added to favorites.'
                      //             : 'Removed from favorites.'),
                      //         duration: const Duration(seconds: 1),
                      //       ),
                      //     );
                      //   },
                      //   icon: fa.items.contains(info)
                      //       ? const Icon(
                      //           Icons.favorite,
                      //           color: Colors.yellow,
                      //           size: 30,
                      //         )
                      //       : const Icon(
                      //           Icons.favorite,
                      //           color: Colors.white,
                      //           size: 30,
                      //         ),
                      // ),
                    ],
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
                      info.startDate.toString() + " ~ \n${info.endDate.toString()}",
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
                    child: Text('${info.fee ?? info.salaryRange}', style: kNormalText.copyWith(fontSize: 13), overflow: TextOverflow.fade)),
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
