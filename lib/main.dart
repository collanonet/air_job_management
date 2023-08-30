import 'dart:ui';

import 'package:air_job_management/pages/home/home.dart';
import 'package:air_job_management/pages/login.dart';
import 'package:air_job_management/pages/splash_page.dart';
import 'package:air_job_management/providers/auth.dart' as auth;
import 'package:air_job_management/providers/home.dart';
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
            return HomePage(selectItem: JapaneseText.dashboard);
          },
        ),
        // GoRoute(
        //   path: MyRoute.staff.removeSlash(),
        //   builder: (BuildContext context, GoRouterState state) {
        //     return HomePage(pageName: MyRoute.staff);
        //   },
        //   routes: <GoRoute>[
        //     GoRoute(
        //       path: ':uid/edit',
        //       builder: (BuildContext context, GoRouterState state) {
        //         return HomePage(
        //             pageName: MyRoute.staff,
        //             page: const StaffPage(
        //               isDetail: true,
        //             ));
        //       },
        //     ),
        //     GoRoute(
        //       path: ':uid/attendance-history',
        //       builder: (BuildContext context, GoRouterState state) {
        //         return HomePage(
        //             pageName: MyRoute.staff,
        //             page: const StaffPage(
        //               isDetail: true,
        //             ));
        //       },
        //     ),
        //     GoRoute(
        //       path: ':uid/schedule',
        //       builder: (BuildContext context, GoRouterState state) {
        //         return HomePage(
        //             pageName: MyRoute.staff,
        //             page: const StaffPage(
        //               isDetail: true,
        //             ));
        //       },
        //     ),
        //     GoRoute(
        //       path: 'create-batch-schedule',
        //       builder: (BuildContext context, GoRouterState state) {
        //         return HomePage(
        //             pageName: MyRoute.staff,
        //             page: const StaffPage(
        //               isDetail: true,
        //             ));
        //       },
        //     ),
        //     GoRoute(
        //       path: 'create',
        //       builder: (BuildContext context, GoRouterState state) {
        //         return HomePage(
        //             pageName: MyRoute.staff,
        //             page: const StaffPage(
        //               isDetail: true,
        //             ));
        //       },
        //     ),
        //   ],
        // ),
        GoRoute(
          path: MyRoute.users.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.users);
          },
        ),
        GoRoute(
          path: MyRoute.schedule.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.schedule);
          },
        ),
        GoRoute(
          path: MyRoute.setting.removeSlash(),
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(selectItem: JapaneseText.setting);
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
          ChangeNotifierProvider<auth.AuthProvider>.value(value: auth.AuthProvider()),
          StreamProvider.value(value: auth.AuthProvider().user, initialData: null),
          ChangeNotifierProvider(create: (_) => HomeProvider())
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
          debugShowCheckedModeBanner: false,
          title: 'Air Job',
          routerConfig: _router,
        ));
  }
}
