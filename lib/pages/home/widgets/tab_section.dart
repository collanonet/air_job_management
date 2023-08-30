import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/home.dart';

class TabSectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPress;
  const TabSectionWidget({Key? key, required this.title, required this.icon, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: homeProvider.selectedItem == title ? AppColor.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPress(),
          hoverColor: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: homeProvider.selectedItem == title ? AppColor.whiteColor : Colors.grey,
                size: 35,
              ),
              AppSize.spaceHeight8,
              Text(
                title,
                style: TextStyle(color: homeProvider.selectedItem == title ? AppColor.whiteColor : Colors.grey, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
