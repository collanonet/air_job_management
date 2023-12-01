import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/style.dart';

class CheckBoxListTileWidget extends StatelessWidget {
  final String title;
  final bool val;
  final Function onChange;
  final double size;
  const CheckBoxListTileWidget({Key? key, required this.title, required this.val, required this.onChange, this.size = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: CheckboxListTile(
        value: val,
        dense: true,
        contentPadding: EdgeInsets.zero,
        activeColor: AppColor.primaryColor,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (v) => onChange(v),
        title: Text(
          title,
          style: kNormalText,
        ),
      ),
    );
  }
}
