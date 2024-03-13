import 'package:air_job_management/helper/currency_format.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/worker/filter.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../models/worker_model/search_job.dart';
import '../../providers/favorite_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/my_route.dart';
import '../search/search_job_detail.dart';
import 'filter/filter_option.dart';

class PartTimeJob extends StatefulWidget {
  final bool isFullTime;
  const PartTimeJob({super.key, required this.isFullTime});

  @override
  State<PartTimeJob> createState() => _PartTimeJobState();
}

class _PartTimeJobState extends State<PartTimeJob> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _dateList = [];
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  late WorkerFilter filterProvider;
  late FavoriteProvider favorite;
  late AuthProvider auth;

  onGetData() async {
    jobSearchList = [];
    try {
      Provider.of<FavoriteProvider>(context, listen: false).onget();
      var data = await FirebaseFirestore.instance
          .collection("search_job")
          .where("end_date", isGreaterThanOrEqualTo: MyDateTimeUtils.convertDateToString(_selectedDate))
          .get();
      if (data.size > 0) {
        for (var d in data.docs) {
          var info = SearchJob.fromJson(d.data());
          if (info.employmentType != "正社員") {
            info.uid = d.id;
            DateTime startDate = MyDateTimeUtils.fromApiToLocal(info.startDate!);
            startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
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
    } catch (e) {
      print("Error $e");
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
    _dateList.add(_selectedDate);
    for (var i = 1; i <= 6; ++i) {
      _dateList.add(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + i));
    }
    onGetData();
  }

  var favoritecollection = FirebaseFirestore.instance;

  // lists dropdown
  List<String> list = <String>[
    JapaneseText.all,
    '海外',
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

  filterJobLocation() async {
    await onGetData();
    if (selectedLocation != null && selectedLocation != JapaneseText.all) {
      List<SearchJob> filterByLocation = [];
      for (var jobSearch in jobSearchList) {
        if (jobSearch.jobLocation!.contains(selectedLocation!)) {
          filterByLocation.add(jobSearch);
        }
      }
      setState(() {
        jobSearchList = filterByLocation;
      });
    }
  }

  onFilterJobTypeAndPrice() async {
    await filterJobLocation();
    List<SearchJob> filterJob = [];
    for (var jobSearch in jobSearchList) {
      double hourlyWage = jobSearch.hourlyWag != null ? double.parse(jobSearch.hourlyWag.toString()) : 0;
      if (filterProvider.selectedOccupation.isNotEmpty && filterProvider.selectedReward != null) {
        String price = filterProvider.selectedReward!.replaceAll(",", "").split("円〜")[0].toString();
        double hourlyWageFilter = double.parse(price);
        if (filterProvider.selectedOccupation.contains(jobSearch.majorOccupation) && hourlyWage >= hourlyWageFilter) {
          filterJob.add(jobSearch);
        }
      } else if (filterProvider.selectedOccupation.isNotEmpty && filterProvider.selectedReward == null) {
        if (filterProvider.selectedOccupation.contains(jobSearch.majorOccupation)) {
          filterJob.add(jobSearch);
        }
      } else if (filterProvider.selectedOccupation.isEmpty && filterProvider.selectedReward != null) {
        String price = filterProvider.selectedReward!.replaceAll(",", "").split("円〜")[0].toString();
        double hourlyWageFilter = double.parse(price);
        if (hourlyWage >= hourlyWageFilter) {
          filterJob.add(jobSearch);
        }
      } else {
        filterJob = jobSearchList;
      }
    }
    setState(() {
      jobSearchList = filterJob;
    });
  }

  @override
  Widget build(BuildContext context) {
    favorite = Provider.of<FavoriteProvider>(context);
    filterProvider = Provider.of<WorkerFilter>(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: loading.value
            ? Center(
                child: LoadingWidget(AppColor.primaryColor),
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
                            'assets/logo22.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ),
                      AppSize.spaceHeight5,
                      dropdown(),
                      AppSize.spaceHeight16,
                      headDay(),
                      AppSize.spaceHeight16,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${toJapanMonthAndYearDay(_selectedDate)}",
                          style: kNormalText.copyWith(color: AppColor.primaryColor),
                        ),
                      ),
                      AppSize.spaceHeight16,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: jobSearchList.isEmpty
                              ? const Center(child: EmptyDataWidget())
                              : CustomScrollView(
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterOption())).then((value) {
                  if (value != null && value == true) {
                    onFilterJobTypeAndPrice();
                  }
                });
              },
              child: Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor.secondaryColor, border: Border.all(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 30,
                      color: AppColor.whiteColor,
                    ),
                    AppSize.spaceWidth5,
                    Text(
                      '絞り込み',
                      style: normalTextStyle.copyWith(
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget product(BuildContext context, SearchJob info, var docId, FavoriteProvider fa, int index) {
    return Container(
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
                  isFullTime: widget.isFullTime,
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
                      height: 150,
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
                  style: normalTextStyle.copyWith(fontSize: 14, color: AppColor.primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${toJapanMonthAndDay(info.createdAt ?? _selectedDate)} ${info.startTimeHour}~${info.endTimeHour}",
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
                        style: normalTextStyle.copyWith(fontSize: 16, color: AppColor.primaryColor, fontWeight: FontWeight.w600))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headDay() {
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: 70,
      child: ListView.builder(
          itemCount: _dateList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var date = _dateList[index];
            return Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: _selectedDate == date ? AppColor.primaryColor : Colors.white),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index == 0 ? "きょう" : date.day.toString(),
                        style: kTitleText.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600, color: _selectedDate == date ? Colors.white : AppColor.primaryColor),
                      ),
                      Text(toJapanWeekDayWithInt(date.weekday),
                          style: kSubtitleText.copyWith(
                              fontSize: 10, fontWeight: FontWeight.normal, color: _selectedDate == date ? Colors.white : AppColor.primaryColor))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  String? selectedLocation;
  // dropdown
  Widget dropdown() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(color: AppColor.whiteColor, borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  value: selectedLocation,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedLocation = v;
                    });
                    filterJobLocation();
                  })),
        ),
        Positioned(
          left: 8,
          top: 10,
          child: Icon(
            Icons.location_pin,
            color: AppColor.primaryColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
