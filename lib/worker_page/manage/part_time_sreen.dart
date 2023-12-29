import 'package:air_job_management/utils/style.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../models/worker_model/search_job.dart';
import '../../providers/favorite_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/page_route.dart';
import '../search/search_screen_dedial.dart';
import 'filter/filter_option.dart';

class PartTimeJob extends StatefulWidget {
  const PartTimeJob({super.key});

  @override
  State<PartTimeJob> createState() => _PartTimeJobState();
}

class _PartTimeJobState extends State<PartTimeJob> {
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
        .where("end_date",
            isGreaterThanOrEqualTo:
                MyDateTimeUtils.convertDateToString(_selectedDate))
        .get();
    if (data.size > 0) {
      for (var d in data.docs) {
        var info = SearchJob.fromJson(d.data());
        if (info.employmentType != "正社員") {
          info.uid = d.id;
          DateTime startDate = MyDateTimeUtils.fromApiToLocal(info.startDate!);
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
          DateTime endDate = MyDateTimeUtils.fromApiToLocal(info.endDate!);
          endDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0);
          if (isDateInRange(_selectedDate, startDate, endDate)) {
            jobSearchList.add(info);
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

  bool isDateInRange(
      DateTime chosenDate, DateTime startDate, DateTime endDate) {
    return (chosenDate.isAfter(startDate) || chosenDate == startDate) &&
        (chosenDate.isBefore(endDate) || chosenDate == endDate);
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    onGetData();
  }

  var favoritecollection = FirebaseFirestore.instance;

  // lists dropdown
  List<String> list = <String>[
    '海外 ',
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県 ',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県 ',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        body: loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      AppSize.spaceHeight5,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/svgs/img.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),
                      AppSize.spaceHeight5,
                      dropdown(),
                      headay(),
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                MyPageRoute.goTo(context, const FilterOption());
              },
              child: Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swap_horiz,
                      size: 35,
                      color: AppColor.whiteColor,
                    ),
                    AppSize.spaceWidth5,
                    Text(
                      '絞り込み',
                      style:
                          normalTextStyle.copyWith(color: AppColor.whiteColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget product(BuildContext context, var info, var docId, FavoriteProvider fa,
      int index) {
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
                          image: NetworkImage(
                              info.image != null && info.image != ""
                                  ? info.image
                                  : ConstValue.defaultBgImage),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LikeButton(
                        size: 30,
                        circleColor: const CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
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
                            color: isLiked
                                ? Color.fromARGB(255, 255, 170, 0)
                                : Colors.grey,
                            size: 30,
                          );
                        },
                      ),
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
                  style: normalTextStyle,
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
                        style: normalTextStyle.copyWith(fontSize: 13),
                        overflow: TextOverflow.fade)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headay() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context) * 0.16 + 5,
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

  // Dropdown
  Widget dropdown() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Stack(
        children: [
          Card(
            color: AppColor.whiteColor,
            child: DropdownMenu<String>(
              width: MediaQuery.of(context).size.width,
              textStyle: kTitleText,
              leadingIcon: Icon(
                Icons.location_pin,
                color: AppColor.primaryColor,
                size: 30,
              ),
              trailingIcon: SizedBox(),
              initialSelection: list.first,
              onSelected: (String? value) {
                list.first = value!;
                // This is called when the user selects an item.
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ),
          Positioned(
              top: 15,
              bottom: 15,
              right: 20,
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: AppColor.primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    '選択',
                    style:
                        normalTextStyle.copyWith(color: AppColor.primaryColor),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
