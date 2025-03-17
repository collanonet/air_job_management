import 'package:air_job_management/api/user_api.dart';
import 'package:air_job_management/const/status.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/application_history.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/basic_info.dart';
import 'package:air_job_management/pages/job_seeker/job_seeker_detail/chat.dart';
import 'package:air_job_management/providers/job_seeker_detail.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';

class JobSeekerDetailPage extends StatefulWidget {
  final String seekerId;
  const JobSeekerDetailPage({Key? key, required this.seekerId}) : super(key: key);

  @override
  State<JobSeekerDetailPage> createState() => _JobSeekerDetailPageState();
}

class _JobSeekerDetailPageState extends State<JobSeekerDetailPage> with AfterBuildMixin {
  MyUser? seeker;
  late JobSeekerDetailProvider provider;

  @override
  void initState() {
    Provider.of<JobSeekerDetailProvider>(context, listen: false).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JobSeekerDetailProvider>(context);
    return CustomLoadingOverlay(isLoading: provider.isLoading, child: buildBody());
  }

  buildBody() {
    if (provider.isLoading) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBarWidget(),
            AppSize.spaceHeight16,
            tabSelection(),
            if (provider.selectMenu == provider.tabMenu[0])
              Expanded(
                  child: BasicInfoPage(
                seeker: seeker!,
              ))
            else if (provider.selectMenu == provider.tabMenu[1])
              Expanded(
                  child: ChatPage(
                id: widget.seekerId,
              ))
            else
              Expanded(
                  child: ApplicationHistoryPage(
                id: widget.seekerId,
              ))
          ],
        ),
      );
    }
  }

  topBarWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 100,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${seeker?.nameKanJi}",
                    style: normalTextStyle.copyWith(fontSize: 13, color: AppColor.primaryColor),
                  ),
                  AppSize.spaceHeight5,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${seeker?.nameFu}",
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      AppSize.spaceWidth16,
                      Text(
                        "${seeker?.dob}",
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                      AppSize.spaceWidth16,
                      Text(
                        "${seeker?.email}",
                        style: normalTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              StatusUtils.displayStatusForJobSeeker(seeker?.workingStatus),
              AppSize.spaceWidth16,
              IconButton(onPressed: () => context.pop(), icon: Icon(Icons.close)),
            ],
          )
        ],
      ),
    );
  }

  tabSelection() {
    return Stack(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => provider.onChangeMenu(provider.tabMenu[0]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[0],
                  style: normalTextStyle.copyWith(color: provider.selectMenu == provider.tabMenu[0] ? Colors.white : Colors.black),
                ),
                decoration: BoxDecoration(
                    color: provider.selectMenu == provider.tabMenu[0] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
            AppSize.spaceWidth16,
            GestureDetector(
              onTap: () => provider.onChangeMenu(provider.tabMenu[1]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[1],
                  style: normalTextStyle.copyWith(color: provider.selectMenu == provider.tabMenu[1] ? Colors.white : Colors.black),
                ),
                decoration: BoxDecoration(
                    color: provider.selectMenu == provider.tabMenu[1] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            ),
            AppSize.spaceWidth16,
            GestureDetector(
              onTap: () => provider.onChangeMenu(provider.tabMenu[2]),
              child: Container(
                width: AppSize.getDeviceWidth(context) * 0.25,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  provider.tabMenu[2],
                  style: normalTextStyle.copyWith(color: provider.selectMenu == provider.tabMenu[2] ? Colors.white : Colors.black),
                ),
                decoration: BoxDecoration(
                    color: provider.selectMenu == provider.tabMenu[2] ? AppColor.primaryColor : Colors.white,
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
              ),
            )
          ],
        ),
        Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: AppSize.getDeviceWidth(context) * 0.75,
              height: 1,
              color: AppColor.primaryColor,
            ))
      ],
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getJobSeeker();
  }

  getJobSeeker() async {
    seeker = await UserApiServices().getProfileUser(widget.seekerId);
    provider.onChangeLoading(false);
  }
}
