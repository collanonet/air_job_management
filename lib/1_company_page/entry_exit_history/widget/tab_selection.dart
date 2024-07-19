import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/company/entry_exit_history.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';

class TabSelectionWidget extends StatelessWidget {
  final Function? onRefresh;
  const TabSelectionWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EntryExitHistoryProvider>(context);
    return Row(
      children: [
        InkWell(
          onTap: () {
            provider.onChangeSelectMenu(provider.tabMenu[0]);
          },
          child: Container(
            width: 300,
            height: 39,
            alignment: Alignment.center,
            child: Text(
              provider.tabMenu[0],
              style: normalTextStyle.copyWith(
                  fontSize: 16, fontFamily: "Bold", color: provider.selectedMenu == provider.tabMenu[0] ? Colors.white : AppColor.primaryColor),
            ),
            decoration: BoxDecoration(
                color: provider.selectedMenu == provider.tabMenu[0] ? AppColor.primaryColor : Colors.white,
                border: Border.all(width: 2, color: AppColor.primaryColor),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
          ),
        ),
        AppSize.spaceWidth16,
        InkWell(
          onTap: () {
            provider.onChangeSelectMenu(provider.tabMenu[1]);
            if (onRefresh != null) {
              onRefresh!();
            }
          },
          child: Container(
            width: 300,
            height: 39,
            alignment: Alignment.center,
            child: Text(
              provider.tabMenu[1],
              style: normalTextStyle.copyWith(
                  fontSize: 16, fontFamily: "Bold", color: provider.selectedMenu == provider.tabMenu[1] ? Colors.white : AppColor.primaryColor),
            ),
            decoration: BoxDecoration(
                color: provider.selectedMenu == provider.tabMenu[1] ? AppColor.primaryColor : Colors.white,
                border: Border.all(width: 2, color: AppColor.primaryColor),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
          ),
        ),
      ],
    );
  }
}
