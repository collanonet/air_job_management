import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? selectedCompanyName;
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
      return Row(
        children: [
          SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.3,
            child: ListView.builder(
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
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("user").doc(userId).snapshots(),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.data();
                    bool isLoading = snapshot.connectionState == ConnectionState.waiting;
                    if (data == null) {
                      return const SizedBox();
                    }
                    return ListTile(
                      onTap: () async {
                        setState(() {
                          clickedMessage = null;
                          selectedCompanyName = company?.companyName ?? "";
                        });
                        await Future.delayed(const Duration(milliseconds: 300));
                        setState(() {
                          clickedMessage = item;
                        });
                      },
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        backgroundImage: NetworkImage(
                          data["profile"] ?? "",
                        ),
                      ),
                      title: Text(isLoading ? "Loading..." : "${data["full_name"] ?? "Unknown"} (${company?.companyName ?? ""})"),
                      subtitle: StreamBuilder(
                        stream: MessageApi(widget.id, companyID).messageRef.limit(1).orderBy("created_at", descending: true).snapshots(),
                        builder: (context, snapshot) {
                          var d = snapshot.data?.docs.firstOrNull;
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
          ),
          Expanded(
              child: Container(
            decoration: boxDecoration,
            height: AppSize.getDeviceHeight(context) * 0.7,
            child: clickedMessage == null
                ? const Center(
                    child: Text("メッセージを表示するには、チャットを選択してください。 "),
                  )
                : MessagePage(
                    companyID: clickedMessage!.split("_").last,
                    companyImageUrl: myUser!.profileImage,
                    userId: widget.id,
                    companyName: "${myUser!.lastName} ${myUser!.firstName} ($selectedCompanyName)",
                    onClose: () {
                      setState(() {
                        clickedMessage = null;
                      });
                    },
                  ),
          ))
        ],
      );
    }
  }

  @override
  void afterBuild(BuildContext context) async {
    myUser = await UserApiServices().getProfileUser(widget.id);
    companyList = await CompanyApiServices().getAllCompany();
    if (myUser!.messageList != null && myUser!.messageList!.isNotEmpty) {
      clickedMessage = myUser!.messageList![0];
      for (var c in companyList) {
        if (c.uid == clickedMessage!.split("_").last) {
          selectedCompanyName = c.companyName;
          break;
        }
      }
    }
    loading.value = false;
    setState(() {});
  }
}

class MessageApi {
  final String _uid;
  final String _companyID;
  late final CollectionReference messageRef;

  MessageApi(this._uid, this._companyID) {
    print("chats/chat_${_uid}_$_companyID/messages");
    messageRef = FirebaseFirestore.instance.collection("chats/chat_${_uid}_$_companyID/messages");
  }

  Stream<QuerySnapshot> get getConversationMessage {
    return messageRef.orderBy("created_at", descending: false).snapshots();
  }
}

class MessagePage extends StatefulWidget {
  final String companyID;
  final String? companyName;
  final String? companyImageUrl;
  final String? userId;
  final Function onClose;

  const MessagePage({
    super.key,
    required this.companyID,
    required this.onClose,
    this.companyName,
    this.companyImageUrl,
    this.userId,
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

  late final MessageApi messageApi;

  late final Stream messageStream;

  @override
  void initState() {
    messageApi = MessageApi(widget.userId ?? "", widget.companyID);
    messageStream = messageApi.getConversationMessage;
    super.initState();
  }

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose();
            }),
        titleSpacing: 0,
        backgroundColor: AppColor.primaryColor,
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
        return ListView.separated(
          cacheExtent: 10000,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          reverse: true,
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data();
            var message = MessageModel.fromJson(data as Map<String, dynamic>);
            bool isMe = message.senderId == widget.companyID;
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
                  message: messageCtr.text,
                  senderId: widget.companyID,
                  receiverId: widget.userId ?? "",
                );
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
                  toastMessageError(e, context);
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
    // var user = authProvider.myUser;
    // var chat = "chat_${user?.uid}_${widget.companyID}";
    // if (!(user?.messageList.contains(chat) ?? false)) {
    //   user?.messageList.add("chat_${user.uid}_${widget.companyID}");
    //   UserApiService().userRef.doc(user?.uid).update(user?.toJson() ?? {}).then((value) {
    //     authProvider.myUser?.messageList.add(chat);
    //   });
    // }
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
                            "${isImage ? "images" : "files"}/chat_${widget.userId}_${widget.companyID}/${DateTime.now().millisecondsSinceEpoch}.${value1?.files.first.extension}",
                          )
                          .putData(value1!.files.first.bytes!)
                          .then((value2) async {
                        var message = MessageModel(
                          message: await value2.ref.getDownloadURL(),
                          senderId: widget.companyID ?? "",
                          receiverId: widget.userId ?? "",
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
                          toastMessageError(e, context);
                        });
                      }).catchError((e) {
                        setState(() {
                          isSending = false;
                        });
                        toastMessageError(e, context);
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

class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String originalName;
  final int type;
  late final DateTime createdAt;

  String get subtitle => [message, originalName, originalName][type];

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    this.type = 0,
    this.originalName = "An Attachment",
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        message: json['message'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        type: json['type'] ?? 0,
        originalName: json['original_name'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'original_name': originalName,
        'type': type,
        'created_at': createdAt.toIso8601String(),
      };
}
