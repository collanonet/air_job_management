import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:air_job_management/worker_page/viewprofile/identification_doc/upload_passport.dart';
import 'package:air_job_management/worker_page/viewprofile/identification_doc/widget/iden_card.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_back_button.dart';

class IdentificationMenuPage extends StatefulWidget {
  const IdentificationMenuPage({super.key});

  @override
  State<IdentificationMenuPage> createState() => _IdentificationMenuPageState();
}

class _IdentificationMenuPageState extends State<IdentificationMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('本人確認'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Column(
        children: [
          AppSize.spaceHeight16,
          IdentificationMenuCard(
              title: JapaneseText.passport,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      title: JapaneseText.passport, type: "passport_url")),
              subTitle: "所持人記入欄があるもの"),
          IdentificationMenuCard(
              title: JapaneseText.driverLicenseIdentification,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      title: JapaneseText.driverLicenseIdentification,
                      type: "driver_license_url")),
              subTitle: ""),
          IdentificationMenuCard(
              title: JapaneseText.myNumberCard,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      title: JapaneseText.myNumberCard,
                      type: "number_card_url")),
              subTitle: ""),
          IdentificationMenuCard(
              title: JapaneseText.basicResidentRegisterCard,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      title: JapaneseText.basicResidentRegisterCard,
                      type: "basic_resident_register_url")),
              subTitle: "顔写真付きのもの"),
          IdentificationMenuCard(
              title: JapaneseText.residentRecord,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      title: JapaneseText.residentRecord,
                      type: "resident_record_url")),
              subTitle: "発行から6ヶ月以内"),
        ],
      ),
    );
  }
}
