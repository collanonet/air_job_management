import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_size.dart';
import '../utils/style.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: AppColor.primaryColor,
          weight: 20,
        ),
        AppSize.spaceWidth8,
        Text(
          title,
          style: titleStyle.copyWith(fontSize: 16, fontFamily: "Bold", color: const Color(0xff3B4043)),
        ),
      ],
    );
  }
}
