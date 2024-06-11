import 'package:air_job_management/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class DataTableFixedWidthWidget extends StatelessWidget {
  final String? data;
  final double width;
  final bool isName;
  const DataTableFixedWidthWidget({super.key, this.data, this.width = 70, this.isName = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      decoration:
          BoxDecoration(color: data == "" ? Colors.redAccent : Colors.transparent, border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
      alignment: Alignment.center,
      child: Text(
        data ?? "",
        style: kNormalText.copyWith(color: isName ? AppColor.primaryColor : Colors.black),
      ),
    );
  }
}
