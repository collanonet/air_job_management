import 'package:cloud_firestore/cloud_firestore.dart';

class MessageApi {
  final String _uid;
  final String _companyID;
  late final CollectionReference messageRef;

  MessageApi(this._uid, this._companyID) {
    messageRef = FirebaseFirestore.instance.collection("chats/chat_${_uid}_$_companyID/messages");
  }

  Stream<QuerySnapshot> get getConversationMessage {
    return messageRef.orderBy("created_at", descending: true).snapshots();
  }
}
