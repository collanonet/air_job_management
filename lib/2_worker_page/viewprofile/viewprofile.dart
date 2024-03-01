import 'package:air_job_management/2_worker_page/viewprofile/identification_doc/identification_menu.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/contact_us.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/faq.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/logout.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/unsubsribe.dart';
import 'package:air_job_management/2_worker_page/viewprofile/setting/account_setting.dart';
import 'package:air_job_management/2_worker_page/viewprofile/setting/location_setting.dart';
import 'package:air_job_management/2_worker_page/viewprofile/setting/notification.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/login.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_dialog.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/worker_api/withdraw_api.dart';
import '../../utils/toast_message_util.dart';
import 'edit_profile/edit_profile.dart';
import 'other_setting/private_policy.dart';
import 'other_setting/term_of_use.dart';
import 'other_setting/withdraw_procedures.dart';

class ViewProfile extends StatefulWidget {
  final bool isFullTime;
  const ViewProfile({super.key, required this.isFullTime});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  double rating = 0;
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
      } else {
        isLoading.value = false;
        setState(() {});
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
          myUser == null
              ? IconButton(
                  onPressed: () => MyPageRoute.goTo(
                      context,
                      LoginPage(
                        isFromWorker: true,
                        isFullTime: widget.isFullTime,
                      )),
                  icon: Icon(
                    Icons.login,
                    color: AppColor.primaryColor,
                  ))
              : IconButton(
                  onPressed: () => MyPageRoute.goTo(context, const LogoutPage()),
                  icon: Icon(
                    Icons.logout,
                    color: AppColor.primaryColor,
                  ))
        ],
      ),
      body: isLoading.value
          ? Center(child: LoadingWidget(AppColor.primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    myUser == null
                        ? SizedBox()
                        : Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: myUser?.profileImage ?? "",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, str, s) => ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                          "assets/image1.jpg",
                                          width: 100,
                                          height: 100,
                                        )),
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "${myUser?.nameKanJi}",
                                style: TextStyle(color: colorxd = const Color(0xFFEDAD34), fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ],
                          ),
                    const SizedBox(height: 40),
                    myUser == null
                        ? const SizedBox()
                        : Container(
                            width: 360,
                            height: 195,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
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
                                    alignment: Alignment.center,
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
                                  InkWell(
                                    onTap: () {
                                      CustomDialog.confirmDialog(
                                          context: context,
                                          title: "本当に出金しますか？",
                                          titleText: "出金の確認",
                                          onApprove: () async {
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
                                          });
                                    },
                                    child: Container(
                                      width: 310,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: colorxd = const Color(0xFFF38301),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "引き出す",
                                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    myUser == null
                        ? const SizedBox()
                        : const SizedBox(
                            height: 20,
                          ),
                    // chatListWidget(),
                    AbsorbPointer(
                      absorbing: myUser == null ? true : false,
                      child: Container(
                        width: AppSize.getDeviceWidth(context),
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAccount(),
                              AppSize.spaceHeight16,
                              buildJobHistory(),
                              AppSize.spaceHeight16,
                              buildSetting(),
                              buildOtherSetting()
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.account,
          style: kNormalText.copyWith(fontWeight: FontWeight.w600, color: AppColor.primaryColor),
        ),
        AppSize.spaceHeight16,
        customListTile(JapaneseText.identification, onTap: () => MyPageRoute.goTo(context, const IdentificationMenuPage())),
        customListTile(JapaneseText.editProfile, onTap: () {
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
          });
        }),
        // customListTile(JapaneseText.reviewHistory, onTap: () => {}),
      ],
    );
  }

  Widget buildJobHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.jobHistory,
          style: kNormalText.copyWith(fontWeight: FontWeight.w600, color: AppColor.primaryColor),
        ),
        AppSize.spaceHeight16,
        customListTile(JapaneseText.compensationManagement, onTap: () => toastMessageSuccess("未実施", context)),
        customListTile(JapaneseText.completedWork, onTap: () => toastMessageSuccess("未実施", context)),
        customListTile(JapaneseText.checkingAndPrintingTheWithholdingTaxSlip, onTap: () => toastMessageSuccess("未実施", context)),
      ],
    );
  }

  Widget buildSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JapaneseText.setting,
          style: kNormalText.copyWith(fontWeight: FontWeight.w600, color: AppColor.primaryColor),
        ),
        AppSize.spaceHeight16,
        customListTile(JapaneseText.accountSetting,
            onTap: () => MyPageRoute.goTo(
                context,
                AccountSettingPage(
                  myUser: myUser,
                ))),
        customListTile(JapaneseText.locationInfoSetting, onTap: () => MyPageRoute.goTo(context, const LocationSettingPage())),
        customListTile(JapaneseText.pushNotificationSetting, onTap: () => MyPageRoute.goTo(context, const NotificationSettingPage())),
        AppSize.spaceHeight16,
        Text(
          JapaneseText.support,
          style: kNormalText.copyWith(fontWeight: FontWeight.w600, color: AppColor.primaryColor),
        ),
        AppSize.spaceHeight16,
        customListTile(JapaneseText.faq, onTap: () => MyPageRoute.goTo(context, const FAQPage())),
        customListTile(JapaneseText.inquiry, onTap: () => MyPageRoute.goTo(context, const ContactUsPage())),
      ],
    );
  }

  Widget buildOtherSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customListTile(JapaneseText.privacy, onTap: () => MyPageRoute.goTo(context, const PrivatePolicy())),
        customListTile(JapaneseText.termsOfService, onTap: () => MyPageRoute.goTo(context, const TermOfUse())),
        customListTile(JapaneseText.rangeOfOccupationsHandled, onTap: () => MyPageRoute.goTo(context, const WithDrawProcedures())),
        customListTile(JapaneseText.unsubscribed, onTap: () => MyPageRoute.goTo(context, const UnsubscribePage())),
        customListTile(JapaneseText.logout, onTap: () => MyPageRoute.goTo(context, const LogoutPage())),
      ],
    );
  }

  customListTile(String title, {required Function onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () => onTap(),
          title: Text(title, style: kNormalText),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColor.primaryColor,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), child: Divider()),
      ],
    );
  }
}
