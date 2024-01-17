import 'package:air_job_management/2_worker_page/chat/message_page.dart';
import 'package:air_job_management/api/worker_api/chat_api.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthProvider>();
    var list = provider.myUser?.messageList ?? [];
    print("List of message ${list.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text("メッセージ", style: TextStyle(fontSize: 30, color: AppColor.primaryColor)),
      ),
      body: list.isEmpty
          ? const Center(child: EmptyDataWidget())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                var companyID = item.split("_").last;
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection("company").doc(companyID).get(),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.data();
                    bool isLoading = snapshot.connectionState == ConnectionState.waiting;
                    if (data == null) {
                      return const SizedBox();
                    }
                    return ListTile(
                      onTap: () {
                        MyPageRoute.goTo(
                          context,
                          MessagePage(
                            companyID: companyID,
                            companyName: data["company_name"],
                            companyImageUrl: data["company_profile"] ?? "",
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        backgroundImage: NetworkImage(
                          data["company_profile"] ?? "",
                        ),
                      ),
                      title: Text(isLoading ? "Loading..." : data["company_name"] ?? "Unknown"),
                      subtitle: StreamBuilder(
                        stream: MessageApi(provider.myUser!.uid!, companyID).messageRef.limit(1).orderBy("created_at", descending: true).snapshots(),
                        builder: (context, snapshot) {
                          var d = snapshot.data?.docs.first;
                          String message = d?["message"] ?? "";
                          int type = d?["type"] ?? 1;
                          return Text(
                            snapshot.connectionState == ConnectionState.waiting ? "Loading..." : [message, "An Image", "A File"][type],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
