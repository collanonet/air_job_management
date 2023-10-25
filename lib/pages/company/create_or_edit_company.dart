import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/const/status.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/company.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../const/const.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/custom_button.dart';

class CreateOrEditCompanyPage extends StatefulWidget {
  final String? id;
  const CreateOrEditCompanyPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CreateOrEditCompanyPage> createState() => _CreateOrEditCompanyPageState();
}

class _CreateOrEditCompanyPageState extends State<CreateOrEditCompanyPage> with AfterBuildMixin {
  late CompanyProvider provider;
  final _formKey = GlobalKey<FormState>();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      provider.onChangeLoadingForDetail(true);
      Company c = Company(
          area: provider.area.text,
          industry: provider.industry.text,
          uid: widget.id,
          email: provider.email.text.trim(),
          affiliate: provider.affiliate.text,
          capital: provider.capital.text,
          companyName: provider.companyName.text,
          companyProfile: provider.imageUrl,
          content: provider.content.text,
          homePage: provider.homePage.text,
          publicDate: provider.publicDate.text,
          location: provider.location.text,
          postalCode: provider.postalCode.text,
          status: provider.company?.status ?? StatusUtils.active,
          tax: provider.tax.text,
          tel: provider.tel.text,
          companyLatLng: provider.companyLatLng.text,
          rePresentative: RePresentative(kana: provider.kana.text, kanji: provider.kanji.text),
          manager: provider.managerList.map((e) => RePresentative(kanji: e["kanji"]?.text.trim(), kana: e["kana"]?.text.trim())).toList());
      String? val;
      if (widget.id != null) {
        val = await CompanyApiServices().updateCompanyInfo(c);
      } else {
        val = await CompanyApiServices().createCompany(c);
      }
      provider.onChangeLoadingForDetail(false);
      if (val == ConstValue.success) {
        toastMessageSuccess(widget.id != null ? JapaneseText.successUpdate : JapaneseText.successCreate, context);
        await provider.getAllCompany(isNotify: true);
        context.pop();
        context.go(MyRoute.company);
      } else {
        toastMessageError("$val", context);
      }
    }
  }

  @override
  void initState() {
    CompanyProvider.getProvider(context, listen: false).initialController();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    provider.onInitDataForDetail(widget.id);
  }

  @override
  void dispose() {
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = CompanyProvider.getProvider(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: provider.isLoadingForDetail,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              titleWidget(),
              AppSize.spaceHeight16,
              Container(
                padding: const EdgeInsets.all(12),
                width: AppSize.getDeviceWidth(context),
                height: AppSize.getDeviceHeight(context) - 110,
                decoration: boxDecoration,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Basic Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColor.primaryColor,
                          ),
                          AppSize.spaceWidth8,
                          Text(
                            JapaneseText.applicantSearch,
                            style: titleStyle,
                          ),
                        ],
                      ),
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
                      SizedBox(
                        width: AppSize.getDeviceWidth(context) * 0.1,
                        child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSaveUserData()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildNamePostalLocationAndPublicDate() {
    return Column(
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
            AppSize.spaceWidth16,
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.companyLatLng),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: provider.companyLatLng,
                      isRequired: true,
                      hint: '',
                      marginBottom: 5,
                      validator: (value) => FormValidator.validateLatLang(value),
                    ),
                  ],
                )),
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
                    const Icon(Icons.add),
                    AppSize.spaceWidth5,
                    Text(JapaneseText.addMore),
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
        ],
      ),
    );
  }

  clearAllText() {}

  titleWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 60,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            JapaneseText.applicantSearch,
            style: titleStyle,
          ),
          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
