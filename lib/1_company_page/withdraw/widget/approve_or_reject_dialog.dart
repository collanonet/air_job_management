import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../2_worker_page/viewprofile/widgets/pickimage.dart';
import '../../../api/withraw.dart';
import '../../../const/const.dart';
import '../../../models/widthraw.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_button.dart';

class ApproveOrRejectWithdrawDialog extends StatefulWidget {
  final String status;
  final WithdrawModel withdrawModel;
  final Function onRefreshData;
  const ApproveOrRejectWithdrawDialog({super.key, required this.withdrawModel, required this.status, required this.onRefreshData});

  @override
  State<ApproveOrRejectWithdrawDialog> createState() => _ApproveOrRejectWithdrawDialogState();
}

class _ApproveOrRejectWithdrawDialogState extends State<ApproveOrRejectWithdrawDialog> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  FilePickerResult? selectedFile;
  String imageUrl = "";

  @override
  void initState() {
    imageUrl = widget.withdrawModel.transactionImageUrl ?? "";
    controller.text = widget.withdrawModel.reason ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          widget.status == "approved" ? "承認の確認" : "拒否の確認",
        ),
        content: SizedBox(
          width: AppSize.getDeviceHeight(context) * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                JapaneseText.remark,
                style: kNormalText,
              ),
              AppSize.spaceHeight8,
              PrimaryTextField(
                controller: controller,
                hint: JapaneseText.remark,
                isRequired: true,
                maxLine: 5,
              ),
              widget.status == "rejected"
                  ? const SizedBox()
                  : Text(
                      "銀行取引",
                      style: kNormalText,
                    ),
              AppSize.spaceHeight8,
              widget.status == "rejected"
                  ? const SizedBox()
                  : selectedFile != null
                      ? Image.memory(
                          selectedFile!.files.first.bytes!,
                          width: (280 * 16) / 9,
                          height: 280,
                        )
                      : imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: (280 * 16) / 9,
                              height: 280,
                            )
                          : Icon(
                              Icons.file_copy_outlined,
                              color: AppColor.primaryColor,
                              size: 70,
                            ),
              AppSize.spaceHeight8,
              widget.status == "approved"
                  ? SizedBox(
                      width: AppSize.getDeviceWidth(context) * 0.6,
                      child: ButtonWidget(
                        color: AppColor.secondaryColor,
                        title: "ここで銀行取引ファイルを選択",
                        onPress: () => onSelectFile(),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => onUpdateRequestStatus(widget.status, widget.withdrawModel),
              child: const Text(
                "はい",
              )),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "いいえ",
              )),
        ],
      ),
    );
  }

  onSelectFile() async {
    var file =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ["pdf", "jpg", "png", "jpeg", "db"]);
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  onUpdateRequestStatus(String status, WithdrawModel withdrawModel) async {
    if (status == "approved" && selectedFile == null) {
      toastMessageError("このアクションを実行する前に、ここに銀行取引をアップロードした後、まず労働者に支払いを行ってください。", context);
      return;
    }
    if (status == "rejected" && controller.text.isEmpty) {
      toastMessageError("備考を入力してください。この出金リクエストを拒否する理由を知る必要があります。", context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (status == "approved") {
      imageUrl = await fileToUrl(selectedFile!.files.first.bytes!, "bank_transaction");
    }
    widget.withdrawModel.status = status;
    widget.withdrawModel.transactionImageUrl = imageUrl;
    widget.withdrawModel.reason = controller.text;
    String? success = await WithdrawApiService().approveOrRejectWithdraw(withdrawModel);
    setState(() {
      isLoading = false;
    });
    if (success == ConstValue.success) {
      widget.onRefreshData();
      toastMessageSuccess(JapaneseText.successUpdate, context);
      Navigator.pop(context);
    } else {
      toastMessageError(JapaneseText.failUpdate, context);
    }
  }
}
