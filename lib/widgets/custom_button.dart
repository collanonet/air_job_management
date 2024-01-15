import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;
  final double radius;
  const ButtonWidget({super.key, required this.title, this.color = const Color(0xfff38301), this.radius = 4, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          border: Border.all(
              width: radius == 4 ? 1 : 3,
              color: color == Colors.white
                  ? radius == 25
                      ? AppColor.primaryColor
                      : AppColor.secondaryColor
                  : color)),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Text(
          title,
          style: normalTextStyle.copyWith(fontFamily: "Bold", fontSize: 15, color: color == Colors.white ? AppColor.primaryColor : Colors.white),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}
