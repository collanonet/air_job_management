import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/company/entry_exit_history.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';

class FilterEntryExitList extends StatelessWidget {
  const FilterEntryExitList({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EntryExitHistoryProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 80,
      decoration: boxDecoration,
      padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "作業者の入退出履歴",
            style: titleStyle,
          ),
        ],
      ),
    );
  }
}
