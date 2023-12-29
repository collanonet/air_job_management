import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';
import '../../models/worker_model/search_job.dart';
import '../../utils/respnsive.dart';

class FullTimeJob extends StatefulWidget {
  const FullTimeJob({super.key});

  @override
  State<FullTimeJob> createState() => _FullTimeJobState();
}

class _FullTimeJobState extends State<FullTimeJob> {
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
  List<SearchJob> jobSearchList = [];
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  onGetData() async {
    jobSearchList = [];
    var data = await FirebaseFirestore.instance
        .collection("search_job")
        .where('employment_type', isEqualTo: '正社員')
        .get();
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
                      padding: EdgeInsets.only(left: 16, right: 16),
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
                                    'assets/svgs/img.png',
                                    width: Responsive.isMobile(context)
                                        ? 100
                                        : MediaQuery.of(context).size.width *
                                            0.1,
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
                                  child: const Center(
                                    child: Text('条件を保存'),
                                  ),
                                )
                              ],
                            ),
                          ),
                          AppSize.spaceHeight5,
                          dropdown(),
                          searchbox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Divider(
                              height: 2,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 10),
                            child: Row(
                              children: const [
                                Text('検索履歴・保存条件'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(jobSearchList.length, (index) {
                        var info = jobSearchList[index];

                        return item(info);
                      }),
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
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    prefixIconColor: Colors.black,
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
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
                  style: normalTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget item(var info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.grey,
                        blurRadius: 10),
                    BoxShadow(
                        offset: Offset(-1, -1),
                        color: Colors.grey,
                        blurRadius: 10)
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
    );
  }

  Widget data(var info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            info.title.toString(),
            style: titleStyle.copyWith(color: Colors.black),
          ),
          AppSize.spaceHeight5,
          Row(
            children: [
              Text(
                info.company.toString(),
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
                image: NetworkImage(info.image != null && info.image != ""
                    ? info.image
                    : ConstValue.defaultBgImage),
                fit: BoxFit.cover),
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
                        color: AppColor.primaryColor,
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
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(child: Text('アルバイト・パート')),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  // dropdown
  Widget dropdown() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Card(
        color: AppColor.whiteColor,
        child: DropdownMenu<String>(
          width: MediaQuery.of(context).size.width - 40,
          textStyle: kTitleText,
          leadingIcon: Icon(
            Icons.location_pin,
            color: AppColor.primaryColor,
            size: 30,
          ),
          trailingIcon: Container(
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 3,
                color: AppColor.primaryColor,
              ),
            ),
            child: Center(
              child: Text(
                '選択',
                style: normalTextStyle,
              ),
            ),
          ),
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
    );
  }
}
