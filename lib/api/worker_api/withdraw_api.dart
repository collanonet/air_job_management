import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawApi{

  var withdrawCollection = FirebaseFirestore.instance.collection('withdraw_history');

  Withdraw(
      { required amount,
        required createdAt,
        date,
        required status,
        time,
        updatedAt,
        required workerID,
        required workerName}) {
    withdrawCollection.add({
      "amount": amount,
      "created_at": createdAt,
      "date": date,
      "status": status,
      "time": time,
      "updated_at": updatedAt,
      "worker_id": workerID,
      "worker_name": workerName,
    });
  }

  Future<bool> isPending(String? uid) async {
    QuerySnapshot isPendingWithdraw = await FirebaseFirestore.instance.collection('withdraw_history').where("worker_id", isEqualTo: uid)
                                                                                          .where("status", isEqualTo: "pending").get();
    int count = isPendingWithdraw.docs.length;
    //print(count);
    if (count > 0) {
      //print("refWithdrawPending has value ${count}");
      return true;
    }
    else{
      //print("refWithdrawPending is null");
      return false;
    }
  }
}