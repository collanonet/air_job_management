import 'package:air_job_management/api/company.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:flutter/material.dart';

import '../../../models/company.dart';
import '../../../utils/toast_message_util.dart';

class DeleteCompanyDialogWidget extends StatefulWidget {
  final List<Company> companyList;
  final Function onRefresh;
  const DeleteCompanyDialogWidget({Key? key, required this.companyList, required this.onRefresh}) : super(key: key);

  @override
  State<DeleteCompanyDialogWidget> createState() => _DeleteCompanyDialogWidgetState();
}

class _DeleteCompanyDialogWidgetState extends State<DeleteCompanyDialogWidget> {
  List<Company> selectedCompany = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Text(
            JapaneseText.delete,
            style: titleStyle,
          ),
        ),
        content: Container(
          color: Colors.white,
          height: AppSize.getDeviceHeight(context) * 0.5,
          width: AppSize.getDeviceWidth(context) * 0.5,
          child: ListView.builder(
              itemCount: widget.companyList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Company company = widget.companyList[index];
                return CheckboxListTile(
                  value: selectedCompany.contains(company),
                  onChanged: (v) {
                    setState(() {
                      if (selectedCompany.contains(company)) {
                        selectedCompany.removeAt(index);
                      } else {
                        selectedCompany.add(company);
                      }
                    });
                  },
                  title: Text(
                    "${company.companyName}",
                    style: normalTextStyle,
                  ),
                );
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  child: ButtonWidget(title: JapaneseText.cancel, color: Colors.redAccent, onPress: () => Navigator.pop(context)),
                ),
                AppSize.spaceWidth16,
                SizedBox(width: 140, child: ButtonWidget(title: JapaneseText.save, color: AppColor.primaryColor, onPress: () => onSave())),
              ],
            ),
          )
        ],
      ),
    );
  }

  onSave() async {
    if (selectedCompany.isEmpty) {
      toastMessageError("少なくとも 1 つの会社を選択してください", context);
    } else {
      setState(() {
        isLoading = true;
      });
      await Future.wait([...selectedCompany.map((e) => CompanyApiServices().updateStatusCompany(e))]);
      setState(() {
        isLoading = false;
      });
      toastMessageSuccess(JapaneseText.successUpdate, context);
      Navigator.pop(context);
      widget.onRefresh();
    }
  }
}
