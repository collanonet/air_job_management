import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';
import '../../models/worker_model/search_job.dart';
import '../../utils/respnsive.dart';
import '../search/search_job_detail.dart';

class FullTimeJob extends StatefulWidget {
  final bool isFullTime;
  const FullTimeJob({super.key, required this.isFullTime});

  @override
  State<FullTimeJob> createState() => _FullTimeJobState();
}

class _FullTimeJobState extends State<FullTimeJob> {
  // lists dropdown
  bool isSortByRelevance = true;
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
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  onGetData() async {
    jobSearchList = [];
    var data = await FirebaseFirestore.instance.collection("search_job").where('employment_type', isEqualTo: '正社員').get();
    if (data.size > 0) {
      for (var d in data.docs) {
        var info = SearchJob.fromJson(d.data());

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

  TextEditingController searcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppSize.spaceHeight5,
                          SizedBox(
                            width: AppSize.getDeviceWidth(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/logo22.png',
                                    width: Responsive.isMobile(context) ? 100 : 120,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor.whiteColor,
                                        width: 2,
                                      )),
                                  child: Center(
                                    child: Text(
                                      '条件を保存',
                                      style: kNormalText.copyWith(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          AppSize.spaceHeight5,
                          dropdown(),
                          searchbox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Divider(
                              height: 2,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, bottom: 10),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' 検索履歴・保存条件',
                                    style: normalTextStyle.copyWith(fontFamily: "Normal", fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 16, right: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSortByRelevance = !isSortByRelevance;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSortByRelevance ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: AppColor.primaryColor,
                              ),
                              Text(
                                ' 関連性順',
                                style: normalTextStyle.copyWith(fontFamily: "Normal", fontSize: 12, color: AppColor.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: List.generate(jobSearchList.length, (index) {
                          var info = jobSearchList[index];

                          return item(info, index);
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  // Search
  Widget searchbox() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                //border: Border.all(width: 1, color: AppColor.colorPrimary)
              ),
              padding: const EdgeInsets.only(top: 4),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30,
                    color: AppColor.primaryColor,
                  ),
                  prefixIconColor: Colors.black,
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          AppSize.spaceWidth16,
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2, color: AppColor.whiteColor)),
              child: Center(
                child: Text(
                  '検索',
                  style: normalTextStyle.copyWith(fontSize: 18, fontFamily: "Bold", color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget item(SearchJob info, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreenDetial(
              info: info,
              docId: info.uid,
              index: index,
              isFullTime: widget.isFullTime,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: AppColor.whiteColor, borderRadius: BorderRadius.circular(10), boxShadow: const [
                  BoxShadow(offset: Offset(1, 1), color: Colors.grey, blurRadius: 10),
                  BoxShadow(offset: Offset(-1, -1), color: Colors.grey, blurRadius: 10)
                ]),
                child: Column(
                  children: [
                    under(info),
                    data(info),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget data(var info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            info.title.toString(),
            style: titleStyle.copyWith(color: AppColor.primaryColor, fontSize: 16),
          ),
          AppSize.spaceHeight5,
          Row(
            children: [
              Text(
                info.company.toString(),
                style: kNormalText,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: AppColor.primaryColor,
              ),
              AppSize.spaceWidth5,
              Text(info.location.des.toString())
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.currency_yen,
                color: AppColor.primaryColor,
              ),
              AppSize.spaceWidth5,
              Text('${info.fee ?? info.salaryRange}')
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.folder,
                color: AppColor.primaryColor,
              ),
              AppSize.spaceWidth5,
              Text(info.occupationType.toString())
            ],
          )
        ],
      ),
    );
  }

  Widget under(var info) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 165,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            image: DecorationImage(
                image: NetworkImage(info.image != null && info.image != "" ? info.image : ConstValue.defaultBgImage), fit: BoxFit.cover),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 30,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.bookmark_border,
                        color: AppColor.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 65,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                      child: Text(
                    'アルバイト・パート',
                    style: kNormalText,
                  )),
                ),
              ],
            ),
          ],
        )
      ],
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
