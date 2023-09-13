import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobSeekerCardWidget extends StatelessWidget {
  final MyUser user;
  const JobSeekerCardWidget({Key? key, required this.user}) : super(key: key);

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
          onTap: () => context.go("${MyRoute.jobSeeker}/${user.uid}"),
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
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      AppSize.spaceWidth5,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.nameKanJi}",
                            style: normalTextStyle.copyWith(
                                fontSize: 13, color: AppColor.primaryColor),
                          ),
                          AppSize.spaceHeight5,
                          Text(
                            "${user.nameFu}",
                            style: normalTextStyle.copyWith(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text("${user.note}",
                      style: normalTextStyle.copyWith(fontSize: 13)),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey, width: 1)),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Text("${user.note}"),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Center(
                      child: Icon(
                    Icons.email_rounded,
                    color: AppColor.primaryColor,
                  )),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                      child: Text("Status",
                          style: normalTextStyle.copyWith(fontSize: 13))),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
