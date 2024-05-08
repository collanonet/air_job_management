import 'package:flutter/material.dart';

import '../models/entry_exit_history.dart';

class ReportProvider with ChangeNotifier {
  List<EntryExitHistory> reportList = [];
  bool isLoading = false;
}
