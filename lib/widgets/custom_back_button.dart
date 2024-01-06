import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class CustomBackButtonWidget extends StatelessWidget {
  final Color textColor;
  const CustomBackButtonWidget({super.key, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_new_rounded),
            AppSize.spaceWidth8,
            Text(
              "戻る",
              style: kNormalText.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
