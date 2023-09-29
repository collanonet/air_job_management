import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class _CreateOrEditCompanyPageState extends State<CreateOrEditCompanyPage> {
  TextEditingController companyName = TextEditingController(text: "");
  TextEditingController profileCom = TextEditingController(text: "");
  TextEditingController postalCode = TextEditingController(text: "");
  TextEditingController location = TextEditingController(text: "");
  TextEditingController capital = TextEditingController(text: "");
  TextEditingController publicDate = TextEditingController(text: "");
  TextEditingController homePage = TextEditingController(text: "");
  TextEditingController affiliate = TextEditingController(text: "");
  TextEditingController tel = TextEditingController(text: "");
  TextEditingController tax = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController kanji = TextEditingController(text: "");
  TextEditingController kana = TextEditingController(text: "");
  TextEditingController content = TextEditingController(text: "");
  late CompanyProvider provider;
  List<Map<String, TextEditingController>> managerList = [];
  File? fileImage;
  bool isShow = true;
  bool isLoading = false;
  DateTime dateTime = DateTime.parse("2000-10-10");
  final ImagePicker _picker = ImagePicker();
  Company? company;

  final _formKey = GlobalKey<FormState>();

  onSaveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Company c = Company(
          uid: widget.id,
          email: email.text.trim(),
          affiliate: affiliate.text,
          capital: capital.text,
          companyName: companyName.text,
          companyProfile: provider.imageUrl,
          content: content.text,
          homePage: homePage.text,
          publicDate: publicDate.text,
          location: location.text,
          postalCode: postalCode.text,
          status: company?.status ?? StatusUtils.active,
          tax: tax.text,
          tel: tel.text,
          rePresentative: RePresentative(kana: kana.text, kanji: kanji.text),
          manager: managerList.map((e) => RePresentative(kanji: e["kanji"]?.text.trim(), kana: e["kana"]?.text.trim())).toList());
      String? val;
      if (widget.id != null) {
        val = await CompanyApiServices().updateCompanyInfo(c);
      } else {
        val = await CompanyApiServices().createCompany(c);
      }
      setState(() {
        isLoading = false;
      });
      if (val == ConstValue.success) {
        toastMessageSuccess("${widget.id != null ? "Update" : "Create"} company success", context);
        context.pop();
        context.go(MyRoute.company);
      } else {
        toastMessageError("$val", context);
      }
    }
  }

  @override
  void initState() {
    if (widget.id != null) {
      isLoading = true;
      initialData();
    } else {
      Provider.of<CompanyProvider>(context, listen: false).setImage = "";
      managerList.add({
        "kanji": TextEditingController(text: ""),
        "kana": TextEditingController(text: ""),
      });
    }
    super.initState();
  }

  initialData() async {
    company = await CompanyApiServices().getACompany(widget.id!);
    companyName.text = company!.companyName ?? "";
    profileCom.text = company!.companyProfile ?? "";
    postalCode.text = company!.postalCode ?? "";
    location.text = company!.location ?? "";
    capital.text = company!.capital ?? "";
    publicDate.text = company!.publicDate ?? "";
    homePage.text = company!.homePage ?? "";
    affiliate.text = company!.affiliate ?? "";
    tax.text = company!.tax ?? "";
    tel.text = company!.tel ?? "";
    email.text = company!.email ?? "";
    kanji.text = company!.rePresentative?.kanji ?? "";
    kana.text = company!.rePresentative?.kana ?? "";
    content.text = company!.content ?? "";
    provider.setImage = company!.companyProfile ?? "";
    if (company!.manager != null) {
      for (var manager in company!.manager!) {
        managerList.add({
          "kanji": TextEditingController(text: manager.kanji),
          "kana": TextEditingController(text: manager.kana),
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CompanyProvider>(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
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
                  controller: companyName,
                  hint: '',
                  marginBottom: 5,
                ),
              ],
            )),
        AppSize.spaceHeight16,
        Row(
          children: [
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.postalCode),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: postalCode,
                      isRequired: true,
                      hint: '',
                      marginBottom: 5,
                    ),
                  ],
                )),
            AppSize.spaceWidth16,
            SizedBox(
                width: AppSize.getDeviceWidth(context) * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(JapaneseText.location),
                    AppSize.spaceHeight5,
                    PrimaryTextField(
                      controller: location,
                      isRequired: true,
                      hint: '',
                      marginBottom: 5,
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
                        controller: publicDate,
                        hint: '',
                        readOnly: true,
                        marginBottom: 5,
                        onTap: () async {
                          var date = await showDatePicker(
                              locale: Locale("ja", "JP"),
                              context: context,
                              initialDate: dateTime,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime.now());
                          if (date != null) {
                            dateTime = date;
                            publicDate.text = DateFormat('yyyy-MM-dd').format(dateTime);
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
                        controller: capital,
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
                      "Upload File Here",
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
                    controller: tel,
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
                    controller: tax,
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
                    controller: email,
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
                  controller: homePage,
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
                  controller: affiliate,
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
                          controller: kanji,
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
                          controller: kana,
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
              itemCount: managerList.length,
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
                                controller: managerList[index]["kanji"],
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
                                controller: managerList[index]["kana"],
                                isRequired: true,
                                hint: '',
                                marginBottom: 5,
                              ),
                            ],
                          )),
                      AppSize.spaceWidth16,
                      managerList.length == 1
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      managerList.removeAt(index);
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
                    managerList.add({
                      "kanji": TextEditingController(text: ""),
                      "kana": TextEditingController(text: ""),
                    } as Map<String, TextEditingController>);
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
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
                    controller: content,
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
