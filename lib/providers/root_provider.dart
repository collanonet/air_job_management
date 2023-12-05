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
    Destination(0, "さがす", const Icon(FontAwesomeIcons.search), Colors.teal),
    Destination(
        1, "お仕事", const Icon(FontAwesomeIcons.calendarDay), Colors.cyan),
    Destination(
        2, "お気に入り", const Icon(FontAwesomeIcons.heart), Colors.pinkAccent),
    Destination(
        3, "メッセージ", const Icon(FontAwesomeIcons.commentAlt), Colors.blueAccent),
    Destination(
        4, "マイページ", const Icon(FontAwesomeIcons.ellipsis), Colors.orange),
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
