import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';

class UploadPassportPage extends StatefulWidget {
  const UploadPassportPage({super.key});

  @override
  State<UploadPassportPage> createState() => _UploadPassportPageState();
}

class _UploadPassportPageState extends State<UploadPassportPage> {
  //Step 4
  FilePickerResult? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: Text(JapaneseText.passport),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AppSize.spaceHeight16,
            Container(
              width: AppSize.getDeviceWidth(context),
              height: 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(width: 2, color: AppColor.primaryColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  selectedFile != null
                      ? Text(selectedFile!.files.first.name)
                      : Icon(
                          Icons.file_copy_outlined,
                          color: AppColor.primaryColor,
                          size: 70,
                        ),
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.6,
                    child: ButtonWidget(
                      color: AppColor.secondaryColor,
                      title: "撮影または画像選択する",
                      onPress: () async {
                        var file = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: [
                              "pdf",
                              "jpg",
                              "png",
                              "jpeg",
                              "db"
                            ]);
                        if (file != null) {
                          setState(() {
                            selectedFile = file;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            AppSize.spaceHeight16,
            Text(
              "パスポートの名前、生年月日、性別が記載されているページの写真をアップロードしてください。 \n必ずパスポート原本全体の写真を撮影してください。",
              style: kNormalText.copyWith(height: 2),
            ),
            AppSize.spaceHeight50,
            SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.6,
              child: ButtonWidget(
                color: AppColor.secondaryColor,
                title: "写真をアップロードする",
                onPress: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
