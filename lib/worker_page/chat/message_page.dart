import 'dart:io';

import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/chat.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagePage extends StatefulWidget {
  final String companyID;
  final String? companyName;
  final String? companyImageUrl;

  const MessagePage({
    super.key,
    required this.companyID,
    this.companyName,
    this.companyImageUrl,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String get companyName {
    if (widget.companyName != null) {
      return widget.companyName!;
    }
    return "Unknown";
  }

  late AuthProvider authProvider;

  late final MessageApi messageApi;

  late final Stream messageStream;

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    messageApi = MessageApi(authProvider.myUser?.uid ?? "", widget.companyID);
    messageStream = messageApi.getConversationMessage;
    super.initState();
  }

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              backgroundImage: NetworkImage(widget.companyImageUrl ?? ""),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(companyName)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList,
          ),
          if (isSending)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CupertinoActivityIndicator(),
                SizedBox(width: 10),
                Text("Sending..."),
                SizedBox(width: 16),
              ],
            ),
          buildSendMessageWidget(),
        ],
      ),
    );
  }

  Widget get buildMessageList {
    return StreamBuilder(
      key: const ValueKey("1111"),
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Something went wrong, please go back and turn in again!!!',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        // snapshot.data?.docs.sort((a, b) {
        //   var messageA = MessageModel.fromJson(a.data() as Map<String, dynamic>);
        //   var messageb = MessageModel.fromJson(a.data() as Map<String, dynamic>);
        //   return messageA.createdAt.compareTo(messageb.createdAt);
        // });

        return ListView.separated(
          cacheExtent: 10000,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          reverse: true,
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data();
            var message = MessageModel.fromJson(data as Map<String, dynamic>);
            bool isMe = message.senderId == authProvider.myUser!.uid;
            return Row(
              children: [
                if (isMe) const Spacer(),
                Column(
                  crossAxisAlignment: !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        maxWidth: 300,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: !isMe ? Theme.of(context).colorScheme.surfaceVariant : AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: [
                        Text(
                          message.message,
                          style: TextStyle(
                            color: !isMe ? Theme.of(context).colorScheme.onSurfaceVariant : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launchUrl(Uri.parse(message.message));
                          },
                          child: Image.network(
                            message.message,
                            key: ValueKey(message.message),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            launchUrl(Uri.parse(message.message));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_file_outlined,
                                color: !isMe ? Theme.of(context).colorScheme.onSurfaceVariant : Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  message.originalName,
                                  style: TextStyle(
                                    color: !isMe ? Theme.of(context).colorScheme.onSurfaceVariant : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ][message.type],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        message.createdAt.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(height: 10);
          },
        );
      },
    );
  }

  final messageCtr = TextEditingController();

  buildSendMessageWidget() {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              sendFileMessage(isImage: true);
            },
            icon: const Icon(Icons.image_outlined),
          ),
          IconButton(
            onPressed: () {
              sendFileMessage();
            },
            icon: const Icon(Icons.attach_file_outlined),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Center(
                child: TextField(
                  controller: messageCtr,
                  decoration: const InputDecoration.collapsed(
                    hintText: "メッセージを入力してください",
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (messageCtr.text.isNotEmpty) {
                setState(() {
                  isSending = true;
                });
                final message = MessageModel(
                    message: messageCtr.text, senderId: authProvider.myUser!.uid!, receiverId: widget.companyID, createdAt: DateTime.now());
                messageCtr.clear();
                messageApi.messageRef.add(message.toJson()).then((value) {
                  setState(() {
                    isSending = false;
                  });
                }).catchError((e) {
                  setState(() {
                    isSending = false;
                  });
                  messageCtr.text = message.message;
                  Fluttertoast.showToast(msg: e);
                });
                addChat();
              }
            },
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }

  void addChat() {
    var user = authProvider.myUser;
    var chat = "chat_${user?.uid}_${widget.companyID}";
    if (!(user?.messageList!.contains(chat) ?? false)) {
      user?.messageList!.add("chat_${user.uid}_${widget.companyID}");
      UserApiServices().userRef.doc(user?.uid).update(user?.toJson() ?? {}).then((value) {
        authProvider.myUser?.messageList!.add(chat);
      });
    }
  }

  void sendFileMessage({bool isImage = false}) {
    FilePicker.platform
        .pickFiles(
      type: isImage ? FileType.image : FileType.any,
    )
        .then((value1) {
      if (value1?.files.isNotEmpty ?? false) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Send ${isImage ? "Image" : "File"}"),
                content: Text("Do you want to send ${value1?.files.first.name} ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No"),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isSending = true;
                      });
                      FirebaseStorage.instance
                          .ref()
                          .child(
                            "${isImage ? "images" : "files"}/chat_${authProvider.myUser?.uid}_${widget.companyID}/${DateTime.now().millisecondsSinceEpoch}.${value1?.files.first.extension}",
                          )
                          .putFile(
                            File(value1!.files.first.path!),
                          )
                          .then((value2) async {
                        var message = MessageModel(
                          message: await value2.ref.getDownloadURL(),
                          senderId: authProvider.myUser?.uid ?? '',
                          receiverId: widget.companyID,
                          type: isImage ? 1 : 2,
                          originalName: value1.files.first.name,
                        );
                        messageApi.messageRef.add(message.toJson()).then((value) {
                          setState(() {
                            isSending = false;
                          });
                        }).catchError((e) {
                          setState(() {
                            isSending = false;
                          });
                          Fluttertoast.showToast(msg: e);
                        });
                      }).catchError((e) {
                        setState(() {
                          isSending = false;
                        });
                        Fluttertoast.showToast(msg: e);
                      });
                      addChat();
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            });
      }
    });
  }
}
