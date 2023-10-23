import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';

class AirJobManagementWidget extends StatelessWidget {
  final Function onPress;
  const AirJobManagementWidget({Key? key, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPress(),
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_history_outlined,
                color: AppColor.primaryColor,
                size: 35,
              ),
              AppSize.spaceHeight8,
              const Text(
                "Air Job\n Management",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              AppSize.spaceHeight8,
              const Text(
                "Version: 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
