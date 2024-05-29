import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../api/worker_api/chat_api.dart';
import '../models/worker_model/message_model.dart';

class NotificationService {
  String authorizationKey =
      "key=AAAAXT3-x4U:APA91bF8lrsg7f214jIoU1DU3_5IHnF4gQb-cARbtc_4Ie-YWCrHWULI-qrk0ol2i1GDvGTIo3S40rYwvpvY3OowPhr58JkRgFoUYiNxin9pzys5Gf8_DvA0I9fT4PCB24HfYKpf8Rag";

  String constructFCMPayload(bool isApprove, String? token, String name, String msg) {
    return jsonEncode({
      'to': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
      },
      'notification': {
        'android_channel_id': 'gpswork',
        'title': 'GPSワーク',
        'body': 'Your request has been ${isApprove ? "approved" : "rejected"} by $name ($msg)',
      },
    });
  }

  Future<void> sendPushMessage({required bool isApprove, required String token, required String name, required String msg}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {'Content-Type': 'application/json', 'Authorization': authorizationKey},
        body: constructFCMPayload(isApprove, token, name, msg),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static sendEmail(
      {required String email,
      required String msg,
      required String name,
      required String userId,
      required String companyId,
      required String companyName,
      required String branchId,
      required String branchName,
      required String managerName,
      required String startTime,
      required String endTime,
      required String status,
      required String date,
      required String request,
      required bool isEditStartTime,
      required bool isHoliday,
      required bool isLeaveEarly}) {
    try {
      String text = "";
      //Start Time
      if (isEditStartTime) {
        if (status == "approved") {
          text = """ 
  $name様

  この度就業開始時間の変更申請を受領しました。
  以下の変更申請を承認します。

  新たな就業開始時間に変更
  1. ${date.split("/")[1]}/${date.split("/")[2]} : $startTime〜$endTime 
 
  ご確認の程宜しくお願いします。

  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        } else {
          text = """ 
  $name様

  この度就業開始時間の変更申請を受領しました。
  申請頂いた日時については、
  シフトの調整ができませんでしたの不承認とさせて頂きます。
  直接ご相談させる場合は、ご担当者まで連絡ください。
  宜しくお願い致します。

  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        }
      }

      //LeaveEarly
      if (isLeaveEarly) {
        if (status == "approved") {
          text = """ 
  $name様

  この度就業終了時間の変更申請を受領しました。
  以下の変更申請を承認します。

  新たな就業終了時間に変更
  1. ${date.split("/")[1]}/${date.split("/")[2]} : $startTime〜$endTime 
 
  ご確認の程宜しくお願いします。

  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        } else {
          text = """ 
  $name様

  この度就業終了時間の変更申請を受領しました。
  申請頂いた日時については、
  シフトの調整ができませんでしたの不承認とさせて頂きます。
  直接ご相談させる場合は、ご担当者まで連絡ください。
  宜しくお願い致します。


  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        }
      }

      //Holiday
      if (isLeaveEarly) {
        if (status == "approved") {
          text = """ 
  $name様

  この度就業終了時間の変更申請を受領しました。
  以下の変更申請を承認します。

  新たな就業終了時間に変更
  1. ${date.split("/")[1]}/${date.split("/")[2]} : $startTime〜$endTime 
 
  ご確認の程宜しくお願いします。

  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        } else {
          text = """ 
  $name様

  この度就業終了時間の変更申請を受領しました。
  申請頂いた日時については、
  シフトの調整ができませんでしたの不承認とさせて頂きます。
  直接ご相談させる場合は、ご担当者まで連絡ください。
  宜しくお願い致します。


  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        }
      }
      var messageApi = MessageApi(userId, companyId);
      final message = MessageModel(message: text, senderId: companyId, receiverId: userId, createdAt: DateTime.now());
      messageApi.messageRef.add(message.toJson());
      FirebaseFirestore.instance.collection("mail").add({
        "to": email,
        "company_name": companyName,
        "company_id": companyId,
        "company_branch": branchId,
        "user_id": userId,
        "username": name,
        "date": DateTime.now(),
        "message": {
          "subject": msg,
          "text": text,
          "html": text,
        },
      });
      print('Email request for device sent!');
    } catch (e) {
      print('Error send $e');
    }
  }

  static sendEmailApplyShift(
      {required String email,
      required String msg,
      required String name,
      required String userId,
      required String companyId,
      required String companyName,
      required String branchName,
      required String managerName,
      required String startTime,
      required String endTime,
      required String branchId,
      required String status,
      required String date}) {
    try {
      String text = "";
      if (status == "approved") {
        text = """ 
  $name様

  この度は掲載求人にご応募頂きまして、誠にありがとうございます。

  ご応募頂きました、下記シフトで確定できましたので、
  ご確認のほど宜しくお願い致します。
  シフト確定日：
  1. ${date.split("/")[1]}/${date.split("/")[2]} : $startTime〜$endTime 
  
  勤務にあたり注意事項や事前のご連絡は、
  追って担当者からご連絡させて頂きます。
  
  それでは当日の勤務宜しくお願いします。
  
  スタッフ一同ご一緒に働けますことを楽しみにしております。
  
  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
      } else {
        text = """ 
  $name様

  この度は掲載求人にご応募頂きまして、誠にありがとうございます。

  ご応募頂きましたシフト日程では、
  残念ながらシフトのマッチングができませんでした。
  
  引き続き他の日程でご検討可能な日程がありましたら、
  ご応募のほど引き続き宜しくお願い致します。

  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
      }
      var messageApi = MessageApi(userId, companyId);
      final message = MessageModel(message: text, senderId: companyId, receiverId: userId, createdAt: DateTime.now());
      messageApi.messageRef.add(message.toJson());
      FirebaseFirestore.instance.collection("mail").add({
        "to": email,
        "company_name": companyName,
        "company_id": companyId,
        "company_branch": branchId,
        "user_id": userId,
        "username": name,
        "date": DateTime.now(),
        "message": {
          "subject": msg,
          "text": text,
          "html": text,
        },
      });
      print('Email request for device sent!');
    } catch (e) {
      print('Error send $e');
    }
  }
}
