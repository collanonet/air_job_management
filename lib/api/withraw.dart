import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/widthraw.dart';

class WithdrawApiService {
  var withdrawRef = FirebaseFirestore.instance.collection('withdraw_history');

  Future<List<WithdrawModel>> getAllWithdraw(String companyId) async {
    // try {
      var doc = await withdrawRef.get();
      if (doc.docs.isNotEmpty) {
        List<WithdrawModel> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          WithdrawModel withdraw = WithdrawModel.fromJson(doc.docs[i].data());
          withdraw.uid = doc.docs[i].id;
          list.add(withdraw);
        }
        list.sort((a, b) => b.date!.compareTo(a.date!));
        return list;
      } else {
        return [];
      }
    // } catch (e) {
    //   debugPrint("Error getAllWithdraw =>> ${e.toString()}");
    //   return [];
    // }
  }
}
