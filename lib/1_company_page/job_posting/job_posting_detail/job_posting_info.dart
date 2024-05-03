import 'dart:async';

import 'package:air_job_management/providers/company/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../../pages/job_posting/create_or_edit_job_for_japanese.dart';
import '../../../widgets/custom_dropdown_string.dart';
import '../../../widgets/custom_textfield.dart';

class JobPostingInformationPageForCompany extends StatefulWidget {
  final bool isView;
  const JobPostingInformationPageForCompany({super.key, this.isView = false});

  @override
  State<JobPostingInformationPageForCompany> createState() => _JobPostingInformationPageForCompanyState();
}

class _JobPostingInformationPageForCompanyState extends State<JobPostingInformationPageForCompany> with AfterBuildMixin {
  late JobPostingForCompanyProvider provider;
  ScrollController scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobPostingForCompanyProvider>(context);
    return Expanded(
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: boxDecorationNoTopRadius,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController2,
          child: SingleChildScrollView(
            primary: false,
            controller: scrollController2,
            child: AbsorbPointer(
              absorbing: widget.isView,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.spaceHeight16,
                  titleWidget(),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  buildApplicationRequirement(),
                  AppSize.spaceHeight20,
                  Divider(
                    color: AppColor.thirdColor.withOpacity(0.3),
                  ),
                  AppSize.spaceHeight20,
                  buildWorkLocation(),
                  AppSize.spaceHeight20,
                  AppSize.spaceHeight50,
                ],
              ),
            ),
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
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.6,
          child: PrimaryTextField(
            hint: "",
            controller: provider.title,
            isRequired: true,
          ),
        ),
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
              dynamic file = provider.jobPosterProfile[index];
              if (file != null) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Stack(
                    children: [
                      file.toString().contains("https")
                          ? Container(
                              width: 320,
                              height: 162,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1, color: AppColor.thirdColor),
                              ),
                              child: Image.network(file.toString(), fit: BoxFit.cover),
                            )
                          : Container(
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
                                  child: const Icon(
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
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.occupationMajor, style: kNormalText.copyWith(fontSize: 12))),
            //     AppSize.spaceHeight5,
            //     CustomDropDownWidget(
            //       radius: 5,
            //       list: provider.occupationType,
            //       onChange: (e) => provider.onChangeOccupationType(e),
            //       width: 320,
            //       selectItem: provider.selectedOccupationType,
            //     )
            //   ],
            // ),
            // AppSize.spaceWidth16,
            ///occupation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerLeft, child: Text("職種", style: kNormalText.copyWith(fontSize: 12))),
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
                size: 250,
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
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.jobDescription, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.6,
          child: PrimaryTextField(
            hint: "",
            controller: provider.jobDescription,
            isRequired: true,
            maxLine: 12,
            textInputAction: TextInputAction.newline,
            textInputType: TextInputType.multiline,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.notes, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.6,
          child: PrimaryTextField(
            hint: "",
            controller: provider.notes,
            isRequired: true,
            maxLine: 8,
            textInputAction: TextInputAction.newline,
            textInputType: TextInputType.multiline,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.belongings, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.6,
          child: PrimaryTextField(
            hint: "",
            controller: provider.belongings,
            isRequired: true,
            maxLine: 8,
            textInputAction: TextInputAction.newline,
            textInputType: TextInputType.multiline,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.conditionsForWork, style: kNormalText.copyWith(fontSize: 12))),
        AppSize.spaceHeight5,
        SizedBox(
          width: AppSize.getDeviceWidth(context) * 0.6,
          child: PrimaryTextField(
            hint: "",
            controller: provider.conditionForWork,
            isRequired: true,
            maxLine: 8,
            textInputAction: TextInputAction.newline,
            textInputType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }

  buildWorkLocation() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TitleWidget(title: JapaneseText.workLocation),
      AppSize.spaceHeight16,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.postalCode, style: kNormalText.copyWith(fontSize: 12))),
              AppSize.spaceHeight5,
              SizedBox(
                width: 150,
                child: PrimaryTextField(
                  hint: "",
                  controller: provider.postalCode,
                  isRequired: true,
                ),
              ),
            ],
          ),
          AppSize.spaceWidth16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.prefectureLocation, style: kNormalText.copyWith(fontSize: 12))),
              AppSize.spaceHeight5,
              CustomDropDownWidget(
                radius: 5,
                list: provider.locationList,
                onChange: (e) => provider.onChangeLocation(e),
                width: 150,
                selectItem: provider.selectedLocation,
              )
            ],
          ),
        ],
      ),
      Align(alignment: Alignment.centerLeft, child: Text("市区町村・番地", style: kNormalText.copyWith(fontSize: 12))),
      AppSize.spaceHeight5,
      SizedBox(
        width: AppSize.getDeviceWidth(context) * 0.4,
        child: PrimaryTextField(
          hint: "",
          controller: provider.street,
          isRequired: true,
        ),
      ),
      Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.buildingName, style: kNormalText.copyWith(fontSize: 12))),
      AppSize.spaceHeight5,
      SizedBox(
        width: AppSize.getDeviceWidth(context) * 0.4,
        child: PrimaryTextField(
          hint: "",
          controller: provider.building,
          isRequired: true,
        ),
      ),
      Align(alignment: Alignment.centerLeft, child: Text(JapaneseText.accessAddress, style: kNormalText.copyWith(fontSize: 12))),
      AppSize.spaceHeight5,
      SizedBox(
        width: AppSize.getDeviceWidth(context) * 0.4,
        child: PrimaryTextField(
          hint: "",
          controller: provider.accessAddress,
          isRequired: true,
        ),
      ),
      // Align(
      //     alignment: Alignment.centerLeft,
      //     child: Text("Latitude and Longitude (Ex: 34.xxxxxxxx, 135.xxxxxxxx)", style: kNormalText.copyWith(fontSize: 12))),
      // AppSize.spaceHeight5,
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      // SizedBox(
      //   width: AppSize.getDeviceWidth(context) * 0.4,
      //   child: PrimaryTextField(
      //     hint: "",
      //     controller: provider.latLong,
      //     isRequired: true,
      //     onChange: (v) {
      //       onChangeCamera(v);
      //     },
      //   ),
      // ),
      // AppSize.spaceWidth32,
      //     ButtonWidget(
      //       title: "地図上で選択",
      //       onPress: () {
      //         showDialog(
      //             context: context,
      //             builder: (_) {
      //               return AlertDialog(
      //                 content: buildMap(true),
      //                 actions: [
      //                   Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      //                       SizedBox(
      //                           width: 200,
      //                           child: ButtonWidget(
      //                             radius: 25,
      //                             color: AppColor.whiteColor,
      //                             title: "キャンセル",
      //                             onPress: () => Navigator.pop(context),
      //                           )),
      //                       AppSize.spaceWidth16,
      //                       SizedBox(
      //                           width: 200,
      //                           child: ButtonWidget(
      //                               radius: 25,
      //                               title: "保存",
      //                               color: AppColor.primaryColor,
      //                               onPress: () {
      //                                 Navigator.pop(_);
      //                                 provider.latLong.text = selectedLatLng;
      //                                 onChangeCamera(provider.latLong.text);
      //                               })),
      //                     ]),
      //                   )
      //                 ],
      //               );
      //             });
      //       },
      //       height: 49,
      //     )
      //   ],
      // ),
      AppSize.spaceHeight8,
      buildMap(false),
      AppSize.spaceHeight16,
      Center(
        child: ButtonWidget(
          title: "地図上で選択",
          onPress: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: buildMap(true),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          SizedBox(
                              width: 200,
                              child: ButtonWidget(
                                radius: 25,
                                color: AppColor.whiteColor,
                                title: "キャンセル",
                                onPress: () => Navigator.pop(context),
                              )),
                          AppSize.spaceWidth16,
                          SizedBox(
                              width: 200,
                              child: ButtonWidget(
                                  radius: 25,
                                  title: "保存",
                                  color: AppColor.primaryColor,
                                  onPress: () {
                                    Navigator.pop(_);
                                    provider.latLong.text = selectedLatLng;
                                    onChangeCamera(provider.latLong.text);
                                  })),
                        ]),
                      )
                    ],
                  );
                });
          },
          height: 49,
        ),
      )
    ]);
  }

  String selectedLatLng = "";

  onChangeCamera(String v) async {
    if (v.toString().contains(", ")) {
      setState(() {
        scanScroll = true;
      });
      final GoogleMapController controller = await _controller1.future;
      LatLng latLng = LatLng(double.parse(v.split(", ")[0]), double.parse(v.split(", ")[1]));
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
      setState(() {
        scanScroll = false;
      });
    }
  }

  // late GoogleMapController mapController;
  // late GoogleMapController mapController2;
  final Completer<GoogleMapController> _controller1 = Completer<GoogleMapController>();
  final Completer<GoogleMapController> _controller2 = Completer<GoogleMapController>();
  bool scanScroll = false;
  buildMap(bool isScroll) {
    var latLng;
    if (provider.latLong.text.isNotEmpty) {
      var v = provider.latLong.text;
      latLng = LatLng(double.parse(v.split(", ")[0]), double.parse(v.split(", ")[1]));
    } else {
      latLng = LatLng(35.6779346605152, 139.7681053353878);
    }
    print("LatLng is $latLng");
    return Stack(
      children: [
        SizedBox(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context) * 0.4,
          // color: Colors.amber,
          child: GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: CameraPosition(target: latLng, zoom: 15),
            onMapCreated: (controller) {
              print("On map created");
              if (isScroll) {
                _controller2.complete(controller);
              } else {
                _controller1.complete(controller);
              }
            },
            onCameraMove: (pos) {
              if (isScroll == false) {
                provider.latLong.text = "${pos.target.latitude}, ${pos.target.longitude}";
              } else {
                selectedLatLng = "${pos.target.latitude}, ${pos.target.longitude}";
              }
            },
            scrollGesturesEnabled: isScroll,
            gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Center(
            child: Icon(
              Icons.location_on_rounded,
              color: AppColor.redColor,
              size: 25,
            ),
          ),
        )
      ],
    );
  }

  @override
  void afterBuild(BuildContext context) {
    if (provider.latLong.text.isNotEmpty) {
      onChangeCamera(provider.latLong.text);
    }
  }
}
