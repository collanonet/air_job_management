import 'dart:convert';

import 'package:air_job_management/helper/date_to_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../api/worker_api/chat_api.dart';
import '../models/worker_model/message_model.dart';

class NotificationService {
  static String mail = "air-job@appspot.gserviceaccount.com";
  static String clientId = "115562053274950640697";
  static String privateKey =
      "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5LmsJO1x/M6IF\n+om40OpWgKY5yxgTKSx5wpha4VyA81uwlWuehnhGdEvD5/32FTfWhDMdYY85FKnM\nnVoJ7i/o9CiENG8pQvAKOSCYKURXK66evRWbudOreUqcK9T0COA36ld2wCE0BRHW\nDIKb4xK8K2Jq+EYJhUnrehPAddy/+mRhlxOiPnfGEe70vUyrXwacFh52iAyWGQfO\ns7/uf0/Qxp859m5IWsN+AYVrpgQKTHbReCYbpw6YZkxnBsKNzXAtoMYZ38l5xqS9\nrD4UfOk32BEZsgROp5Fm5hn/jImPvshRc3fY8n0uP/YMD0HoZrspNUkqU3Pd1caC\nGmRYvSiNAgMBAAECggEAB7v/1fif/iMYsRG8B1dYdkj0yGSqaoB1fldpmCAiBjPD\n4F35Svt4Ug8A7BuIMKtFtAS9Aszkl8B8cBKhZFlJsHvkJlNvUiSc1Hx610gf9dkZ\n98DTgnfSNq7/9gJhqFinjsZPpWLUcDEHA+7tVJf5HBleyLN6b2LdCcQFR6xUjkMT\nYSvbeiSiPydIp6MHOFeeTrnoQVYPGbrYaGMIFOkgSv4KR8NPcllWtFwgtHs09+yx\n/CGWDIoUx67VtaAkzy3zmhMuNtx4oahxaFpQwj9AvHYqw7FdtAopq+iVv90CrXe8\nXBrGig7c02RKATTWEwopHesN1b5uy5gW22AZTYlOUQKBgQD9UYRoT/HcFCYzSpQJ\nyDrCFgr6duH2RUI52U82+V1rYUEIn0dCsLWdoGaIY93aNWpVjaE8fHSIhDRjAMN2\nBGg8UVgu1RAgSHd4g4vdQV/+yuTx2NdBDwzOBqs7C7Zkp4P/hkyQYzAWag1bud6Y\nJdKzm6dy8KW+Sahu6E3TIr0l3QKBgQC7JECHdGzia2CKLJxbSTEo+McsZKA5dDhE\ngKgKDNhE/RY4y0777T14kcvNWJhmhEXz1Aw0aAdy/6HY5WZadwpFOu1mm9d+iImM\nn4hv7EsYU3krGOhJZRLaMHA2PTSfnQVH9IAi7wvmMXJraz8EKcK0/J8vcXbafr9W\nqzjgFhMacQKBgQCSdoNb3H02hd/gYApf7YkrlpsaXYogXcMAt4h5fIxq/XwghBcr\nlAgt7wPZcARhmei1NoI2+q5WEDpJ07MvlTS/Szj1OvNr9vo8j7JaZuYd5ymgO4OZ\ndh4tMOXn6cm3QLOtFfVGtlKjYwX+NuVgit3cQu76IfFyqBvepCn7HWbHcQKBgBg0\nxzf+IjtjQjh9LrhMDlTLYQ/n8CWeV8zci1/Ja4v45I/yFERX2nSm/yKPjB7uixHP\n4shAkH4afLfObF/VN/nedmioTcZrKMeMtxwrB0edPHYLobgkn7yjOVB6uDzRFabK\nBG0AWJys1qz4UU1bjXjVmE2Nsp7ueBdgzFmH4W6xAoGAfNeRUixnOkE3og0ihpn6\nDMShRwUGarRT9aYN9dD0H700iGg90bb/HcXuEk43944C1Y7S6yFmGjOzccSLX7cs\nPLikwq/I5aW8O5s6vwJUKmM3a0PZjQpA/hsf4MfwoBkkdcVxMVhLsMTQsjyLWYOo\nTI2kG7Nlu2bUV4JjM8tkcfk=\n-----END PRIVATE KEY-----\n";

  static getToken() async {
    var accountCredential = ServiceAccountCredentials(mail, ClientId(clientId), privateKey);
    final scope = ["https://www.googleapis.com/auth/firebase.messaging"];
    AuthClient authClient = await clientViaServiceAccount(accountCredential, scope)
      ..close();
    return authClient.credentials.accessToken.data;
  }

