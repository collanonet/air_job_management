import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

class SelectBoxListTileWidget extends StatelessWidget {
  final String title;
  final bool val;
  final Function onChange;
  final double size;
  const SelectBoxListTileWidget({Key? key, required this.title, required this.val, required this.onChange, this.size = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChange(title),
      child: Container(
        width: size,
        height: 50,
        padding: const EdgeInsets.only(left: 8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: val ? AppColor.primaryColor.withOpacity(0.6) : Colors.white,
            border: Border.all(width: 0.5, color: Colors.black)),
        child: Text(
          title,
          style: kNormalText.copyWith(fontSize: 13.5),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
