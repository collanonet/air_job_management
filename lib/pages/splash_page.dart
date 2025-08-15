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
import 'package:air_job_management/utils/mixin.dart';
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

import '../utils/app_size.dart';

bool isFullTime = false;

/// ---------- Responsive helpers ----------
double sw(BuildContext c) => MediaQuery.of(c).size.width;
double sh(BuildContext c) => MediaQuery.of(c).size.height; // <- fixed below

// NOTE: fix for typo above:
double screenW(BuildContext c) => MediaQuery.of(c).size.width;
double screenH(BuildContext c) => MediaQuery.of(c).size.height;

/// Responsive font size (~5% of width), clamped to [min,max]
double rfs(BuildContext c, {double min = 14, double max = 48}) {
  final s = screenW(c) * 0.05;
  return s.clamp(min, max);
}

class Breakpoints {
  static const double mobile = 640;
  static const double tablet = 1024;
}

/// Benefit chip used in hero on mobile
class BenefitChip extends StatelessWidget {
  final String label;
  const BenefitChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.secondaryColor2,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: kNormalText.copyWith(
          fontSize: rfs(context, min: 14, max: 22),
          color: Colors.black,
        ),
      ),
    );
  }
}

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
        final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final MyUser? users = await UserApiServices().getProfileUser(user.uid);
        final Company? company = await UserApiServices().getProfileCompany(user.uid);

        authProvider.setProfile = users;
        if (company != null) {
          authProvider.setCompany = company;
          authProvider.branch = mainBranch;
          context.go(MyRoute.companyInformationManagement);
        } else {
          if (users!.role == RoleHelper.admin) {
            context.go(MyRoute.dashboard);
          } else if (users.role == RoleHelper.worker && isEmailVerified == true) {
            isFullTime = users.isFullTimeStaff == true;
            context.go(MyRoute.workerSearchJobPage);
          } else if (users.role == RoleHelper.worker && isEmailVerified == false) {
            MyPageRoute.goToReplace(
              context,
              VerifyUserEmailPage(
                myUser: users,
                isFullTime: users.isFullTimeStaff!,
              ),
            );
          }
        }
      } else {
        setState(() => isSplash = false);
      }
    } else {
      if (user != null) {
        final MyUser? users = await UserApiServices().getProfileUser(user.uid);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (users?.role == null) {
          if (GoRouter.of(context).location.toString().contains("company")) {
            context.go(MyRoute.companyInformationManagement);
          } else {
            authProvider.branch = mainBranch;
            context.go(MyRoute.companyInformationManagement);
          }
        }
      } else {
        setState(() => isSplash = false);
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

  String hoverText = "";

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

  Widget landingPage() {
    if (Responsive.isMobile(context)) {
      // ---------------- MOBILE (Flutter Web & devices) ----------------
      return SafeArea(
        child: Container(
          color: Colors.white,
          width: screenW(context),
          height: screenH(context),
          child: Column(
            children: [
              // Top bar
              Container(
                width: screenW(context),
                color: AppColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset("assets/logo22.png", width: screenW(context) * 0.55),
                      ),
                    ),
                    PopupMenuButton<MenuEnum>(
                      color: Colors.white,
                      icon: const Icon(Icons.menu, color: Colors.white),
                      tooltip: "Menu",
                      onSelected: (result) async {
                        if (result == MenuEnum.worker) {
                          final ua = html.window.navigator.userAgent;
                          if (ua.contains('Mac OS') || ua.contains('iOS')) {
                            js.context.callMethod('open', [
                              "https://apps.apple.com/sk/app/%E3%82%A8%E3%82%A2%E3%82%B8%E3%83%A7%E3%83%96/id6468330466"
                            ]);
                          } else {
                            js.context.callMethod('open', [
                              "https://play.google.com/store/apps/details?id=com.collabonet.airjob"
                            ]);
                          }
                        } else if (result == MenuEnum.home) {
                          scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        } else if (result == MenuEnum.aboutUs) {
                          scrollController.animateTo(
                            1050,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        } else if (result == MenuEnum.contactUs) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent - 340,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        } else {
                          toastMessageError("This option is not available on mobile", context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: MenuEnum.home, child: Text(JapaneseText.home, style: kNormalText)),
                        PopupMenuItem(value: MenuEnum.contactUs, child: Text(JapaneseText.contactUs, style: kNormalText)),
                        PopupMenuItem(value: MenuEnum.aboutUs, child: Text(JapaneseText.aboutUs, style: kNormalText)),
                        PopupMenuItem(value: MenuEnum.worker, child: Text(JapaneseText.jobSeekerPage, style: kNormalText)),
                        PopupMenuItem(value: MenuEnum.company, child: Text(JapaneseText.company, style: kNormalText)),
                        PopupMenuItem(value: MenuEnum.admin, child: Text(JapaneseText.adminPage, style: kNormalText)),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // HERO
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final maxW = constraints.maxWidth;
                            final heroH = (screenH(context) * 0.62).clamp(360, 620);
                            final panelW = (maxW * 0.85).clamp(300, 520).toDouble();

                            return Container(
                              width: maxW,
                              height: heroH.toDouble(),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: const AssetImage("assets/bg.png"),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.25), BlendMode.darken),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: panelW,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(120),
                                      bottomRight: Radius.circular(120),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "STAFF\n大募集!",
                                        textAlign: TextAlign.center,
                                        style: kTitleText.copyWith(
                                          fontSize: rfs(context, min: 28, max: 44),
                                          color: AppColor.whiteColor,
                                          fontFamily: "Bold",
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "私たちと一緒に働きませんか？",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: rfs(context, min: 13, max: 18),
                                          color: AppColor.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: panelW),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          runSpacing: 10,
                                          spacing: 10,
                                          children: const [
                                            BenefitChip("◎ 未経験応募可"),
                                            BenefitChip("◎ 社員登用あり"),
                                            BenefitChip("◎ 昇給制度あり"),
                                            BenefitChip("◎ 週休2日制"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // ABOUT
                        Container(
                          color: AppColor.primaryColor.withOpacity(0.08),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            children: [
                              Text(
                                JapaneseText.aboutUs,
                                style: kTitleText.copyWith(
                                  fontSize: rfs(context, min: 24, max: 36),
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 720),
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Image.asset("assets/calendar.png"),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      "好きなだけ働く",
                                      style: kNormalText.copyWith(
                                        fontSize: rfs(context, min: 20, max: 28),
                                        fontFamily: "Bold",
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                      textAlign: TextAlign.center,
                                      style: kNormalText.copyWith(
                                        fontSize: rfs(context, min: 14, max: 18),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // CONTACT
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: Column(
                              children: [
                                Text(
                                  JapaneseText.contactUs,
                                  style: kTitleText.copyWith(
                                    fontSize: rfs(context, min: 24, max: 36),
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                PrimaryTextField(
                                  hint: JapaneseText.email,
                                  controller: emailController,
                                  isRequired: false,
                                ),
                                const SizedBox(height: 12),
                                PrimaryTextField(
                                  hint: JapaneseText.message,
                                  controller: contentController,
                                  maxLine: 8,
                                  isRequired: false,
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
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
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  "Air Job Co,. TD Japan\n"
                                  "1-chōme-6-9 Kitashinjuku, Shinjuku City, Tokyo 169-0074, Japan\n"
                                  "${JapaneseText.phoneNumber}: 9999-9999-999\n"
                                  "${JapaneseText.email}: support@airjob.com",
                                  textAlign: TextAlign.center,
                                  style: kNormalText.copyWith(fontSize: rfs(context, min: 13, max: 16)),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        // FOOTER
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 24,
                          children: [
                            menuWidget(
                                title: "プライバシーポリシー",
                                onTap: () => MyPageRoute.goTo(context, const PrivatePolicy()),
                                color: Colors.black),
                            menuWidget(
                                title: "サービス期間",
                                onTap: () => MyPageRoute.goTo(context, const TermOfUse()),
                                color: Colors.black),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "コピーライト @Air_Job 2024\n${ConstValue.appVersion}",
                          style: kNormalText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // ---------------- DESKTOP ----------------
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
                  Image.asset("assets/logo22.png", width: 250),
                  Row(
                    children: [
                      menuWidget(
                        title: JapaneseText.home,
                        onTap: () => scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 500), curve: Curves.bounceIn),
                      ),
                      AppSize.spaceWidth5,
                      menuWidget(
                        title: JapaneseText.contactUs,
                        onTap: () => scrollController.animateTo(contactUs,
                            duration: const Duration(milliseconds: 500), curve: Curves.bounceIn),
                      ),
                      AppSize.spaceWidth5,
                      menuWidget(
                        title: JapaneseText.aboutUs,
                        onTap: () => scrollController.animateTo(aboutUs,
                            duration: const Duration(milliseconds: 500), curve: Curves.bounceIn),
                      ),
                      AppSize.spaceWidth5,
                      menuWidget(
                        title: JapaneseText.jobSeekerPage,
                        onTap: () {
                          final ua = html.window.navigator.userAgent;
                          if (ua.contains('Mac OS') || ua.contains('iOS')) {
                            js.context.callMethod('open', [
                              "https://apps.apple.com/sk/app/%E3%82%A8%E3%82%A2%E3%82%B8%E3%83%A7%E3%83%96/id6468330466"
                            ]);
                          } else {
                            js.context.callMethod('open', [
                              "https://play.google.com/store/apps/details?id=com.collabonet.airjob"
                            ]);
                          }
                        },
                      ),
                      AppSize.spaceWidth5,
                      menuWidget(title: JapaneseText.companyPage, onTap: () => context.go(MyRoute.companyLogin)),
                      AppSize.spaceWidth5,
                      menuWidget(title: JapaneseText.adminPage, onTap: () => context.go(MyRoute.login)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Desktop hero
                      Container(
                        width: AppSize.getDeviceWidth(context),
                        height: homeSize,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage("assets/bg.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 520,
                                    height: homeSize * 0.92,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(180),
                                        bottomRight: Radius.circular(180),
                                      ),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "STAFF\n大募集!",
                                          style: kTitleText.copyWith(
                                            fontSize: 50,
                                            color: AppColor.whiteColor,
                                            fontFamily: "Bold",
                                          ),
                                        ),
                                        Text("私たちと一緒に働きませんか？",
                                            style: TextStyle(fontSize: 18, color: AppColor.whiteColor)),
                                        const SizedBox(height: 32),
                                        ...[
                                          "◎ 未経験応募可",
                                          "◎ 社員登用あり",
                                          "◎ 昇給制度あり",
                                          "◎ 週休2日制",
                                        ].map(
                                          (b) => Padding(
                                            padding: const EdgeInsets.only(bottom: 16.0),
                                            child: Container(
                                              width: 450,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: AppColor.secondaryColor2,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Center(
                                                  child: Text(
                                                    b,
                                                    style: kNormalText.copyWith(
                                                        fontSize: 20, color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // About desktop (kept close to your original, minor constraints)
                      Container(
                        color: AppColor.primaryColor.withOpacity(0.3),
                        child: Column(
                          children: [
                            AppSize.spaceHeight30,
                            Text(JapaneseText.aboutUs,
                                style: kTitleText.copyWith(fontSize: 50, color: Colors.black)),
                            AppSize.spaceHeight30,
                            AppSize.spaceHeight16,
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(32),
                                        child: Center(child: Image.asset("assets/calendar.png")),
                                      ),
                                    ),
                                  ),
                                ),
                                AppSize.spaceWidth32,
                                AppSize.spaceWidth32,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("好きなだけ働く",
                                          style: kNormalText.copyWith(
                                              fontSize: 50, color: Colors.black, fontFamily: "Bold")),
                                      AppSize.spaceHeight16,
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 520),
                                        child: Text(
                                          "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                          style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            AppSize.spaceHeight30,
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("好きなだけ働く",
                                          style: kNormalText.copyWith(
                                              fontSize: 50, color: Colors.black, fontFamily: "Bold")),
                                      AppSize.spaceHeight16,
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 520),
                                        child: Text(
                                          "あなたの仕事のシフトは完全にあなた次第です-それはあなたが1時間と短いギグから稼ぎ始めることができることを意味します。Air Job を使用すると、もはや厳格なスケジュールに拘束されることはありません。あなたの都合に合わせて仕事のシフトの期間、時間、場所を調整します。縛られない、あなただけの働き方を発見してください。",
                                          style: kNormalText.copyWith(fontSize: 20, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppSize.spaceWidth32,
                                AppSize.spaceWidth32,
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(32),
                                        child: Center(child: Image.asset("assets/calendar.png")),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSize.spaceHeight30,
                          ],
                        ),
                      ),

                      // Contact desktop
                      Container(
                        width: AppSize.getDeviceWidth(context),
                        color: Colors.white,
                        child: Column(
                          children: [
                            AppSize.spaceHeight30,
                            Text(JapaneseText.contactUs,
                                style: kTitleText.copyWith(fontSize: 50, color: Colors.black)),
                            AppSize.spaceHeight30,
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: AppSize.getDeviceWidth(context) * 0.4),
                                        child: PrimaryTextField(
                                          hint: JapaneseText.email,
                                          controller: emailController,
                                          isRequired: false,
                                        ),
                                      ),
                                      AppSize.spaceHeight16,
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: AppSize.getDeviceWidth(context) * 0.4),
                                        child: PrimaryTextField(
                                          hint: JapaneseText.message,
                                          controller: contentController,
                                          maxLine: 10,
                                          isRequired: false,
                                        ),
                                      ),
                                      AppSize.spaceHeight16,
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: AppSize.getDeviceWidth(context) * 0.4),
                                        child: ButtonWidget(
                                          onPress: () {
                                            if (emailController.text.isEmpty ||
                                                contentController.text.isEmpty) {
                                              toastMessageError("Eメールとメッセージが必要です", context);
                                            } else {
                                              toastMessageSuccess("送信成功", context);
                                            }
                                          },
                                          title: "送信",
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 400, color: Colors.black),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: AppSize.getDeviceWidth(context) * 0.04),
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Air Job Co,. TD Japan",
                                              style: kTitleText.copyWith(
                                                  fontSize: 40, color: Colors.black)),
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
                                  ),
                                ),
                              ],
                            ),
                            AppSize.spaceHeight30,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  menuWidget(
                                      title: "プライバシーポリシー",
                                      onTap: () => MyPageRoute.goTo(context, const PrivatePolicy()),
                                      color: Colors.black),
                                  menuWidget(
                                      title: "サービス期間",
                                      onTap: () => MyPageRoute.goTo(context, const TermOfUse()),
                                      color: Colors.black),
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
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget menuWidget({required String title, required Function onTap, Color? color}) {
    return MouseRegion(
      onEnter: (_) => setState(() => hoverText = title),
      onExit: (_) => setState(() => hoverText = ""),
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    // startTime();
  }
}

enum MenuEnum { home, aboutUs, contactUs, worker, company, admin }
