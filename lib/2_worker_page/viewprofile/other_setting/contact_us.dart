import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_textfield.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('お問い合わせ'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
            width: AppSize.getDeviceWidth(context),
            decoration: boxDecoration,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "名前（漢字）",
                    style: kNormalText.copyWith(fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "鈴木　太郎",
                    style: kTitleText.copyWith(fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    "名前（ふりがな）",
                    style: kNormalText.copyWith(fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "すずき　たろう",
                    style: kTitleText.copyWith(fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    "電話番号",
                    style: kNormalText.copyWith(fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "090−1234−5678",
                    style: kTitleText.copyWith(fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    "メール",
                    style: kNormalText.copyWith(fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight5,
                  Text(
                    "sample@sample.com",
                    style: kTitleText.copyWith(fontFamily: "Normal"),
                  ),
                  AppSize.spaceHeight16,
                  Text(
                    "お問い合わせ内容",
                    style: kNormalText.copyWith(fontFamily: "Medium"),
                  ),
                  AppSize.spaceHeight8,
                  SizedBox(
                      width: AppSize.getDeviceWidth(context),
                      child: const PrimaryTextField(
                        controller: null,
                        hint: 'お問い合わせ内容を入力ください',
                        maxLine: 5,
                        isRequired: false,
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
