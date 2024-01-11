import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RootProvider with ChangeNotifier {
  int selectIndex = 0;
  static RootProvider getProvider(context, [bool listen = false]) =>
      Provider.of<RootProvider>(context, listen: listen);

  onInit() {
    selectIndex = 0;
  }

  List<Destination> allDestinations = <Destination>[
    Destination(0, "さがす",
        const Icon(FontAwesomeIcons.search, color: Colors.white), Colors.white),
    Destination(
        1,
        "お仕事",
        const Icon(FontAwesomeIcons.calendarDay, color: Colors.white),
        Colors.white),
    Destination(2, "お気に入り",
        const Icon(FontAwesomeIcons.heart, color: Colors.white), Colors.white),
    Destination(
        3,
        "メッセージ",
        const Icon(FontAwesomeIcons.commentAlt, color: Colors.white),
        Colors.white),
    Destination(
        4,
        "マイページ",
        const Icon(FontAwesomeIcons.ellipsis, color: Colors.white),
        Colors.white),
  ];

  onChangeIndex(int val) {
    selectIndex = val;
    notifyListeners();
  }
}

class Destination {
  Destination(this.index, this.title, this.icon, this.color);
  int index;
  String title;
  Widget icon;
  Color color;
}