  static Future<void> sendPushMessage({required String token, required String companyName, required String msg}) async {
    try {
      var bearerToken = await getToken();
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/air-job/messages:send'),
        headers: <String, String>{'Content-Type': 'application/json', "Authorization": "Bearer $bearerToken"},
        body: constructFCMPayload(msg: msg, companyName: companyName, token: token),
      );
      print('${response.body} FCM request for device sent!');
    } catch (e) {
      print("Error notification is $e");
    }
  }

  static String constructFCMPayload({required String token, required String msg, required String companyName}) {
    return jsonEncode({
      "message": {
        'token': token,
        'notification': {
          'title': companyName,
          'body': msg,
        }
      }
    });
  }

  static sendEmail(
      {required String email,
      required String token,
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

  この度早退申請を受領しました。
  以下の早退申請を承認します。

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

  この度早退申請を受領しました。
  申請頂いた日時については、
  シフトの調整ができませんでしたので、不承認とさせて頂きます。
  直接ご相談させる場合は、ご担当者まで連絡ください。
  宜しくお願い致します。


  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        }
      }

      //Holiday
      if (isHoliday) {
        if (status == "approved") {
          text = """ 
  $name様

  この度休日申請を受領しました。
  以下の日程の休日申請を承認します。

  1. ${date.split("/")[1]}/${date.split("/")[2]} : $startTime〜$endTime 
 
  ご確認の程宜しくお願いします。

  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """;
        } else {
          text = """ 
  $name様

  この度休日申請を受領しました。
  申請頂いた日時については、
  シフトの調整ができませんでしたので、不承認とさせて頂きます。
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
      if (token.isNotEmpty) {
        sendPushMessage(token: token, companyName: "$companyName 会社 | $branchName 店 | 担当：$managerName", msg: text);
      }
      FirebaseFirestore.instance.collection("mail").add({
        "to": email,
        "company_name": companyName,
        "company_id": companyId,
        "company_branch": branchId,
        "user_id": userId,
        "username": name,
        "created_at": DateTime.now(),
        "isJobApply": false,
        "isSeeker": false,
        "applyDate": DateToAPIHelper.fromApiToLocal(date),
        "isHoliday": isHoliday,
        "isStartTime": isEditStartTime,
        "isLeaveEarly": isLeaveEarly,
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
      {required String token,
      required String email,
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
      required List<String> date}) {
    try {
      String text = "";
      String htmlText = "";
      if (status == "approved") {
        text = """ 
  $name様

  この度は掲載求人にご応募頂きまして、誠にありがとうございます。

  ご応募頂きました、下記シフトで確定できましたので、
  ご確認のほど宜しくお願い致します。
  シフト確定日：
  ${date.map((e) {
          int index = date.indexOf(e) + 1;
          return "$index. ${e.split("/")[1]}/${e.split("/")[2]} : $startTime〜$endTime　\n";
        })}
  
  勤務にあたり注意事項や事前のご連絡は、
  追って担当者からご連絡させて頂きます。
  
  それでは当日の勤務宜しくお願いします。
  
  スタッフ一同ご一緒に働けますことを楽しみにしております。
  
  
  $companyName 会社
  $branchName 店
  担当：$managerName
                  """
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll(",", " ");
        htmlText = """
        <!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>シフト確定通知</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .header {
            font-size: 18px;
            font-weight: bold;
        }
        .footer {
            margin-top: 20px;
            font-size: 14px;
        }
        .shift-list {
            margin-top: 10px;
            padding-left: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <p class="header">$name様</p>

    <p>この度は掲載求人にご応募頂きまして、誠にありがとうございます。</p>

    <p>ご応募頂きました、下記シフトで確定できましたので、<br>
       ご確認のほど宜しくお願い致します。</p>

    <p><strong>シフト確定日：</strong></p>
    <ul class="shift-list">
        ${date.map((e) {
          int index = date.indexOf(e) + 1;
          return "<li>" + index.toString() + ". " + e.split("/")[1] + "/" + e.split("/")[2] + " : " + startTime + "〜" + endTime + "</li>";
        }).join("")}
    </ul>

    <p>勤務にあたり注意事項や事前のご連絡は、<br>
       追って担当者からご連絡させて頂きます。</p>

    <p>それでは当日の勤務宜しくお願いします。</p>

    <p>スタッフ一同ご一緒に働けますことを楽しみにしております。</p>

    <div class="footer">
        <p><strong>$companyName 会社</strong></p>
        <p>$branchName 店</p>
        <p>担当：$managerName</p>
    </div>
</div>

</body>
</html>
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
        htmlText = """
        <!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>シフトマッチング不可のお知らせ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .header {
            font-size: 18px;
            font-weight: bold;
        }
        .footer {
            margin-top: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="container">
    <p class="header">$name様</p>

    <p>この度は掲載求人にご応募頂きまして、誠にありがとうございます。</p>

    <p>ご応募頂きましたシフト日程では、<br>
       残念ながらシフトのマッチングができませんでした。</p>

    <p>引き続き他の日程でご検討可能な日程がありましたら、<br>
       ご応募のほど引き続き宜しくお願い致します。</p>

    <div class="footer">
        <p><strong>$companyName 会社</strong></p>
        <p>$branchName 店</p>
        <p>担当：$managerName</p>
    </div>
</div>

</body>
</html>

        """;
      }
      var messageApi = MessageApi(userId, companyId);
      final message = MessageModel(message: text, senderId: companyId, receiverId: userId, createdAt: DateTime.now());
      messageApi.messageRef.add(message.toJson());
      if (token.isNotEmpty) {
        sendPushMessage(token: token, companyName: "$companyName 会社 | $branchName 店 | 担当：$managerName", msg: text);
      }
      FirebaseFirestore.instance.collection("mail").add({
        "to": email,
        "company_name": companyName,
        "company_id": companyId,
        "company_branch": branchId,
        "user_id": userId,
        "username": name,
        "isSeeker": false,
        "applyDate": DateTime.now(),
        "isJobApply": true,
        "isHoliday": false,
        "isStartTime": false,
        "isLeaveEarly": false,
        "created_at": DateTime.now(),
        "message": {
          "subject": msg,
          "text": text,
          "html": htmlText,
        },
      });
      print('Email request for device sent!');
    } catch (e) {
      print('Error send $e');
    }
  }
}
