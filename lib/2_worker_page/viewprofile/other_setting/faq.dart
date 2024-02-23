import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_back_button.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('よくあるご質問'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
            width: AppSize.getDeviceWidth(context),
            height: AppSize.getDeviceHeight(context),
            decoration: boxDecoration,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: Text('よくある質問です', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "よくある質問です よくある質問です よくある質問です",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('このアプリは無料ですか', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "はい、このアプリも無料で、サービス自体も無料でお使いいただけます。安心してご利用ください。",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('よくある質問です', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "よくある質問です よくある質問です よくある質問です",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('このアプリは無料ですか', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "はい、このアプリも無料で、サービス自体も無料でお使いいただけます。安心してご利用ください。",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('よくある質問です', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "よくある質問です よくある質問です よくある質問です",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('このアプリは無料ですか', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "はい、このアプリも無料で、サービス自体も無料でお使いいただけます。安心してご利用ください。",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('よくある質問です', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "よくある質問です よくある質問です よくある質問です",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('このアプリは無料ですか', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "はい、このアプリも無料で、サービス自体も無料でお使いいただけます。安心してご利用ください。",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('よくある質問です', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "よくある質問です よくある質問です よくある質問です",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                  ExpansionTile(
                    title: Text('このアプリは無料ですか', style: kNormalText.copyWith(fontFamily: "Medium")),
                    collapsedIconColor: AppColor.primaryColor,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 16),
                          child: Text(
                            "はい、このアプリも無料で、サービス自体も無料でお使いいただけます。安心してご利用ください。",
                            style: kNormalText,
                          ),
                        ),
                      )
                    ],
                  ),
                  AppSize.spaceHeight8,
                ],
              ),
            )),
      ),
    );
  }
}
