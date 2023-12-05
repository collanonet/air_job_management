import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier{
  List<String> datetime = ['Today', '22', '23', '24', '25', '26'];

  bool ishide = false;
  favorite() {
    ishide = !ishide;
    notifyListeners();
  }
}
