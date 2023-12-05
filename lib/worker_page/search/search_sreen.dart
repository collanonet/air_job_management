import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/worker_page/search/search_screen_dedial.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime _selectedDate = DateTime.now();
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  onGetData() async {
    jobSearchList = [];
    var data = await FirebaseFirestore.instance
        .collection("search_job")
        .where("end_date", isGreaterThanOrEqualTo: MyDateTimeUtils.convertDateToString(_selectedDate))
        .get();
    if (data.size > 0) {
      for (var d in data.docs) {
        var info = SearchJob.fromJson(d.data());
        info.uid = d.id;
        DateTime startDate = MyDateTimeUtils.fromApiToLocal(info.startDate!);
        startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
        DateTime endDate = MyDateTimeUtils.fromApiToLocal(info.endDate!);
        endDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0);
        if (isDateInRange(_selectedDate, startDate, endDate)) {
          jobSearchList.add(info);
        }
      }
      loading.value = false;
      setState(() {});
    } else {
      loading.value = false;
      setState(() {});
    }
  }

  bool isDateInRange(DateTime chosenDate, DateTime startDate, DateTime endDate) {
    return (chosenDate.isAfter(startDate) || chosenDate == startDate) && (chosenDate.isBefore(endDate) || chosenDate == endDate);
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    onGetData();
  }

  var favoritecollection = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      body: loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    headay(),
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

  Widget product(BuildContext context, var info, var docId, FavoriteProvider fa, int index) {
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
                      image: DecorationImage(
                          image: NetworkImage(info.image != null && info.image != "" ? info.image : ConstValue.defaultBgImage), fit: BoxFit.cover),
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
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       if (info.favorite.contains(info.uid)) {
                      //         fa.add(info, docId);
                      //       } else {
                      //         fa.remove(info, docId);
                      //       }
                      //     });

                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(fa.items.contains(info)
                      //             ? 'Added to favorites.'
                      //             : 'Removed from favorites.'),
                      //         duration: const Duration(seconds: 1),
                      //       ),
                      //     );
                      //   },
                      //   icon: favlist != info.favorite
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

  Widget headay() {
    return SizedBox(
      // color: Colors.amber,
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CalendarTimeline(
            showYears: false,
            initialDate: _selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 60)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
            onDateSelected: (date) => setState(() {
              _selectedDate = date;
              onGetData();
            }),
            leftMargin: 20,
            monthColor: Colors.black,
            dayColor: Colors.teal[200],
            dayNameColor: const Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: AppColor.primaryColor,
            dotsColor: const Color(0xFF333A47),
            // selectableDayPredicate: (date) => date.day != 23,
            locale: 'ja',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
