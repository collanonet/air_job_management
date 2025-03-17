import 'package:air_job_management/helper/date_to_api.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/chat.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/user_api.dart';
import '../../../services/send_email.dart';
import '../../../utils/app_color.dart';

class CompanyChatPage extends StatefulWidget {
  final MyUser myUser;
  final String companyID;
  final String? companyName;
  final String? companyImageUrl;

  const CompanyChatPage({
    super.key,
    required this.myUser,
    required this.companyID,
    this.companyName,
    this.companyImageUrl,
  });

  @override
  State<CompanyChatPage> createState() => _CompanyChatPageState();
}

class _CompanyChatPageState extends State<CompanyChatPage> with AfterBuildMixin {
  String get companyName {
    if (widget.companyName != null) {
      return widget.companyName!;
    }
    return "Unknown";
  }

  ScrollController scrollController = ScrollController();
  late final MessageApi messageApi;

  late final Stream messageStream;

  @override
  void initState() {
    messageApi = MessageApi(widget.myUser.uid ?? "", widget.companyID);
    messageStream = messageApi.getConversationMessage;
    super.initState();
  }

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecoration,
        child: Column(
          children: [
            Expanded(
              child: buildMessageList,
            ),
            if (isSending)
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(width: 10),
                  Text("送信..."),
                  SizedBox(width: 16),
                ],
              ),
            buildSendMessageWidget(),
          ],
        ),
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
            '何かが間違っていた！',
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
        return Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.separated(
            controller: scrollController,
            cacheExtent: 10000,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data();
              var message = MessageModel.fromJson(data as Map<String, dynamic>);
              bool isMe = message.senderId == widget.companyID;
              Map<String, dynamic>? oldData;
              if (index > 0) {
                oldData = snapshot.data!.docs[index - 1].data()! as Map<String, dynamic>;
              }
              if (!isMe && ((index + 1) == snapshot.data!.docs.length)) {
                MessageApi(message.senderId, widget.companyID).updateSeen(snapshot.data!.docs[index].id);
              }
              bool isRead = data["isSeen"] ?? false;
              if (!isMe && !isRead) {
                //Seen Chat in detail screen
                MessageApi(widget.myUser.uid!, widget.companyID).updateSeen(snapshot.data!.docs[index].id);
              }
              return Column(
                children: [
                  buildDateAndMonth(oldData, parseTimeStampToDate(DateTime.parse(data["created_at"]))),
                  Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      isMe
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${DateToAPIHelper.timeFormat(DateTime.parse(message.createdAt.toString()))} ${isRead ? "既読" : "未読"}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 9,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 40,
                          maxWidth: AppSize.getDeviceWidth(context) * 0.6,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: !isMe ? const Color(0xffF0F3F5) : const Color(0xffFFF2D3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: [
                          Text(
                            message.message,
                            style: kNormalText.copyWith(fontSize: 16, color: AppColor.darkGrey),
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
                      !isMe
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${DateToAPIHelper.timeFormat(DateTime.parse(message.createdAt.toString()))} ${isRead ? "既読" : "未読"}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 9,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) {
              return const SizedBox(height: 10);
            },
          ),
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
                bool isError = false;
                final message =
                    MessageModel(message: messageCtr.text, senderId: widget.companyID, receiverId: widget.myUser.uid!, createdAt: DateTime.now());
                messageCtr.clear();
                messageApi.messageRef.add(message.toJson()).then((value) {
                  setState(() {
                    isSending = false;
                  });
                  animateListToLatest();
                }).catchError((e) {
                  setState(() {
                    isError = true;
                    isSending = false;
                  });
                  messageCtr.text = message.message;
                  Fluttertoast.showToast(msg: e);
                });
                addChat();
                if (!isError) {
                  NotificationService.sendPushMessage(token: widget.myUser.fcmToken ?? "", companyName: companyName, msg: messageCtr.text);
                }
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
    var user = widget.myUser;
    var chat = "chat_${user.uid}_${widget.companyID}";
    if (!(user.messageList!.contains(chat) ?? false)) {
      user.messageList!.add("chat_${user.uid}_${widget.companyID}");
      UserApiServices().userRef.doc(user.uid).update(user.toJson());
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
                            "${isImage ? "images" : "files"}/chat_${widget.myUser.uid}_${widget.companyID}/${DateTime.now().millisecondsSinceEpoch}.${value1?.files.first.extension}",
                          )
                          .putData(
                            value1!.files.first.bytes!,
                          )
                          .then((value2) async {
                        var message = MessageModel(
                          message: await value2.ref.getDownloadURL(),
                          senderId: widget.companyID,
                          receiverId: widget.myUser.uid!,
                          type: isImage ? 1 : 2,
                          originalName: value1.files.first.name,
                        );
                        bool isError = false;
                        messageApi.messageRef.add(message.toJson()).then((value) {
                          setState(() {
                            isSending = false;
                          });
                        }).catchError((e) {
                          setState(() {
                            isError = true;
                            isSending = false;
                          });
                          Fluttertoast.showToast(msg: e);
                        });
                        if (!isError) {
                          NotificationService.sendPushMessage(token: widget.myUser.fcmToken ?? "", companyName: companyName, msg: "ファイルイメージをお送りします。");
                        }
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

  Widget buildDateAndMonth(Map<String, dynamic>? oldData, String createAt) {
    if (oldData == null || createAt != parseTimeStampToDate(DateTime.parse(oldData["created_at"]))) {
      return Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            createAt,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  animateListToLatest() {
    scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  void afterBuild(BuildContext context) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    // animateListToLatest();
  }
}

String parseTimeStamp(int value) {
  var date = DateTime.fromMillisecondsSinceEpoch(value);
  var d12 = DateFormat('hh:mm a').format(date);
  return d12;
}

String parseTimeStampToDate(DateTime date) {
  var d12 = "${date.month}月${date.day}日";
  return d12;
}
