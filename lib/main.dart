import 'dart:ui';

import 'package:air_job_management/pages/company/create_or_edit_company.dart';
import 'package:air_job_management/pages/home/home.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job.dart';
import 'package:air_job_management/pages/job_posting/create_or_edit_job_for_japanese.dart';
import 'package:air_job_management/pages/job_seeker/create_job_seeker.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/job_seeker_detail.dart';
import 'package:air_job_management/pages/login.dart';
import 'package:air_job_management/pages/register/register.dart';
import 'package:air_job_management/pages/splash_page.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/company.dart';
import 'package:air_job_management/providers/home.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/providers/job_posting_for_japanese.dart';
import 'package:air_job_management/providers/job_seeker.dart';
import 'package:air_job_management/providers/job_seeker_detail.dart';
import 'package:air_job_management/utils/extension.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: MyRoute.dashboard.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.analysis);
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
          path: MyRoute.createCompany.removeSlash(),
          redirect: (BuildContext context, GoRouterState state) => MyRoute.createCompany,
        ),
        GoRoute(path: "${MyRoute.company.removeSlash()}/:uid", redirect: (c, s) => "${MyRoute.company}/${s.pathParameters['uid']}"),
        GoRoute(
          path: MyRoute.setting.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.setting);
          },
        ),
        GoRoute(
          path: MyRoute.registerAsGigWorker.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: MyRoute.login.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage();
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
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<auth.AuthProvider>.value(value: auth.AuthProvider()),
          // StreamProvider.value(value: auth.AuthProvider().user, initialData: null),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => JobSeekerProvider()),
          ChangeNotifierProvider(create: (_) => JobSeekerDetailProvider()),
          ChangeNotifierProvider(create: (_) => JobPostingProvider()),
          ChangeNotifierProvider(create: (_) => JobPostingForJapaneseProvider()),
          ChangeNotifierProvider(create: (_) => CompanyProvider())
        ],
        child: MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English, no country code
            Locale('ja', 'JP'), // Hebrew, no country code
          ],
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'Air Job',
          routerConfig: _router,
        ));
  }
}
