import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class CustomChooseDateOrTimeWidget extends StatelessWidget {
  final double? width;
  final bool isHaveIcon;
  final String title;
  final String val;
  final Function onTap;
  const CustomChooseDateOrTimeWidget(
      {super.key, this.width = 100, this.isHaveIcon = false, required this.title, required this.onTap, required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kNormalText.copyWith(fontFamily: "Normal", fontSize: 12, color: AppColor.darkGrey),
        ),
        AppSize.spaceHeight5,
        Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              color: AppColor.whiteColor, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: AppColor.thirdColor)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(),
              borderRadius: BorderRadius.circular(5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      val,
                      style: kNormalText.copyWith(fontFamily: "Normal", fontSize: 16, color: AppColor.darkGrey),
                    ),
                    isHaveIcon
                        ? Icon(
                            Icons.date_range_rounded,
                            size: 20,
                            color: AppColor.thirdColor,
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
        AppSize.spaceHeight16
      ],
    );
  }
}
