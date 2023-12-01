import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/style.dart';

class RadioListTileWidget extends StatelessWidget {
  final String title;
  final String val;
  final double size;
  final Function onChange;
  const RadioListTileWidget({Key? key, required this.title, required this.val, required this.onChange, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: RadioListTile(
          activeColor: AppColor.primaryColor,
          contentPadding: EdgeInsets.zero,
          groupValue: title,
          title: Text(
            title,
            style: kNormalText.copyWith(fontSize: 12),
          ),
          value: val,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (v) => onChange(title)),
    );
  }
}
