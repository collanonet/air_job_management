import 'package:air_job_management/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  late bool isfav;

  onget() {
    try {
      var user = AuthProvider().firebaseAuth.currentUser!.uid;
      var favdata = FirebaseFirestore.instance;
      final docRef = favdata.collection("favourite").doc(user);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          var favjob = data["search_job_id"] ?? [];
          for (var i = 0; i < favjob.length; i++) {
            lists.add(favjob[i]);
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );
    } catch (e) {
      lists = [];
    }
    notifyListeners();
  }

  List<String> lists = [];
  var favoritecollection = FirebaseFirestore.instance;

  onfav(var uid) {
    if (lists.contains(uid)) {
      lists.remove(uid);
      lists.remove(uid);
      isfav = false;
    } else {
      lists.add(uid);
      isfav = true;
    }
    notifyListeners();
  }

  ontap(var docId, var item) {
    if (isfav == true) {
      favoritecollection.collection("favourite").doc(AuthProvider().firebaseAuth.currentUser!.uid.toString()).update({
        "search_job_id": FieldValue.arrayUnion([docId])
      }).onError((e, _) => print("Error writing document: $e"));
    } else {
      favoritecollection.collection("favourite").doc(AuthProvider().firebaseAuth.currentUser!.uid.toString()).update({
        "search_job_id": FieldValue.arrayRemove([docId])
      });
    }
    notifyListeners();
  }
}
