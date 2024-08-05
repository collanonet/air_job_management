import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../const/const.dart';
import '../../../utils/app_color.dart';
import '../../../utils/japanese_text.dart';
import '../../../utils/style.dart';
import '../../../utils/toast_message_util.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreateOrEditBranchWidget extends StatefulWidget {
  final Branch? branch;
  final int? index;
  const CreateOrEditBranchWidget(
      {super.key, required this.branch, required this.index});

  @override
  State<CreateOrEditBranchWidget> createState() =>
      _CreateOrEditBranchWidgetState();
}

class _CreateOrEditBranchWidgetState extends State<CreateOrEditBranchWidget> {
  TextEditingController name = TextEditingController(text: "");
  TextEditingController postalCode = TextEditingController(text: "");
  TextEditingController location = TextEditingController(text: "");
  TextEditingController contactNumber = TextEditingController(text: "");
  TextEditingController latlng = TextEditingController(text: "");
  DateTime date = DateTime.now();
  late AuthProvider authProvider;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    postalCode.dispose();
    location.dispose();
    contactNumber.dispose();
    latlng.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.branch != null) {
      name.text = widget.branch?.name ?? "";
      postalCode.text = widget.branch?.postalCode ?? "";
      location.text = widget.branch?.location ?? "";
      contactNumber.text = widget.branch?.contactNumber ?? "";
      if (widget.branch?.lat != null && widget.branch?.lng != null) {
        latlng.text = "${widget.branch?.lat}, ${widget.branch?.lng}";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: CustomLoadingOverlay(
        isLoading: isLoading,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            width: AppSize.getDeviceHeight(context) * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TitleWidget(
                    title:
                        widget.branch != null ? "支店情報を更新しました" : "新しいブランチを作成する"),
                AppSize.spaceHeight16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(JapaneseText.name,
                            style: kNormalText.copyWith(fontSize: 12))),
                    AppSize.spaceHeight5,
                    SizedBox(
                      width: AppSize.getDeviceHeight(context) * 0.8,
                      child: PrimaryTextField(
                        hint: "",
                        controller: name,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(JapaneseText.postalCode,
                                style: kNormalText.copyWith(fontSize: 12))),
                        AppSize.spaceHeight5,
                        SizedBox(
                          width: 150,
                          child: PrimaryTextField(
                            hint: "",
                            controller: postalCode,
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    AppSize.spaceWidth16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(JapaneseText.location,
                                style: kNormalText.copyWith(fontSize: 12))),
                        AppSize.spaceHeight5,
                        SizedBox(
                          width: AppSize.getDeviceHeight(context) * 0.8 - 166,
                          child: PrimaryTextField(
                            hint: "",
                            controller: location,
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("TEL",
                            style: kNormalText.copyWith(fontSize: 12))),
                    AppSize.spaceHeight5,
                    SizedBox(
                      width: 200,
                      child: PrimaryTextField(
                        hint: "",
                        controller: contactNumber,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("L緯度と経度 (例: 34.xxxxxxxx, 135.xxxxxxxx)",
                        style: kNormalText.copyWith(fontSize: 12)),
                    AppSize.spaceHeight5,
                    SizedBox(
                      width: AppSize.getDeviceWidth(context) * 0.8,
                      child: PrimaryTextField(
                        hint: "",
                        controller: latlng,
                        isRequired: false,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 200,
                        child: ButtonWidget(
                          radius: 25,
                          color: AppColor.whiteColor,
                          title: "キャンセル",
                          onPress: () {
                            Navigator.pop(context);
                          },
                        )),
                    AppSize.spaceWidth16,
                    SizedBox(
                      width: 200,
                      child: ButtonWidget(
                          radius: 25,
                          title: "保存",
                          color: AppColor.primaryColor,
                          onPress: () => onSaveData()),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  onSaveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool isInvalid =
            (latlng.text.isNotEmpty && !latlng.text.contains(", "));
        if (isInvalid) {
          toastMessageError(
              "無効な緯度と経度 (形式は \"34.xxxxxxxx、135.xxxxxxxx\" である必要があります)",
              context);
        } else {
          setState(() {
            isLoading = true;
          });
          String companyId = authProvider.myCompany?.uid ?? "";
          List<Branch> branchList = authProvider.myCompany?.branchList ?? [];
          var branch = Branch(
              contactNumber: contactNumber.text,
              location: location.text,
              postalCode: postalCode.text,
              createdAt: date,
              name: name.text,
              lat: latlng.text.isEmpty ? null : latlng.text.split(", ")[0],
              lng: latlng.text.isEmpty ? null : latlng.text.split(", ")[1],
              id: DateTime.now().millisecondsSinceEpoch.toString());
          if (widget.branch != null) {
            branch.id = widget.branch?.id ??
                widget.branch!.createdAt!.millisecondsSinceEpoch.toString();
            branchList[widget.index!] = branch;
          } else {
            branchList.add(branch);
          }
          String? isSuccess = await CompanyApiServices()
              .updateCompanyBranchInfo(companyId, branchList);
          setState(() {
            isLoading = false;
          });
          if (isSuccess == ConstValue.success) {
            Company? company =
                await CompanyApiServices().getACompany(companyId);
            authProvider.onChangeCompany(company,
                branch: widget.branch != null ? branch : null);
            toastMessageSuccess(
                widget.branch != null
                    ? JapaneseText.successUpdate
                    : JapaneseText.successCreate,
                context);
            Navigator.pop(context, true);
          } else {
            toastMessageSuccess(
                widget.branch != null
                    ? JapaneseText.failUpdate
                    : JapaneseText.failCreate,
                context);
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        toastMessageSuccess(
            widget.branch != null
                ? JapaneseText.failUpdate
                : JapaneseText.failCreate,
            context);
      }
    }
  }
}
