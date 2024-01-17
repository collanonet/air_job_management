import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/show_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/register/new_form_register.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class UploadFilePage extends StatefulWidget {
  final String title;
  final String type;
  const UploadFilePage({super.key, required this.title, required this.type});

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  FilePickerResult? selectedFile;
  var loadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return ValueListenableBuilder(
      valueListenable: loadingNotifier,
      builder: (_, loading, __) {
        return CustomLoadingOverlay(
          isLoading: loading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primaryColor,
              centerTitle: true,
              leadingWidth: 100,
              title: Text(widget.title),
              leading: const CustomBackButtonWidget(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  AppSize.spaceHeight16,
                  Container(
                    width: AppSize.getDeviceWidth(context),
                    height: 400,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.thirdColor.withOpacity(0.3)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        selectedFile != null
                            ? Image.memory(
                                selectedFile!.files.first.bytes!,
                                width: (280 * 16) / 9,
                                height: 280,
                              )
                            : Icon(
                                Icons.file_copy_outlined,
                                color: AppColor.primaryColor,
                                size: 70,
                              ),
                        selectedFile != null
                            ? const SizedBox()
                            : SizedBox(
                                width: AppSize.getDeviceWidth(context) * 0.6,
                                child: ButtonWidget(
                                  color: AppColor.secondaryColor,
                                  title: "撮影または画像選択する",
                                  onPress: () => onSelectFile(),
                                ),
                              )
                      ],
                    ),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    selectedFile != null ? JapaneseText.afterSelectedFileMessage : JapaneseText.beforeSelectFileMessage,
                    style: kNormalText.copyWith(height: 2),
                  ),
                  AppSize.spaceHeight50,
                  selectedFile == null
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.25,
                              child: ButtonWidget(
                                color: Colors.white,
                                title: "撮り直す",
                                onPress: () => onSelectFile(),
                              ),
                            ),
                            AppSize.spaceWidth16,
                            SizedBox(
                              width: AppSize.getDeviceWidth(context) * 0.25,
                              child: ButtonWidget(
                                color: AppColor.secondaryColor,
                                title: "この写真で確定する",
                                onPress: () async {
                                  if (selectedFile != null) {
                                    try {
                                      loadingNotifier.value = true;
                                      String imageUrl = await fileToUrl(selectedFile!, widget.type);
                                      await UserApiServices().updateUserAField(
                                          uid: authProvider.myUser?.uid ?? "tdZHrwpI0pOiepOIgHrtg6cxWV52", value: imageUrl, field: widget.type);
                                      loadingNotifier.value = false;
                                      //Success uploaded
                                      MessageWidget.show("アップロードに成功しました");
                                    } catch (e) {
                                      loadingNotifier.value = false;
                                      MessageWidget.show("アップロードに失敗しました($e)");
                                    }
                                  } else {
                                    //Please select first first
                                    MessageWidget.show("まず最初に選択してください");
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        );
      },
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
}
