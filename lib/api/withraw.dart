import 'package:air_job_management/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/widthraw.dart';

class WithdrawApiService {
  var withdrawRef = FirebaseFirestore.instance.collection('withdraw_history');
  var userRef = FirebaseFirestore.instance.collection('user');

  Future<List<WithdrawModel>> getAllWithdraw(String companyId) async {
    try {
      var doc = await withdrawRef.where("company_id", isEqualTo: companyId).get();
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
    } catch (e) {
      debugPrint("Error getAllWithdraw =>> ${e.toString()}");
      return [];
    }
  }

  Future<String?> approveOrRejectWithdraw(WithdrawModel withdrawModel) async {
    try {
      await withdrawRef
          .doc(withdrawModel.uid)
          .update({"status": withdrawModel.status, "reason": withdrawModel.reason, "transactionImageUrl": withdrawModel.transactionImageUrl});
      if (withdrawModel.status == "approved") {
        await userRef.doc(withdrawModel.workerID).update({"balance": "0"});
      } else {
        await userRef.doc(withdrawModel.workerID).update({"balance": "${withdrawModel.amount}"});
      }
      return ConstValue.success;
    } catch (e) {
      debugPrint("Error getAllWithdraw =>> ${e.toString()}");
      return null;
    }
  }
}
