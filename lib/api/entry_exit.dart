import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/entry_exit_history.dart';
import '../utils/log.dart';

class EntryExitApiService {
  var entryRef = FirebaseFirestore.instance.collection("entry_exit_history");

  Future<List<EntryExitHistory>> getAllEntryList(String id) async {
    try {
      var doc = await entryRef.where("companyId", isEqualTo: id).get();
      List<EntryExitHistory> entryList = [];
      if (doc.size > 0) {
        for (var data in doc.docs) {
          EntryExitHistory entryExitHistory = EntryExitHistory.fromJson(data.data());
          entryExitHistory.uid = data.id;
          entryList.add(entryExitHistory);
        }
        return entryList;
      } else {
        return [];
      }
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return [];
    }
  }
}
