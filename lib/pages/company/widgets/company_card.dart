import 'package:air_job_management/const/status.dart';
import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompanyCardWidget extends StatelessWidget {
  final Company company;
  const CompanyCardWidget({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColor.primaryColor),
          borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go("${MyRoute.company}/${company.uid}"),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primaryColor),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.home_work_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      AppSize.spaceWidth5,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${company.companyName}",
                            style: normalTextStyle.copyWith(
                                fontSize: 13, color: AppColor.primaryColor),
                          ),
                          AppSize.spaceHeight5,
                          Text(
                            "${company.rePresentative?.kanji} ${company.rePresentative?.kana}",
                            style: normalTextStyle.copyWith(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  flex: 4,
                ),
                Expanded(
                  child:
                      Text("大阪", style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 3,
                ),
                Expanded(
                  child: Text("01.農林業",
                      style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 3,
                ),
                Expanded(
                  child:
                      Text("7", style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 3,
                ),
                Expanded(
                  child: Center(
                      child: Icon(
                    Icons.email_rounded,
                    color: AppColor.primaryColor,
                  )),
                  flex: 3,
                ),
                Expanded(
                  child: StatusUtils.displayStatus(""),
                  flex: 3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
