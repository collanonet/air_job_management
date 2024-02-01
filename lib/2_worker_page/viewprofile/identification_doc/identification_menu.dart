import 'package:air_job_management/2_worker_page/viewprofile/identification_doc/upload_passport.dart';
import 'package:air_job_management/2_worker_page/viewprofile/identification_doc/widget/iden_card.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../api/user_api.dart';
import '../../../providers/auth.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/custom_back_button.dart';

class IdentificationMenuPage extends StatefulWidget {
  const IdentificationMenuPage({super.key});

  @override
  State<IdentificationMenuPage> createState() => _IdentificationMenuPageState();
}

class _IdentificationMenuPageState extends State<IdentificationMenuPage> with AfterBuildMixin {
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
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
                  context, UploadFilePage(url: authProvider.myUser?.passport_url ?? "", title: JapaneseText.passport, type: "passport_url")),
              subTitle: "所持人記入欄があるもの"),
          IdentificationMenuCard(
              title: JapaneseText.driverLicenseIdentification,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      url: authProvider.myUser?.driver_license_url ?? "",
                      title: JapaneseText.driverLicenseIdentification,
                      type: "driver_license_url")),
              subTitle: ""),
          IdentificationMenuCard(
              title: JapaneseText.myNumberCard,
              onTap: () => MyPageRoute.goTo(context,
                  UploadFilePage(url: authProvider.myUser?.number_card_url ?? "", title: JapaneseText.myNumberCard, type: "number_card_url")),
              subTitle: ""),
          IdentificationMenuCard(
              title: JapaneseText.basicResidentRegisterCard,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      url: authProvider.myUser?.basic_resident_register_url ?? "",
                      title: JapaneseText.basicResidentRegisterCard,
                      type: "basic_resident_register_url")),
              subTitle: "顔写真付きのもの"),
          IdentificationMenuCard(
              title: JapaneseText.residentRecord,
              onTap: () => MyPageRoute.goTo(
                  context,
                  UploadFilePage(
                      url: authProvider.myUser?.resident_record_url ?? "", title: JapaneseText.residentRecord, type: "resident_record_url")),
              subTitle: "発行から6ヶ月以内"),
        ],
      ),
    );
  }

  @override
  void afterBuild(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && authProvider.myUser == null) {
      var myUser = await UserApiServices().getProfileUser(user.uid);
      setState(() {
        authProvider.myUser = myUser;
      });
    }
  }
}
