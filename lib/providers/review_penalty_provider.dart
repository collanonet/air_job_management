import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ReviewPenaltyProvider with ChangeNotifier{
  List<String> tagList =["Review","Penalty"];
  String tagSelected  = "Review";

  onChangeTage(String val)
  {
    tagSelected =val;
    notifyListeners();
  }
}