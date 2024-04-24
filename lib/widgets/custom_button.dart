import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;
  final double radius;
  final double height;
  final Color? borderColor;
  const ButtonWidget(
      {super.key,
      this.borderColor,
      this.height = 40,
      required this.title,
      this.color = const Color(0xfff38301),
      this.radius = 4,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          border: Border.all(
              width: radius == 4 ? 1 : 3,
              color: borderColor != null
                  ? borderColor!
                  : color == Colors.white
                      ? radius == 25
                          ? AppColor.primaryColor
                          : AppColor.secondaryColor
                      : color)),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Text(
          title,
          style: normalTextStyle.copyWith(
              fontFamily: "Bold",
              fontSize: 13,
              color: color == AppColor.seaColor
                  ? Colors.white
                  : borderColor != null
                      ? borderColor!
                      : color == Colors.white
                          ? AppColor.primaryColor
                          : Colors.white),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}
