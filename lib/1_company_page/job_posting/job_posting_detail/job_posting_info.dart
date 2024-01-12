import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/job_posting/create_or_edit_job_for_japanese.dart';
import '../../../widgets/custom_dropdown_string.dart';
import '../../../widgets/custom_textfield.dart';

class JobPostingInformationPageForCompany extends StatefulWidget {
  const JobPostingInformationPageForCompany({super.key});

  @override
  State<JobPostingInformationPageForCompany> createState() => _JobPostingInformationPageForCompanyState();
}

class _JobPostingInformationPageForCompanyState extends State<JobPostingInformationPageForCompany> {
  late JobPostingForCompanyProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.spaceHeight30,
              titleWidget(),
              AppSize.spaceHeight30,
              Divider(
                color: AppColor.thirdColor,
              ),
              AppSize.spaceHeight30,
              buildApplicationRequirement(),
            ],
          ),
        ),
      ),
    );
  }

  titleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: JapaneseText.title),
        AppSize.spaceHeight16,
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              JapaneseText.jobTitle,
              style: kNormalText.copyWith(fontSize: 12),
            )),
        AppSize.spaceHeight5,
        PrimaryTextField(
          hint: "",
          controller: provider.title,
          isRequired: true,
        ),
        AppSize.spaceHeight8,
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.profileCom, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        buildChooseJobProfile(),
      ],
    );
  }

  ScrollController scrollController = ScrollController();

  buildChooseJobProfile() {
    return SizedBox(
      height: 165,
      child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: ListView.builder(
            controller: scrollController,
            itemCount: provider.jobPosterProfile.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemBuilder: (context, index) {
              FilePickerResult? file = provider.jobPosterProfile[index];
              if (file != null) {
                return Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Stack(
                    children: [
                      Container(
                        width: 320,
                        height: 162,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: AppColor.thirdColor),
                            image: DecorationImage(image: MemoryImage(file.files.first.bytes!), fit: BoxFit.cover)),
                      ),
                      Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                              onPressed: () => provider.onRemoveFile(index),
                              icon: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColor.primaryColor),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ))))
                    ],
                  ),
                );
              } else {
                return InkWell(
                  onTap: () => onSelectFile(),
                  child: Container(
                    width: 320,
                    height: 162,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: AppColor.thirdColor)),
                    child: Center(
                      child: IconButton(
                          onPressed: () => onSelectFile(),
                          icon: Icon(
                            Icons.add_circle,
                            color: AppColor.primaryColor,
                            size: 24,
                          )),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  onSelectFile() async {
    var file = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ["jpg", "png", "jpeg"]);
    if (file != null) {
      provider.onAddNewFile(file);
    }
  }

  buildApplicationRequirement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: JapaneseText.applicationRequirement),
        AppSize.spaceHeight16,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.occupationMajor, style: kNormalText.copyWith(fontSize: 12))),
                AppSize.spaceHeight5,
                CustomDropDownWidget(
                  radius: 5,
                  list: provider.occupationType,
                  onChange: (e) => provider.onChangeOccupationType(e),
                  width: 320,
                  selectItem: provider.selectedOccupationType,
                )
              ],
            ),
            AppSize.spaceWidth16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.occupationMajor, style: kNormalText.copyWith(fontSize: 12))),
                AppSize.spaceHeight5,
                CustomDropDownWidget(
                  radius: 5,
                  list: provider.specificOccupationList,
                  onChange: (e) => provider.onChangeMajorOccupation(e),
                  width: 320,
                  selectItem: provider.selectedSpecificOccupation,
                )
              ],
            )
          ],
        ),
        AppSize.spaceHeight8,
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.treatmentAndExp, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 170,
                title: JapaneseText.expWelcome,
                val: provider.expWelcome,
                onChange: (v) {
                  setState(() {
                    provider.expWelcome = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.mealsAvailable,
                val: provider.mealsAvailable,
                onChange: (v) {
                  setState(() {
                    provider.mealsAvailable = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.freeClothing,
                val: provider.freeClothing,
                onChange: (v) {
                  setState(() {
                    provider.freeClothing = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.freeHairStyleAndColor,
                val: provider.freeHairStyleAndColor,
                onChange: (v) {
                  setState(() {
                    provider.freeHairStyleAndColor = v;
                  });
                }),
          ],
        ),
        AppSize.spaceHeight5,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkBoxTile(
                size: 170,
                title: JapaneseText.transportationProvided,
                val: provider.transportationProvided,
                onChange: (v) {
                  setState(() {
                    provider.transportationProvided = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.motorCycleCarCommutingPossible,
                val: provider.motorCycleCarCommutingPossible,
                onChange: (v) {
                  setState(() {
                    provider.motorCycleCarCommutingPossible = v;
                  });
                }),
            checkBoxTile(
                size: 200,
                title: JapaneseText.bicycleCommutingPossible,
                val: provider.bicycleCommutingPossible,
                onChange: (v) {
                  setState(() {
                    provider.bicycleCommutingPossible = v;
                  });
                }),
          ],
        ),
      ],
    );
  }
}
