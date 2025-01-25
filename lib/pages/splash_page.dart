import 'dart:html' as html;
import 'dart:js' as js;

import 'package:air_job_management/1_company_page/home/widgets/choose_branch.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/private_policy.dart';
import 'package:air_job_management/2_worker_page/viewprofile/other_setting/term_of_use.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/helper/role_helper.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/register/verify_user.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/utils/respnsive.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../utils/app_size.dart';

bool isFullTime = false;

class SplashScreen extends StatefulWidget {
  final bool isFromWorker;
  const SplashScreen({Key? key, required this.isFromWorker}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterBuildMixin {
  late var user;
  bool isSplash = true;
  ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  startTime() async {
    var user = FirebaseAuth.instance.currentUser;
    if (GoRouter.of(context).location == "/") {
      if (user != null) {
        // await FirebaseAuth.instance.currentUser?.reload();
        bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
        MyUser? users = await UserApiServices().getProfileUser(user.uid);
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.setProfile = users;
        if (company != null) {
          authProvider.setCompany = company;
          authProvider.branch = mainBranch;
          context.go(MyRoute.companyInformationManagement);
        } else {
          if (users!.role == RoleHelper.admin) {
            context.go(MyRoute.dashboard);
          } else if (users.role == RoleHelper.worker && isEmailVerified == true) {
            if (users.isFullTimeStaff == true) {
              isFullTime = true;
              context.go(MyRoute.workerSearchJobPage);
            } else {
              isFullTime = false;
              context.go(MyRoute.workerSearchJobPage);
            }
          } else if (users.role == RoleHelper.worker && isEmailVerified == false) {
            MyPageRoute.goToReplace(
                context,
                VerifyUserEmailPage(
                  myUser: users,
                  isFullTime: users.isFullTimeStaff!,
                ));
          }
        }
      } else {
        setState(() {
          isSplash = false;
        });
      }
    } else {
      if (user != null) {
        MyUser? users = await UserApiServices().getProfileUser(user.uid);
        AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (users?.role == null) {
          if (GoRouter.of(context).location.toString().contains("company")) {
            context.go(MyRoute.companyInformationManagement);
          } else {
            authProvider.branch = mainBranch;
            context.go(MyRoute.companyInformationManagement);
          }
        }
      } else {
        setState(() {
          isSplash = false;
        });
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startTime();
    });
    super.initState();
  }

  double homeSize = 0;
  double aboutUs = 0;
  double contactUs = 0;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User?>(context);
    homeSize = AppSize.getDeviceHeight(context) * 0.9;
    aboutUs = homeSize + 30;
    contactUs = aboutUs + homeSize + 60;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: isSplash ? const LoadingWidget(Colors.white) : landingPage(),
    );
  }

  String hoverText = "";

