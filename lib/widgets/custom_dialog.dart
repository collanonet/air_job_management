import 'package:flutter/material.dart';

class CustomDialog {
  static void displayDialogMessage({required BuildContext context, required String msg}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "理由",
              ),
              content: Text(
                msg.toString(),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                    )),
              ],
            ));
  }

  static void sendMessage({required BuildContext context, required Function onSend, required TextEditingController controller}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "メッセージを送る",
              ),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'メッセージを入力してください'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "キャンセル",
                    )),
                TextButton(
                    onPressed: () => onSend(),
                    child: const Text(
                      "メッセージを送る",
                    )),
              ],
            ));
  }

  static void confirmDialog({required BuildContext context, required Function onApprove, String? title, String? titleText}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                titleText ?? "確認する",
              ),
              content: Text(title ?? "この求人に応募してもよろしいですか？"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "いいえ",
                    )),
                TextButton(
                    onPressed: () => onApprove(),
                    child: const Text(
                      "はい",
                    )),
              ],
            ));
  }

  static void confirmDelete({required BuildContext context, required Function onDelete}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "削除の確認",
              ),
              content: const Text("このデータを削除してもよろしいですか？"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "キャンセル",
                    )),
                TextButton(
                    onPressed: () => onDelete(),
                    child: const Text(
                      "はい",
                    )),
              ],
            ));
  }

  static void confirmApprove({required BuildContext context, required Function onApprove}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "承認の確認",
              ),
              content: const Text("このリクエストを承認してもよろしいですか？"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "キャンセル",
                    )),
                TextButton(
                    onPressed: () => onApprove(),
                    child: const Text(
                      "はい",
                    )),
              ],
            ));
  }

  static void confirmReject({required BuildContext context, required Function onReject}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text(
                "拒否の確認",
              ),
              content: const Text("このリクエストを拒否してもよろしいですか？"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "キャンセル",
                    )),
                TextButton(
                    onPressed: () => onReject(),
                    child: const Text(
                      "はい",
                    )),
              ],
            ));
  }
}
