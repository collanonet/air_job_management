import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/company.dart';
import '../../providers/company.dart';
import '../../utils/app_color.dart';
import '../../utils/japanese_text.dart';
import '../../widgets/custom_textfield.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late CompanyProvider provider;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    CompanyProvider.getProvider(context, listen: false).initialController();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    provider.onInitDataForDetail(authProvider.myCompany?.uid ?? "");
  }

  @override
  void dispose() {
    // provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = CompanyProvider.getProvider(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      child: Column(
        children: [
          buildManager(),
          AppSize.spaceHeight16,
          Container(
            padding: const EdgeInsets.all(32),
            decoration: boxDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Basic Info
                const TitleWidget(title: "基本情報"),
                AppSize.spaceHeight16,
                // Company Name, Public Date, Profile ...
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name, Public Date
                    buildNamePostalLocationAndPublicDate(),
                    // Profile Picture
                    AppSize.spaceWidth16,
                    buildChooseProfile()
                  ],
                ),
                buildTelFaxAndEmail(),
                buildUrlAndAfficiate(),
                const Divider(),
                buildManagerAndContent(),
                AppSize.spaceHeight16,
                AppSize.spaceHeight30
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildManager() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          TitleWidget(title: "アカウント設定"),
          AppSize.spaceHeight16,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        JapaneseText.nameKanJi,
                        style: kNormalText.copyWith(fontSize: 12),
                      )),
                  AppSize.spaceHeight5,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      hint: "",
                      controller: provider.nameKhanJi,
                      isRequired: false,
                    ),
                  ),
                ],
              ),
              AppSize.spaceWidth32,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        JapaneseText.nameFugigana,
                        style: kNormalText.copyWith(fontSize: 12),
                      )),
                  AppSize.spaceHeight5,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      hint: "",
                      controller: provider.nameFu,
                      isRequired: false,
                    ),
                  ),
                ],
              ),
              AppSize.spaceWidth32,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        JapaneseText.phone + " (半角文字)",
                        style: kNormalText.copyWith(fontSize: 12),
                      )),
                  AppSize.spaceHeight5,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      hint: "",
                      controller: provider.managerPhoneNumber,
                      isRequired: false,
                      isPhoneNumber: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "メールアドレス（ログインID）",
                        style: kNormalText.copyWith(fontSize: 12),
                      )),
                  AppSize.spaceHeight5,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      hint: "",
                      controller: provider.managerEmail,
                      isRequired: false,
                    ),
                  ),
                ],
              ),
              AppSize.spaceWidth32,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "パスワード",
                        style: kNormalText.copyWith(fontSize: 12),
                      )),
                  AppSize.spaceHeight5,
                  SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.2,
                    child: PrimaryTextField(
                      hint: "",
                      controller: provider.managerPassword,
                      isRequired: false,
                      isObsecure: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildNamePostalLocationAndPublicDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.companyName),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.companyName,
                  hint: '',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        Row(
          children: [
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.postalCode),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.postalCode,
                      isRequired: true,
                      hint: '',
                      marginBottom: 5,
                    ),
                  ],
                )),
            AppSize.spaceWidth16,
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.location),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.location,
                      isRequired: true,
                      hint: '',
                      marginBottom: 5,
                    ),
                  ],
                )),
            // AppSize.spaceWidth16,
            // SizedBox(
            //     width: AppSize.getDeviceWidth(context) * 0.15,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(JapaneseText.companyLatLng),
            //         AppSize.spaceHeight5,
            //         PrimaryTextField(
            //           controller: provider.companyLatLng,
            //           isRequired: true,
            //           hint: '',
            //           marginBottom: 5,
            //           validator: (value) => FormValidator.validateLatLang(value),
            //         ),
            //       ],
            //     )),
          ],
        ),
        AppSize.spaceHeight16,
        //Phone & Dob
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.55 + 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(JapaneseText.publicDate),
                      AppSize.spaceHeight5,
                      PrimaryTextField(
                        isRequired: true,
                        controller: provider.publicDate,
                        hint: '',
                        readOnly: true,
                        marginBottom: 5,
                        onTap: () async {
                          var date = await showDatePicker(
                              locale: const Locale("ja", "JP"),
                              context: context,
                              initialDate: provider.dateTime,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime.now());
                          if (date != null) {
                            provider.dateTime = date;
                            provider.publicDate.text = DateFormat('yyyy-MM-dd').format(provider.dateTime);
                          }
                        },
                      ),
                    ],
                  )),
              AppSize.spaceWidth16,
              SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(JapaneseText.capital),
                      AppSize.spaceHeight5,
                      PrimaryTextField(
                        controller: provider.capital,
                        isRequired: true,
                        hint: '',
                        marginBottom: 5,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        AppSize.spaceHeight16,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.55 + 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(JapaneseText.area),
                      AppSize.spaceHeight5,
                      PrimaryTextField(
                        isRequired: false,
                        controller: provider.area,
                        hint: '',
                        marginBottom: 5,
                      ),
                    ],
                  )),
              AppSize.spaceWidth16,
              SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(JapaneseText.industry),
                      AppSize.spaceHeight5,
                      PrimaryTextField(
                        isRequired: false,
                        controller: provider.industry,
                        hint: '',
                        marginBottom: 5,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        AppSize.spaceHeight16,
      ],
    );
  }

  buildChooseProfile() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(JapaneseText.profileCom),
        AppSize.spaceHeight5,
        InkWell(
          onTap: () async {
            await CompanyApiServices().uploadImageToFirebase(provider);
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColor.darkBlueColor),
              ),
              alignment: Alignment.center,
              child: provider.imageUrl.isEmpty
                  ? Text(
                      "ここにファイルをアップロード",
                      style: normalTextStyle,
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Image.network(
                            provider.imageUrl,
                            fit: BoxFit.cover,
                            width: 230,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                provider.onChangeImageUrl("");
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              )),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    ));
  }

  buildTelFaxAndEmail() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: AppSize.getDeviceWidth(context) * 0.55 + 16,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("TEL"),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.tel,
                    hint: '',
                    isRequired: true,
                  ),
                ],
              ),
            ),
            AppSize.spaceWidth16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("FAX"),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.tax,
                    hint: '',
                    isRequired: false,
                  ),
                ],
              ),
            ),
            AppSize.spaceWidth16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(JapaneseText.email),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.email,
                    hint: '',
                    isRequired: true,
                    isEmail: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildUrlAndAfficiate() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: AppSize.getDeviceWidth(context) * 0.55 + 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.homePage),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.homePage,
                  hint: '',
                  isRequired: false,
                ),
              ],
            ),
            AppSize.spaceHeight5,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(JapaneseText.affiliate),
                AppSize.spaceHeight5,
                PrimaryTextField(
                  controller: provider.affiliate,
                  hint: '',
                  isRequired: false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildManagerAndContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(JapaneseText.rePresentative),
          AppSize.spaceHeight16,
          SizedBox(
            width: AppSize.getDeviceWidth(context) * 0.55 + 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(JapaneseText.nameKanJi),
                        AppSize.spaceHeight5,
                        PrimaryTextField(
                          isRequired: true,
                          controller: provider.kanji,
                          hint: '',
                          marginBottom: 5,
                        ),
                      ],
                    )),
                AppSize.spaceWidth16,
                SizedBox(
                    width: AppSize.getDeviceWidth(context) * 0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(JapaneseText.nameFugigana),
                        AppSize.spaceHeight5,
                        PrimaryTextField(
                          controller: provider.kana,
                          isRequired: true,
                          hint: '',
                          marginBottom: 5,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          AppSize.spaceHeight16,
          Text(JapaneseText.manager),
          AppSize.spaceHeight16,
          ListView.builder(
              shrinkWrap: true,
              itemCount: provider.managerList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: AppSize.getDeviceWidth(context) * 0.55 + 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: AppSize.getDeviceWidth(context) * 0.22,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(JapaneseText.nameKanJi),
                              AppSize.spaceHeight5,
                              PrimaryTextField(
                                isRequired: true,
                                controller: provider.managerList[index]["kanji"],
                                hint: '',
                                marginBottom: 5,
                              ),
                            ],
                          )),
                      AppSize.spaceWidth16,
                      SizedBox(
                          width: AppSize.getDeviceWidth(context) * 0.22,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(JapaneseText.nameFugigana),
                              AppSize.spaceHeight5,
                              PrimaryTextField(
                                controller: provider.managerList[index]["kana"],
                                isRequired: true,
                                hint: '',
                                marginBottom: 5,
                              ),
                            ],
                          )),
                      AppSize.spaceWidth16,
                      provider.managerList.length == 1
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      provider.managerList.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  )),
                            )
                    ],
                  ),
                );
              }),
          SizedBox(
            width: 100,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    provider.managerList.add({
                      "kanji": TextEditingController(text: ""),
                      "kana": TextEditingController(text: ""),
                    });
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: AppColor.primaryColor,
                    ),
                    AppSize.spaceWidth5,
                    Text(
                      JapaneseText.addMore,
                      style: kNormalText.copyWith(fontSize: 15, color: AppColor.primaryColor),
                    ),
                  ],
                )),
          ),
          AppSize.spaceHeight16,
          const Divider(),
          AppSize.spaceHeight16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColor.primaryColor,
              ),
              AppSize.spaceWidth8,
              Text(
                JapaneseText.content,
                style: titleStyle,
              ),
            ],
          ),
          AppSize.spaceHeight16,
          SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(JapaneseText.content),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.content,
                    hint: '',
                    marginBottom: 5,
                    maxLine: 5,
                  ),
                ],
              )),
          AppSize.spaceHeight16,
          SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(JapaneseText.remark),
                  AppSize.spaceHeight5,
                  PrimaryTextField(
                    controller: provider.remark,
                    hint: '',
                    marginBottom: 5,
                    maxLine: 5,
                    isRequired: false,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
