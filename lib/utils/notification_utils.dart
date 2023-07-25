import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NotificationUtils {
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

  Future<void> sendPushMessage(
      {required bool isApprove, required String token, required String name, required String msg}) async {
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

  static sendEmail({required String e, required String msg, required bool isApprove, required String name}) {
    try {
      FirebaseFirestore.instance.collection("mail").add({
        "to": e,
        "message": {
          "subject": msg,
          "html": 'Your request has been ${isApprove ? "approved" : "rejected"} by $name ($msg)',
        },
      });
      print('Email request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
