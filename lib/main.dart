import 'dart:ui';

import 'package:air_job_management/1_company_page/home/home.dart';
import 'package:air_job_management/1_company_page/job_posting/create_or_edit_job_posting.dart';
import 'package:air_job_management/1_company_page/login/login.dart';
import 'package:air_job_management/1_company_page/login/reset_password.dart';
import 'package:air_job_management/1_company_page/woker_management/create_outside_worker.dart';
import 'package:air_job_management/1_company_page/woker_management/root_worker_management_detail.dart';
import 'package:air_job_management/2_worker_page/manage/manage_screen.dart';
import 'package:air_job_management/2_worker_page/root/root_page.dart';
import 'package:air_job_management/2_worker_page/search/job_detail_via_link.dart';
import 'package:air_job_management/pages/company/create_or_edit_company.dart';
import 'package:air_job_management/pages/home/home.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job_for_japanese.dart';
import 'package:air_job_management/pages/job_seeker/create_job_seeker.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/job_seeker_detail.dart';
import 'package:air_job_management/pages/login.dart';
import 'package:air_job_management/pages/register/register.dart';
import 'package:air_job_management/pages/register/register_success.dart';
import 'package:air_job_management/pages/reset_password.dart';
import 'package:air_job_management/pages/splash_page.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company.dart';
import 'package:air_job_management/providers/company/dashboard.dart';
import 'package:air_job_management/providers/company/entry_exit_history.dart';
import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/providers/company/shift_calendar.dart';
import 'package:air_job_management/providers/company/worker_management.dart';
import 'package:air_job_management/providers/favorite_provider.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/providers/job_posting_for_japanese.dart';
import 'package:air_job_management/providers/job_seeker.dart';
import 'package:air_job_management/providers/job_seeker_detail.dart';
import 'package:air_job_management/providers/root_provider.dart';
import 'package:air_job_management/providers/worker/filter.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '1_company_page/applicant/applicant_root.dart';
import '2_worker_page/search/create_request_success.dart';
import 'firebase_options.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  usePathUrlStrategy();
  // setPathUrlStrategy();
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        print("Initial called ${state.location}");
        // return CreateJobRequestSuccessPage();
        // return VerifyUserEmailPage(myUser: MyUser(), isFullTime: isFullTime);
        // return NewFormRegistrationForPartTimePage(myUser: MyUser(email: "sopheadavid+010101@yandex.com", uid: "2EIYGvWGVeahijOngeNZSUAJLCG2"));
        return const SplashScreen(
          isFromWorker: false,
        );
      },
      routes: <RouteBase>[
        GoRoute(
            path: "job-posting",
            builder: (BuildContext context, GoRouterState state) {
              return const ViewJobDetailViaLinkPage(jobId: "");
            },
            routes: [
              GoRoute(
                path: ":uid",
                builder: (BuildContext context, GoRouterState state) {
                  return ViewJobDetailViaLinkPage(jobId: state.pathParameters["uid"].toString());
                },
              ),
            ]),
        GoRoute(
            path: MyRoute.workerPage.removeSlash(),
            builder: (BuildContext context, GoRouterState state) {
              return const SplashScreen(
                isFromWorker: true,
              );
            },
            routes: [
              GoRoute(
                path: "apply-job-success",
                builder: (BuildContext context, GoRouterState state) {
                  return const CreateJobRequestSuccessPage();
                },
              ),
              GoRoute(
                path: "job-options",
                builder: (BuildContext context, GoRouterState state) {
                  return const ManageScreen();
                },
              ),
              GoRoute(
                path: "search-job",
                builder: (BuildContext context, GoRouterState state) {
                  isFullTime = false;
                  return const RootPage(
                    "uid",
                    isFullTime: false,
                    index: 0,
                  );
                },
              ),
              GoRoute(
                path: "search-job-full",
                builder: (BuildContext context, GoRouterState state) {
                  isFullTime = true;
                  return const RootPage(
                    "uid",
                    isFullTime: true,
                    index: 0,
                  );
                },
              ),
              GoRoute(
                path: "job",
                builder: (BuildContext context, GoRouterState state) {
                  return const RootPage(
                    "uid",
                    isFullTime: false,
                    index: 1,
                  );
                },
              ),
              GoRoute(
                path: "favorite",
                builder: (BuildContext context, GoRouterState state) {
                  return const RootPage(
                    "uid",
                    isFullTime: false,
                    index: 2,
                  );
                },
              ),
              GoRoute(
                path: "chat",
                builder: (BuildContext context, GoRouterState state) {
                  return const RootPage(
                    "uid",
                    isFullTime: false,
                    index: 3,
                  );
                },
              ),
              GoRoute(
                path: "setting",
                builder: (BuildContext context, GoRouterState state) {
                  return const RootPage(
                    "uid",
                    isFullTime: false,
                    index: 4,
                  );
                },
              ),
            ]),
        GoRoute(
          path: MyRoute.jobOption.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.jobOption,
        ),
        GoRoute(
          path: MyRoute.dashboard.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.analysis);
          },
        ),
        GoRoute(
          path: MyRoute.resetPassword.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return const ResetPasswordPage();
          },
        ),
        GoRoute(
            path: MyRoute.job.removeSlash(),
            builder: (BuildContext context, GoRouterState state) {
              return HomePage(selectItem: JapaneseText.job);
            },
            routes: [
              GoRoute(
                path: 'create',
                builder: (BuildContext context, GoRouterState state) {
                  if (state.extra == "japanese") {
                    return const HomePage(page: CreateOrEditJobForJapanesePage(jobPostId: null));
                  } else {
                    return const HomePage(page: CreateOrEditJobPage(jobPostId: null));
                  }
                },
              ),
              GoRoute(
                path: ':uid',
                builder: (BuildContext context, GoRouterState state) {
                  if (state.extra == "japanese") {
                    return HomePage(
                        page: CreateOrEditJobForJapanesePage(
                      jobPostId: state.pathParameters["uid"].toString(),
                    ));
                  } else {
                    return HomePage(
                        page: CreateOrEditJobPage(
                      jobPostId: state.pathParameters["uid"].toString(),
                    ));
                  }
                },
              ),
            ]),
        GoRoute(
          path: MyRoute.createJob.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.createJob,
        ),
        GoRoute(path: "${MyRoute.job.removeSlash()}/:uid", redirect: (c, s) => "${MyRoute.job}/${s.pathParameters['uid']}"),
        GoRoute(
          path: MyRoute.shift.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.shift);
          },
        ),
        GoRoute(
            path: MyRoute.jobSeeker.removeSlash(),
            builder: (BuildContext context, GoRouterState state) {
              return HomePage(selectItem: JapaneseText.jobSeeker);
            },
            routes: [
              GoRoute(
                path: 'create',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage(page: CreateJobSeekerPage());
                },
              ),
              GoRoute(
                path: ':uid',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage(
                      page: JobSeekerDetailPage(
                    seekerId: state.pathParameters["uid"].toString(),
                  ));
                },
              ),
            ]),
        GoRoute(
          path: MyRoute.createJobSeeker.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.createJobSeeker,
        ),
        GoRoute(path: "${MyRoute.jobSeeker.removeSlash()}/:uid", redirect: (c, s) => "${MyRoute.jobSeeker}/${s.pathParameters['uid']}"),
        GoRoute(
            path: MyRoute.company.removeSlash(),
            builder: (BuildContext context, GoRouterState state) {
              return HomePage(selectItem: JapaneseText.recruitingCompany);
            },
            routes: [
              GoRoute(
                path: 'reset_password',
                builder: (BuildContext context, GoRouterState state) {
                  return const ResetPasswordCompanyPage();
                },
              ),
              GoRoute(
                path: 'login',
                builder: (BuildContext context, GoRouterState state) {
                  return const LoginPageForCompany();
                },
              ),
              GoRoute(
                path: 'dashboard',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.dashboardCompany,
                  );
                },
              ),
              GoRoute(
                path: 'job-posting',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.recruitmentTemplate,
                  );
                },
              ),
              GoRoute(
                  path: 'worker-management',
                  builder: (BuildContext context, GoRouterState state) {
                    return HomePageForCompany(
                      selectItem: JapaneseText.workerCompany,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'outside-worker/create',
                      builder: (BuildContext context, GoRouterState state) {
                        return const HomePageForCompany(
                          page: CreateOutsideStaffPage(),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'outside-worker/:uid',
                      builder: (BuildContext context, GoRouterState state) {
                        return HomePageForCompany(
                          page: CreateOutsideStaffPage(uid: state.pathParameters["uid"].toString()),
                        );
                      },
                    ),
                  ]),
              GoRoute(
                path: 'applicant/:uid',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    page: ApplicantRootPage(
                      uid: state.pathParameters["uid"].toString(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'worker-management/:uid',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    page: RootWorkerManagementDetailPage(
                      uid: state.pathParameters["uid"].toString(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'job-posting/create',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePageForCompany(
                    page: CreateOrEditJobPostingPageForCompany(),
                  );
                },
              ),
              GoRoute(
                path: 'job-posting/:uid',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    page: CreateOrEditJobPostingPageForCompany(
                      jobPosting: state.pathParameters["uid"].toString(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'shift',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.shiftFrame,
                  );
                },
              ),
              GoRoute(
                path: 'applicant',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.applicantCompany,
                  );
                },
              ),
              GoRoute(
                path: 'worker',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.workerCompany,
                  );
                },
              ),
              GoRoute(
                path: 'time-management',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.workingTimeManagement,
                  );
                },
              ),
              GoRoute(
                path: 'usage-detail',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.usageDetail,
                  );
                },
              ),
              GoRoute(
                path: 'information-management',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePageForCompany(
                    selectItem: JapaneseText.companyInformationManagement,
                  );
                },
              ),
              GoRoute(
                path: 'create',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage(page: CreateOrEditCompanyPage(id: null));
                },
              ),
              GoRoute(
                path: ':uid',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage(
                      page: CreateOrEditCompanyPage(
                    id: state.pathParameters["uid"].toString(),
                  ));
                },
              ),
            ]),
        GoRoute(
          path: MyRoute.companyLogin.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyLogin,
        ),
        GoRoute(
          path: MyRoute.companyDashboard.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyDashboard,
        ),
        GoRoute(
          path: MyRoute.companyJobPosting.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyDashboard,
        ),
        GoRoute(
          path: MyRoute.companyShift.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyShift,
        ),
        GoRoute(
          path: MyRoute.companyJobPosting.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyDashboard,
        ),
        GoRoute(
          path: MyRoute.companyApplicant.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyApplicant,
        ),
        GoRoute(
          path: MyRoute.companyWorker.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyWorker,
        ),
        GoRoute(
          path: MyRoute.companyTimeManagement.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyTimeManagement,
        ),
        GoRoute(
          path: MyRoute.companyUsageDetail.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyUsageDetail,
        ),
        GoRoute(
          path: MyRoute.companyInformationManagement.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.companyInformationManagement,
        ),
        GoRoute(path: "${MyRoute.company.removeSlash()}/:uid", redirect: (c, s) => "${MyRoute.company}/${s.pathParameters['uid']}"),
        GoRoute(
          path: MyRoute.setting.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.setting);
          },
        ),
        GoRoute(
          path: MyRoute.workerJobSearchPartTime.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return RootPage(
              "uid",
              isFullTime: false,
            );
          },
        ),
        // GoRoute(
        //   path: MyRoute.successApplyJob.removeSlash(),
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const CreateJobRequestSuccessPage();
        //   },
        // ),
        GoRoute(
          path: MyRoute.workerJobSearchFullTime.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return RootPage(
              "uid",
              isFullTime: true,
            );
          },
        ),
        GoRoute(
            path: MyRoute.registerAsGigWorker.removeSlash(),
            builder: (BuildContext context, GoRouterState state) {
              return RegisterPage(isFullTime: isFullTime);
            },
            routes: [
              GoRoute(
                path: "success",
                builder: (BuildContext context, GoRouterState state) {
                  return RegisterSuccessPage(isFullTime: isFullTime);
                },
              ),
            ]),
        GoRoute(
          path: MyRoute.login.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage(
              isFullTime: false,
              isFromWorker: false,
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(AppSize.getDeviceWidth(context), AppSize.getDeviceHeight(context)));
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
          providers: [
            // ChangeNotifierProvider<auth.AuthProvider>.value(value: auth.AuthProvider()),
            // StreamProvider.value(value: auth.AuthProvider().user, initialData: null),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => JobSeekerProvider()),
            ChangeNotifierProvider(create: (_) => JobSeekerDetailProvider()),
            ChangeNotifierProvider(create: (_) => JobPostingProvider()),
            ChangeNotifierProvider(create: (_) => JobPostingForJapaneseProvider()),
            ChangeNotifierProvider(create: (_) => CompanyProvider()),
            ChangeNotifierProvider(create: (_) => FavoriteProvider()),
            ChangeNotifierProvider(create: (_) => RootProvider()),
            ChangeNotifierProvider(create: (_) => WorkerFilter()),
            ChangeNotifierProvider(create: (_) => JobPostingForCompanyProvider()),
            ChangeNotifierProvider(create: (_) => WorkerManagementProvider()),
            ChangeNotifierProvider(create: (_) => ShiftCalendarProvider()),
            ChangeNotifierProvider(create: (_) => DashboardForCompanyProvider()),
            ChangeNotifierProvider(create: (_) => EntryExitHistoryProvider()),
          ],
          child: MaterialApp.router(
            scrollBehavior: MyCustomScrollBehavior(), // <== add here

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
                textTheme: TextTheme().apply(fontSizeFactor: 0.6.sp),
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.fuchsia: OpenUpwardsPageTransitionsBuilder(),
                })),
            supportedLocales: const [
              Locale('en', 'US'), // English, no country code
              Locale('ja', 'JP'), // Hebrew, no country code
            ],
            locale: const Locale('ja', 'JP'),
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'Air Job',
            routerConfig: _router,
          )),
    );
  }
}
