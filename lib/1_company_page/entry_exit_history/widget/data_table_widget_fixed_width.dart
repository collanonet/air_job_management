import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class DataTableFixedWidthWidget extends StatelessWidget {
  final String? data;
  final double width;
  const DataTableFixedWidthWidget({super.key, this.data, this.width = 70});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
      alignment: Alignment.center,
      child: Text(
        data ?? "",
        style: kNormalText,
      ),
    );
  }
}
