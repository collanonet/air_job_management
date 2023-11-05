import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../models/company.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/empty_data.dart';
import '../../../widgets/loading.dart';

class ChatPage extends StatefulWidget {
  final String id;
  const ChatPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AfterBuildMixin {
  MyUser? myUser;
  ValueNotifier loading = ValueNotifier<bool>(true);
  String? clickedMessage;
  List<Company> companyList = [];

  @override
  void initState() {
    loading.value = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = myUser?.messageList ?? [];
    if (loading.value) {
      return Center(child: LoadingWidget(AppColor.primaryColor));
    } else if (list.isEmpty) {
      return const Center(child: EmptyDataWidget());
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          var item = list[index];
          var userId = item.split("_")[1];
          var companyID = item.split("_").last;
          Company? company;
          for (var c in companyList) {
            if (c.uid == companyID) {
              company = c;
              break;
            }
          }
          return FutureBuilder(
            future:
                FirebaseFirestore.instance.collection("user").doc(userId).get(),
            builder: (context, snapshot) {
              var data = snapshot.data?.data();
              bool isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              if (data == null) {
                return const SizedBox();
              }
              return ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  backgroundImage: NetworkImage(
                    data["profile"] ?? "",
                  ),
                ),
                title: Text(isLoading
                    ? "Loading..."
                    : "${data["full_name"] ?? "Unknown"} (${company?.companyName ?? ""})"),
                subtitle: StreamBuilder(
                  stream: MessageApi(widget.id, companyID)
                      .messageRef
                      .limit(1)
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    var d = snapshot.data?.docs.firstOrNull;
                    String message = d?["message"] ?? "";
                    int type = d?["type"] ?? 1;
                    return Text(
                      snapshot.connectionState == ConnectionState.waiting
                          ? "Loading..."
                          : [message, "An Image", "A File"][type],
                    );
                  },
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    myUser = await UserApiServices().getProfileUser(widget.id);
    companyList = await CompanyApiServices().getAllCompany();
    loading.value = false;
    setState(() {});
  }
}

class MessageApi {
  final String _uid;
  final String _companyID;
  late final CollectionReference messageRef;

  MessageApi(this._uid, this._companyID) {
    messageRef = FirebaseFirestore.instance
        .collection("chats/chat_${_uid}_$_companyID/messages");
  }

  Stream<QuerySnapshot> get getConversationMessage {
    return messageRef.orderBy("created_at", descending: true).snapshots();
  }
}
