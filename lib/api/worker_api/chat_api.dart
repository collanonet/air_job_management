import 'package:cloud_firestore/cloud_firestore.dart';

class MessageApi {
  final String _uid;
  final String _companyID;
  late final CollectionReference messageRef;

  MessageApi(this._uid, this._companyID) {
    messageRef = FirebaseFirestore.instance.collection("chats/chat_${_uid}_$_companyID/messages");
  }

  updateSeen(String uid) {
    try {
      messageRef.doc(uid).update({"isSeen": true});
    } catch (e) {
      print("Error updateSeen ${messageRef} x $uid x $e");
    }
  }

  Stream<QuerySnapshot> get getConversationMessage {
    return messageRef.orderBy("created_at", descending: true).snapshots();
  }
}
