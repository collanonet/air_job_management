import 'package:air_job_management/const/const.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';

class AirJobManagementWidget extends StatelessWidget {
  final Function onPress;
  final Function onChooseBranch;
  final Company? company;
  final Branch? branch;
  const AirJobManagementWidget({Key? key, required this.onPress, required this.company, this.branch, required this.onChooseBranch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => onPress(),
            child: Image.asset(
              "assets/logo22.png",
              width: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              branch != null ? "${branch?.name}" : company?.companyName ?? "",
              textAlign: TextAlign.center,
              style: kNormalText.copyWith(color: Colors.black, fontSize: 14, fontFamily: "Bold"),
            ),
          ),
          Container(
            width: 150,
            height: 30,
            margin: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColor.primaryColor),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => onChooseBranch(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.swap_horiz_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    AppSize.spaceWidth16,
                    Text(
                      "切り替え",
                      style: kNormalText.copyWith(fontSize: 13, fontFamily: "Normal", color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          AppSize.spaceHeight8,
          Text(
            ConstValue.appVersion,
            textAlign: TextAlign.center,
            style: kNormalText.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
