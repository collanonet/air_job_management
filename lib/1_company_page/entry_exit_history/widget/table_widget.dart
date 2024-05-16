import 'package:flutter/material.dart';

import '../../../utils/style.dart';

class DataTableWidget extends StatelessWidget {
  final String? data;
  const DataTableWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 30,
        decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffF0F3F5))),
        alignment: Alignment.center,
        child: Text(
          data ?? "",
          style: kNormalText,
        ),
      ),
    );
  }
}
