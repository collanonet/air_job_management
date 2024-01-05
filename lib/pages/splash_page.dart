import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/helper/role_helper.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/register/verify_user.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:air_job_management/worker_page/root/root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

class SplashScreen extends StatefulWidget {
  final bool isFromWorker;
  const SplashScreen({Key? key, required this.isFromWorker}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterBuildMixin {
  late var user;

  startTime() async {
    print("Splash called From Worker is ${widget.isFromWorker}");
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        print("First con");
        await FirebaseAuth.instance.currentUser?.reload();
        bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        MyUser? users = await UserApiServices().getProfileUser(user.uid);
        if (users!.role == RoleHelper.admin) {
          context.go(MyRoute.dashboard);
        } else if (users.role == RoleHelper.worker && isEmailVerified == true) {
          if (users.isFullTimeStaff == true) {
            MyPageRoute.goToReplace(
                context,
                RootPage(
                  users.uid!,
                  isFullTime: true,
                ));
          } else {
            MyPageRoute.goToReplace(
                context,
                RootPage(
                  users.uid!,
                  isFullTime: false,
                ));
          }
        } else if (users.role == RoleHelper.worker &&
            isEmailVerified == false) {
          MyPageRoute.goToReplace(
              context,
              VerifyUserEmailPage(
                myUser: users,
                isFullTime: users.isFullTimeStaff!,
              ));
        }
      } else {
        print("Sec con");
        if (widget.isFromWorker) {
          context.go(MyRoute.jobOption);
        } else {
          context.go(MyRoute.login);
        }
      }
    });
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Location ${GoRouter.of(context).location.toString()}");
    user = Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: const LoadingWidget(Colors.white),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    // startTime();
  }
}
