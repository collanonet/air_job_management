import 'package:air_job_management/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  late bool isfav;
  ontap(var docId, var item) {
    if (isfav == true) {
      favoritecollection.collection('search_job').doc(docId).update({"favorite": true});
      favoritecollection.collection("favourite").doc(AuthProvider().firebaseAuth.currentUser!.uid.toString()).update({
        "search_job_id": FieldValue.arrayUnion([docId])
      }).onError((e, _) => print("Error writing document: $e"));
    } else {
      favoritecollection.collection('search_job').doc(docId).update({"favorite": false});
      favoritecollection.collection("favourite").doc(AuthProvider().firebaseAuth.currentUser!.uid.toString()).update({
        "search_job_id": FieldValue.arrayRemove([docId])
      });
    }
    notifyListeners();
  }

  var favoritecollection = FirebaseFirestore.instance;
}
