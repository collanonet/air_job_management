import 'package:air_job_management/api/entry_exit.dart';
import 'package:flutter/foundation.dart';

import '../../models/entry_exit_history.dart';
import '../../utils/japanese_text.dart';

class EntryExitHistoryProvider with ChangeNotifier {
  List<EntryExitHistory> entryList = [];
  bool isLoading = false;
  List<String> displayList = [JapaneseText.byMonth, JapaneseText.perWorker];
  String selectDisplay = JapaneseText.byMonth;
  DateTime month = DateTime.now();

  set setLoading(bool loading) {
    isLoading = loading;
  }

  onChangeMonth(DateTime now) {
    month = now;
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
