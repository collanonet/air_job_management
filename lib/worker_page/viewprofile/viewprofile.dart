import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/api/worker_api/withdraw_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/login.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/worker_page/viewprofile/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'private_policy.dart';
import 'tab_review_penalty.dart';
import 'term_of_use.dart';
import 'withdraw_procedures.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  double rating = 0;
  var ListViewProfile = [
    {
      "title": "アカウント設定",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "レビューとペナルティ",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "あなたのスキル",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "過去の業務と報酬",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "プッシュ通知設定",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "サポート",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "よくある質問",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "プライバシーポリシー",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "利用規約",
      "icon": Icons.arrow_forward_ios,
    },
    {
      "title": "退会手続き",
      "icon": Icons.arrow_forward_ios,
    },
  ];
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  MyUser? myUser;

  @override
  void initState() {
    onChecking();
    super.initState();
  }

  bool isPending = false;

  onChecking() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          myUser = await UserApiServices().getProfileUser(currentUser.uid);
          if (myUser!.rating != null && myUser!.rating != "") {
            rating = double.parse(myUser?.rating ?? "0");
          }
          isLoading.value = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colorxd = const Color(0xFFF38301);
    Color colorxd2 = const Color(0xFFEDAD34);
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
          "マイページ",
          style: TextStyle(
            color: colorxd = const Color(0xFFEDAD34),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                CustomDialog.confirmDialog(
                    context: context,
                    onApprove: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      MyPageRoute.goAndRemoveAll(context, LoginPage());
                    },
                    title: "アカウントをログアウトしてもよろしいですか?");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: isLoading.value
          ? Center(child: LoadingWidget(AppColor.primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: myUser?.profileImage ?? "",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget: (_, str, s) => const CircleAvatar(
                                backgroundImage: AssetImage("assets/image1.jpg"),
                                backgroundColor: Color.fromARGB(255, 206, 205, 205),
                                radius: 80,
                              ),
                            )),
                        Column(
                          children: [
                            Text(
                              "${myUser?.nameKanJi} ${myUser?.nameFu}",
                              style: TextStyle(color: colorxd = const Color(0xFFEDAD34), fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                  border: Border.all(color: colorxd = const Color(0xFFF38301), width: 3), borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "GOLD",
                                style: TextStyle(
                                  color: colorxd = const Color(0xFFF38301),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: RatingBar.builder(
                                      minRating: 1,
                                      updateOnDrag: true,
                                      itemSize: 35,
                                      allowHalfRating: true,
                                      initialRating: rating,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                                      itemBuilder: (((context, _) => Icon(
                                            Icons.grade,
                                            color: colorxd = const Color(0xFFEDAD34),
                                          ))),
                                      onRatingUpdate: (rating) => setState(() {
                                            this.rating = rating;
                                          })),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 360,
                      height: 195,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 234, 233, 233)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(color: colorxd = const Color(0xFFF38301), width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "残高",
                                style: TextStyle(color: colorxd = const Color(0xFFF38301), fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                "¥ ${myUser?.balance}",
                                style: TextStyle(
                                  color: colorxd = const Color(0xFFF38301),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // Container(
                            //   width: 310,
                            //   height: 50,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(7),
                            //     color: colorxd = const Color(0xFFF38301),
                            //   ),
                            //   child: const Padding(
                            //     padding: EdgeInsets.only(top: 10, left: 110),
                            //     child: Text(
                            //       "Withdraw",
                            //       style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                //print("clicked withdraw");
                                //print('full name in view profile${myUser?.firstName} + ${myUser?.lastName}');
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => ConfirmWithdraw(myUser?.balance,myUser?.uid,"${myUser?.firstName} ${myUser?.lastName}")),
                                // );

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("出金の確認", style: TextStyle(color: colorxd2)),
                                        content: Text("本当に退会しますか ¥${myUser?.balance}?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                //MyPageRoute.goToReplace(context, const ViewProfile());
                                                setState(() {
                                                  isPending = false;
                                                  //print('setState ' + isPending.toString());
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text(JapaneseText.cancel)),
                                          ElevatedButton(
                                              onPressed: () async {
                                                //print("clicked Yes");
                                                bool checkPending = await WithdrawApi().isPending(myUser?.uid);
                                                if (checkPending) {
                                                  Navigator.pop(context);
                                                  //You already requested this amount!  Please waiting for approval from admin.
                                                  toastMessageError("この金額はすでにリクエストされています。 管理者からの承認を待ってください。", context);
                                                } else {
                                                  try {
                                                    await WithdrawApi().Withdraw(
                                                        amount: myUser?.balance,
                                                        createdAt: DateTime.now(),
                                                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                        status: "pending",
                                                        time: DateFormat('kk:mm').format(DateTime.now()),
                                                        updatedAt: DateTime.now(),
                                                        workerID: myUser?.uid,
                                                        workerName: "${myUser?.firstName} ${myUser?.lastName}");
                                                    Navigator.pop(context);
                                                    toastMessageSuccess(JapaneseText.successCreate, context);
                                                  } catch (e) {
                                                    toastMessageError(e.toString(), context);
                                                  }
                                                }
                                              },
                                              child: Text(JapaneseText.yes, style: TextStyle(color: colorxd2)))
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                width: 310,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: colorxd = const Color(0xFFF38301),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 10, left: 110),
                                  child: Text(
                                    "引き出す",
                                    style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    chatListWidget(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget chatListWidget() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ListViewProfile.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return chatListItem(ListViewProfile[index]);
        });
  }

  Widget chatListItem(var item) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            if (item == ListViewProfile[0])
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              seeker: myUser!,
                            ))).then((value) {
                  if (value != null) {
                    setState(() {
                      myUser = value;
                    });
                  }
                })
                //  Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountSetting(user: MyUser,)))
              }
            else if (item == ListViewProfile[1])
              {Navigator.push(context, MaterialPageRoute(builder: (context) => const TabReviewPenalty()))}
            else if (item == ListViewProfile[7])
              {Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivatePolicy()))}
            else if (item == ListViewProfile[8])
              {Navigator.push(context, MaterialPageRoute(builder: (context) => const TermOfUse()))}
            else if (item == ListViewProfile[9])
              {Navigator.push(context, MaterialPageRoute(builder: (context) => const WithDrawProcedures()))}
          },
          child: Column(
            children: [
              ListTile(
                title: Text(item["title"], style: const TextStyle(color: Color(0xFFEDAD34), fontWeight: FontWeight.bold)),
                trailing: Icon(
                  item["icon"],
                  color: const Color.fromARGB(255, 253, 196, 50),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    endIndent: 10,
                    color: Color.fromARGB(255, 144, 144, 144),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
