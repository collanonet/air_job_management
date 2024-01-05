import 'package:air_job_management/providers/root_provider.dart';
import 'package:air_job_management/worker_page/chat/chat.dart';
import 'package:air_job_management/worker_page/manage/full_time_sceen.dart';
import 'package:air_job_management/worker_page/manage/part_time_sreen.dart';
import 'package:air_job_management/worker_page/myjob/job_screen.dart';
import 'package:air_job_management/worker_page/viewprofile/viewprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../favorite/favorite.dart';

class RootPage extends StatefulWidget {
  final String uid;
  final bool isFullTime;
  const RootPage(this.uid, {required this.isFullTime});
  //const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      PartTimeJob(),
      Center(
        child: JobScreen(
          uid: widget.uid,
        ),
      ),
      Center(
        child: FavoriteSreen(
          uid: widget.uid,
        ),
      ),
      const ChatPage(),
      const Center(
        child: ViewProfile(), //Text("Menu"),
      ),
    ];
    if (widget.isFullTime) {
      pages[0] = FullTimeJob();
    }
    Provider.of<RootProvider>(context, listen: false).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rootProvider = Provider.of<RootProvider>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          body: pages.elementAt(rootProvider.selectIndex),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            destinations: rootProvider.allDestinations
                .map<Widget>((Destination destination) {
              return NavigationDestination(
                icon: destination.icon,
                label: destination.title,
                tooltip: destination.title,
              );
            }).toList(),
            onDestinationSelected: (v) {
              rootProvider.onChangeIndex(v);
            },
            selectedIndex: rootProvider.selectIndex,
          )),
    );
  }
}