  landingPage() {
    if (Responsive.isMobile(context)) {
      return Container(
        color: Colors.white,
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSize.getDeviceWidth(context),
              color: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Center(
                      child: Image.asset(
                        "assets/logo22.png",
                        width: 250,
                      ),
                    ),
                  )),
                  PopupMenuButton<MenuEnum>(
                    color: Colors.white,
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    tooltip: "Menu",
                    onSelected: (MenuEnum result) async {
                      if (result == MenuEnum.worker) {
                        // toastMessageError("このオプションは利用できません。モバイルアプリのシーカーを使用してください。", context);
                        String userAgent = html.window.navigator.userAgent;
                        if (userAgent.contains('Mac OS')) {
                          js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                        } else if (userAgent.contains('Windows')) {
                          js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                        } else {
                          if (userAgent.contains('iOS')) {
                            js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                          } else {
                            js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                          }
                        }
                      } else if (result == MenuEnum.home) {
                        scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
                      } else if (result == MenuEnum.aboutUs) {
                        scrollController.animateTo(1050, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
                      } else if (result == MenuEnum.contactUs) {
                        scrollController.animateTo(scrollController.position.maxScrollExtent - 340,
                            duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
                      } else {
                        toastMessageError("This options is not available for mobile", context);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuEnum>>[
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.home,
                        child: Text(
                          JapaneseText.home,
                          style: kNormalText,
                        ),
                      ),
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.contactUs,
                        child: Text(
                          JapaneseText.contactUs,
                          style: kNormalText,
                        ),
                      ),
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.aboutUs,
                        child: Text(
                          JapaneseText.aboutUs,
                          style: kNormalText,
                        ),
                      ),
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.worker,
                        child: Text(
                          JapaneseText.jobSeekerPage,
                          style: kNormalText,
                        ),
                      ),
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.company,
                        child: Text(
                          JapaneseText.company,
                          style: kNormalText,
                        ),
                      ),
                      PopupMenuItem<MenuEnum>(
                        value: MenuEnum.home,
                        child: Text(
                          JapaneseText.home,
                          style: kNormalText,
                        ),
                      ),
                    ],
                  ),
                  AppSize.spaceWidth8,
                ],
              ),
            ),
            Expanded(
                child: Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(children: [
                          Text(
                            JapaneseText.home,
                            style: kTitleText.copyWith(fontSize: 30, color: Colors.black),
                          ),
                          AppSize.spaceHeight16,
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "いつでも働き、\n今すぐ報酬を得る",
                                  style: kTitleText.copyWith(fontSize: 30, color: Colors.black),
                                ),
                                AppSize.spaceHeight16,
                                Text(
                                  "Air Jobなら、もう厳しいスケジュールに縛られることはありません。\n自分の都合に合わせて働き、20分以内に報酬を受け取る。\n面接も履歴書も必要ありません。",
                                  style: kNormalText.copyWith(fontSize: 16, color: Colors.black),
                                ),
                                AppSize.spaceHeight16,
                                InkWell(
                                  onTap: () {
                                    String userAgent = html.window.navigator.userAgent;
                                    if (userAgent.contains('Mac OS')) {
                                      js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                                    } else if (userAgent.contains('Windows')) {
                                      js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                                    } else {
                                      if (userAgent.contains('iOS')) {
                                        js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                                      } else {
                                        js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                                      }
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/download.jpeg",
                                    height: 200,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 500,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 16,
                                  child: Image.asset(
                                    "assets/home.png",
                                    height: 400,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Image.asset(
                                    "assets/calendar.png",
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  left: 100,
                                  child: SvgPicture.asset(
                                    "assets/person.svg",
                                    height: 400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppColor.primaryColor.withOpacity(0.3),
                            // height: AppSize.getDeviceHeight(context),
                            child: Column(
                              children: [
                                AppSize.spaceHeight30,
                                Text(
                                  JapaneseText.aboutUs,
                                  style: kTitleText.copyWith(fontSize: 30, color: Colors.black),
                                ),
                                AppSize.spaceHeight30,
                                Container(
                                  width: 700,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                                  padding: const EdgeInsets.all(32),
                                  margin: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/calendar.png",
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "好きなだけ働く",
                                      style: kNormalText.copyWith(fontSize: 30, color: Colors.black, fontFamily: "Bold"),
                                    ),
                                    AppSize.spaceHeight16,
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: 400,
                                        child: Text(
                                          "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                          style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSize.spaceHeight30,
                                Container(
                                  width: 700,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                                  padding: const EdgeInsets.all(32),
                                  margin: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/calendar.png",
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "好きなだけ働く",
                                      style: kNormalText.copyWith(fontSize: 30, color: Colors.black, fontFamily: "Bold"),
                                    ),
                                    AppSize.spaceHeight16,
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: 400,
                                        child: Text(
                                          "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                          style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSize.spaceHeight30,
                              ],
                            ),
                          ),
                          Container(
                              width: AppSize.getDeviceWidth(context),
                              color: Colors.white,
                              child: Column(children: [
                                AppSize.spaceHeight30,
                                Text(
                                  JapaneseText.contactUs,
                                  style: kTitleText.copyWith(fontSize: 30, color: Colors.black),
                                ),
                                AppSize.spaceHeight30,
                                Column(
                                  children: [
                                    SizedBox(
                                      width: AppSize.getDeviceWidth(context) * 0.9,
                                      child: PrimaryTextField(
                                        hint: JapaneseText.email,
                                        controller: emailController,
                                        isRequired: false,
                                      ),
                                    ),
                                    AppSize.spaceHeight16,
                                    SizedBox(
                                      width: AppSize.getDeviceWidth(context) * 0.9,
                                      child: PrimaryTextField(
                                        hint: JapaneseText.message,
                                        controller: contentController,
                                        maxLine: 10,
                                        isRequired: false,
                                      ),
                                    ),
                                    AppSize.spaceHeight16,
                                    SizedBox(
                                      width: AppSize.getDeviceWidth(context) * 0.9,
                                      child: ButtonWidget(
                                        onPress: () {
                                          if (emailController.text.isEmpty || contentController.text.isEmpty) {
                                            toastMessageError("Eメールとメッセージが必要です", context);
                                          } else {
                                            toastMessageSuccess("送信成功", context);
                                          }
                                        },
                                        title: "送信",
                                        color: AppColor.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                AppSize.spaceHeight16,
                                Divider(),
                                AppSize.spaceHeight16,
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Air Job Co,. TD Japan",
                                          style: kTitleText.copyWith(fontSize: 30, color: Colors.black),
                                        ),
                                      ),
                                      AppSize.spaceHeight16,
                                      Text(
                                        "1-chōme-6-9 Kitashinjuku, Shinjuku City, Tokyo 169-0074, Japan",
                                        style: kNormalText.copyWith(fontSize: 18),
                                      ),
                                      AppSize.spaceHeight16,
                                      Text(
                                        "${JapaneseText.phoneNumber}: 9999-9999-999",
                                        style: kNormalText.copyWith(fontSize: 18),
                                      ),
                                      AppSize.spaceHeight16,
                                      Text(
                                        "${JapaneseText.email}: support@airjob.com",
                                        style: kNormalText.copyWith(fontSize: 18),
                                      ),
                                      AppSize.spaceHeight30,
                                    ],
                                  ),
                                ),
                                AppSize.spaceHeight30,
                                SizedBox(
                                  width: AppSize.getDeviceWidth(context),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      menuWidget(
                                          title: "プライバシーポリシー", onTap: () => MyPageRoute.goTo(context, const PrivatePolicy()), color: Colors.black),
                                      menuWidget(title: "サービス期間", onTap: () => MyPageRoute.goTo(context, const TermOfUse()), color: Colors.black)
                                    ],
                                  ),
                                ),
                                AppSize.spaceHeight16,
                                Center(
                                  child: Text(
                                    "コピーライト @Air_Job 2024\n${ConstValue.appVersion}",
                                    style: kNormalText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 200,
                                )
                              ])),
                        ]))))
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSize.getDeviceWidth(context),
              color: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/logo22.png",
                    width: 250,
                  ),
                  Row(
                    children: [
                      menuWidget(
                          title: JapaneseText.home,
                          onTap: () => scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn)),
                      AppSize.spaceWidth5,
                      menuWidget(
                          title: JapaneseText.contactUs,
                          onTap: () => scrollController.animateTo(contactUs, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn)),
                      AppSize.spaceWidth5,
                      menuWidget(
                          title: JapaneseText.aboutUs,
                          onTap: () => scrollController.animateTo(aboutUs, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn)),
                      AppSize.spaceWidth5,
                      menuWidget(
                          title: JapaneseText.jobSeekerPage,
                          onTap: () {
                            String userAgent = html.window.navigator.userAgent;
                            if (userAgent.contains('Mac OS')) {
                              js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                            } else if (userAgent.contains('Windows')) {
                              js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                            } else {
                              if (userAgent.contains('iOS')) {
                                js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                              } else {
                                js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                              }
                            }
                          }),
                      AppSize.spaceWidth5,
                      menuWidget(title: JapaneseText.companyPage, onTap: () => context.go(MyRoute.companyLogin)),
                      AppSize.spaceWidth5,
                      menuWidget(title: JapaneseText.adminPage, onTap: () => context.go(MyRoute.login)),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(children: [
                          Text(
                            JapaneseText.home,
                            style: kTitleText.copyWith(fontSize: 50, color: Colors.black),
                          ),
                          AppSize.spaceHeight30,
                          SizedBox(
                            height: homeSize,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 100),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "いつでも働き、\n今すぐ報酬を得る",
                                        style: kTitleText.copyWith(fontSize: 50, color: Colors.black),
                                      ),
                                      AppSize.spaceHeight16,
                                      Text(
                                        "Air Jobなら、もう厳しいスケジュールに縛られることはありません。\n自分の都合に合わせて働き、20分以内に報酬を受け取る。\n面接も履歴書も必要ありません。",
                                        style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                      ),
                                      AppSize.spaceHeight16,
                                      InkWell(
                                        onTap: () {
                                          String userAgent = html.window.navigator.userAgent;
                                          if (userAgent.contains('Mac OS')) {
                                            js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                                          } else if (userAgent.contains('Windows')) {
                                            js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                                          } else {
                                            if (userAgent.contains('iOS')) {
                                              js.context.callMethod('open', ["https://testflight.apple.com/join/hT4uZGwr"]);
                                            } else {
                                              js.context.callMethod('open', ["https://play.google.com/store/apps/details?id=com.collabonet.airjob"]);
                                            }
                                          }
                                        },
                                        child: Image.asset(
                                          "assets/download.jpeg",
                                          height: 200,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Expanded(
                                    child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: AppSize.getDeviceHeight(context) * 0.1,
                                      left: 0,
                                      bottom: AppSize.getDeviceHeight(context) * 0.1,
                                      child: Image.asset(
                                        "assets/home.png",
                                      ),
                                    ),
                                    Positioned(
                                      top: AppSize.getDeviceHeight(context) * 0.15,
                                      right: 20,
                                      child: Image.asset(
                                        "assets/calendar.png",
                                        height: AppSize.getDeviceHeight(context) * 0.6,
                                      ),
                                    ),
                                    Positioned(
                                      top: AppSize.getDeviceHeight(context) * 0.15,
                                      left: 100,
                                      child: SvgPicture.asset(
                                        "assets/person.svg",
                                        height: AppSize.getDeviceHeight(context) * 0.6,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            color: AppColor.primaryColor.withOpacity(0.3),
                            // height: AppSize.getDeviceHeight(context),
                            child: Column(
                              children: [
                                AppSize.spaceHeight30,
                                Text(
                                  JapaneseText.aboutUs,
                                  style: kTitleText.copyWith(fontSize: 50, color: Colors.black),
                                ),
                                AppSize.spaceHeight30,
                                AppSize.spaceHeight16,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 400,
                                        height: 400,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                                        padding: const EdgeInsets.all(32),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/calendar.png",
                                          ),
                                        ),
                                      ),
                                    )),
                                    AppSize.spaceWidth32,
                                    AppSize.spaceWidth32,
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "好きなだけ働く",
                                          style: kNormalText.copyWith(fontSize: 50, color: Colors.black, fontFamily: "Bold"),
                                        ),
                                        AppSize.spaceHeight16,
                                        SizedBox(
                                          width: 400,
                                          child: Text(
                                            "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                            style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                                AppSize.spaceHeight30,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "好きなだけ働く",
                                          style: kNormalText.copyWith(fontSize: 50, color: Colors.black, fontFamily: "Bold"),
                                        ),
                                        AppSize.spaceHeight16,
                                        SizedBox(
                                          width: 400,
                                          child: Text(
                                            "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                            style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    )),
                                    AppSize.spaceWidth32,
                                    AppSize.spaceWidth32,
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: 400,
                                        height: 400,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                                        padding: const EdgeInsets.all(32),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/calendar.png",
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                AppSize.spaceHeight30,
                              ],
                            ),
                          ),
                          Container(
                              width: AppSize.getDeviceWidth(context),
                              color: Colors.white,
                              child: Column(children: [
                                AppSize.spaceHeight30,
                                Text(
                                  JapaneseText.contactUs,
                                  style: kTitleText.copyWith(fontSize: 50, color: Colors.black),
                                ),
                                AppSize.spaceHeight30,
                                Row(
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: AppSize.getDeviceWidth(context) * 0.4,
                                            child: PrimaryTextField(
                                              hint: JapaneseText.email,
                                              controller: emailController,
                                              isRequired: false,
                                            ),
                                          ),
                                          AppSize.spaceHeight16,
                                          SizedBox(
                                            width: AppSize.getDeviceWidth(context) * 0.4,
                                            child: PrimaryTextField(
                                              hint: JapaneseText.message,
                                              controller: contentController,
                                              maxLine: 10,
                                              isRequired: false,
                                            ),
                                          ),
                                          AppSize.spaceHeight16,
                                          SizedBox(
                                            width: AppSize.getDeviceWidth(context) * 0.4,
                                            child: ButtonWidget(
                                              onPress: () {
                                                if (emailController.text.isEmpty || contentController.text.isEmpty) {
                                                  toastMessageError("Eメールとメッセージが必要です", context);
                                                } else {
                                                  toastMessageSuccess("送信成功", context);
                                                }
                                              },
                                              title: "送信",
                                              color: AppColor.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    Container(
                                      width: 1,
                                      height: 400,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                        left: AppSize.getDeviceWidth(context) * 0.04,
                                      ),
                                      child: SizedBox(
                                        height: 400,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Air Job Co,. TD Japan",
                                              style: kTitleText.copyWith(fontSize: 40, color: Colors.black),
                                            ),
                                            AppSize.spaceHeight16,
                                            Text(
                                              "1-chōme-6-9 Kitashinjuku, Shinjuku City, Tokyo 169-0074, Japan",
                                              style: kNormalText.copyWith(fontSize: 18),
                                            ),
                                            AppSize.spaceHeight16,
                                            Text(
                                              "${JapaneseText.phoneNumber}: 9999-9999-999",
                                              style: kNormalText.copyWith(fontSize: 18),
                                            ),
                                            AppSize.spaceHeight16,
                                            Text(
                                              "${JapaneseText.email}: support@airjob.com",
                                              style: kNormalText.copyWith(fontSize: 18),
                                            ),
                                            AppSize.spaceHeight30,
                                          ],
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                                AppSize.spaceHeight30,
                                SizedBox(
                                  width: AppSize.getDeviceWidth(context),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      menuWidget(
                                          title: "プライバシーポリシー", onTap: () => MyPageRoute.goTo(context, const PrivatePolicy()), color: Colors.black),
                                      menuWidget(title: "サービス期間", onTap: () => MyPageRoute.goTo(context, const TermOfUse()), color: Colors.black)
                                    ],
                                  ),
                                ),
                                AppSize.spaceHeight16,
                                Center(
                                  child: Text(
                                    "コピーライト @Air_Job 2024\n${ConstValue.appVersion}",
                                    style: kNormalText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 200,
                                )
                              ])),
                        ]))))
          ],
        ),
      );
    }
  }

  menuWidget({required String title, required Function onTap, Color? color}) {
    return MouseRegion(
      onEnter: (v) {
        setState(() {
          hoverText = title;
        });
      },
      onExit: (v) {
        setState(() {
          hoverText = "";
        });
      },
      child: TextButton(
          onPressed: () => onTap(),
          child: Column(
            children: [
              Text(
                title,
                style: kNormalText.copyWith(color: color ?? AppColor.whiteColor, fontSize: 16),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: title.length * 17,
                height: hoverText == title ? 2 : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: color ?? AppColor.whiteColor,
                ),
                curve: Curves.bounceInOut,
              )
            ],
          )),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    // startTime();
  }
}

enum MenuEnum { home, aboutUs, contactUs, worker, company, admin }
