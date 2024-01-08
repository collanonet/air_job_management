import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class IdentificationMenuCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onTap;
  const IdentificationMenuCard(
      {super.key,
      required this.title,
      required this.onTap,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        width: AppSize.getDeviceWidth(context),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        height: 100,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    FontAwesome5Solid.id_card,
                    color: AppColor.primaryColor,
                    size: 30,
                  ),
                  AppSize.spaceWidth16,
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: kTitleText.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subTitle.isEmpty
                          ? const SizedBox()
                          : AppSize.spaceHeight5,
                      subTitle.isEmpty
                          ? const SizedBox()
                          : Text(
                              subTitle,
                              style: kSubtitleText.copyWith(fontSize: 14),
                            )
                    ],
                  )),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
