import 'package:air_job_management/api/entry_exit.dart';
import 'package:flutter/foundation.dart';

import '../../models/entry_exit_history.dart';
import '../../utils/japanese_text.dart';

class EntryExitHistoryProvider with ChangeNotifier {
  List<EntryExitHistory> entryList = [];
  bool isLoading = false;
  List<String> displayList = [JapaneseText.byMonth, JapaneseText.perWorker];
  String selectDisplay = JapaneseText.byMonth;
  DateTime startDay = DateTime.now();
  DateTime endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  List<DateTime> dateList = [];

  set setLoading(bool loading) {
    isLoading = loading;
  }

  initData() {
    dateList = [];
    startDay = DateTime.now();
    endDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    for (int i = 1; i < endDay.day + 1; i++) {
      dateList.add(DateTime(endDay.year, endDay.month, i));
    }
  }

  onChangeMonth(DateTime now) {
    startDay = DateTime(now.year, now.month, 1);
    endDay = DateTime(now.year, now.month + 1, 0);
    notifyListeners();
  }

  onChangeDisplay(String title) {
    selectDisplay = title;
    notifyListeners();
  }

  onChangeLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  getEntryData(String id) async {
    entryList = await EntryExitApiService().getAllEntryList(id);
    onChangeLoading(false);
  }
}
