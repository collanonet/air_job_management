import 'package:air_job_management/1_company_page/withdraw/widget/approve_or_reject_dialog.dart';
import 'package:air_job_management/1_company_page/withdraw/widget/filter.dart';
import 'package:air_job_management/1_company_page/withdraw/widget/withdraw_card.dart';
import 'package:air_job_management/models/user.dart';
import 'package:air_job_management/models/widthraw.dart';
import 'package:air_job_management/providers/auth.dart';
import 'package:air_job_management/providers/withdraw.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/toast_message_util.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:air_job_management/widgets/user_basic_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class UsageDetailPage extends StatefulWidget {
  const UsageDetailPage({super.key});

  @override
  State<UsageDetailPage> createState() => _UsageDetailPageState();
}

class _UsageDetailPageState extends State<UsageDetailPage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late WithdrawProvider provider;
  bool overlayLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<WithdrawProvider>(context, listen: false).setLoading = true;
    Provider.of<WithdrawProvider>(context, listen: false).initData();
    super.initState();
  }

  onChangeOverlayLoading(bool loading) {
    setState(() {
      overlayLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<WithdrawProvider>(context);
    return SizedBox(
        width: AppSize.getDeviceWidth(context),
        height: AppSize.getDeviceHeight(context),
        child: CustomLoadingOverlay(
          isLoading: overlayLoading,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Scrollbar(
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          const WithdrawFilterWidget(),
                          AppSize.spaceHeight16,
                          Container(
                            decoration: boxDecoration,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "支払請求申請一覧",
                                            style: titleStyle,
                                          ),
                                          AppSize.spaceWidth32,
                                          const SizedBox()
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            provider.startDate = null;
                                            provider.endDate = null;
                                            provider.onChangeLoading(true);
                                            await provider.onGetData(authProvider.myCompany?.uid ?? "");
                                          },
                                          icon: const Icon(Icons.refresh))
                                    ],
                                  ),
                                  AppSize.spaceHeight16,
                                  //Title
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Text(
                                                "氏名（漢字）",
                                                style: normalTextStyle.copyWith(fontSize: 13),
                                              ),
                                            )),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 40),
                                          child: Center(
                                            child: Text("金額", style: normalTextStyle.copyWith(fontSize: 13)),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text("申請者 日付", style: normalTextStyle.copyWith(fontSize: 13)),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text("口座名", style: normalTextStyle.copyWith(fontSize: 13)),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text("お振込先金融機関名", style: normalTextStyle.copyWith(fontSize: 12)),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text("ステータス", style: normalTextStyle.copyWith(fontSize: 13)),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(JapaneseText.remark, style: normalTextStyle.copyWith(fontSize: 13)),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text("アクション", style: normalTextStyle.copyWith(fontSize: 13)),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                  AppSize.spaceHeight16,
                                  buildList()
                                ],
                              ),
                            ),
                          )
                        ],
                      )))),
        ));
  }

  buildList() {
    if (provider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (provider.withdrawList.isNotEmpty) {
        return ListView.separated(
            itemCount: provider.withdrawList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == provider.withdrawList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              WithdrawModel w = provider.withdrawList[index];
              return WithdrawCardWidget(
                onUserTap: (id) => onUserTapped(id),
                withdrawModel: w,
                onApprove: () => showDialog(
                    context: context,
                    builder: (context) => ApproveOrRejectWithdrawDialog(
                        withdrawModel: w, status: "approved", onRefreshData: () => provider.onGetData(authProvider.myCompany?.uid ?? ""))),
                onReject: () => showDialog(
                    context: context,
                    builder: (context) => ApproveOrRejectWithdrawDialog(
                        withdrawModel: w, status: "rejected", onRefreshData: () => provider.onGetData(authProvider.myCompany?.uid ?? ""))),
              );
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }

  onUserTapped(String userId) async {
    onChangeOverlayLoading(true);
    MyUser? user = await UserApiServices().getProfileUser(userId);
    onChangeOverlayLoading(false);
    if (user != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: JapaneseText.basicInformation),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                ],
              ),
              content: SizedBox(
                height: AppSize.getDeviceHeight(context) * 0.7,
                width: AppSize.getDeviceWidth(context),
                child: Scaffold(
                  body: SizedBox(
                      height: AppSize.getDeviceHeight(context) * 0.7,
                      width: AppSize.getDeviceWidth(context),
                      child: UserBasicInformationPage(myUser: user)),
                ),
              )));
    } else {
      toastMessageError("Not found user", context);
    }
  }

  @override
  void afterBuild(BuildContext context) {
    provider.onGetData(authProvider.myCompany?.uid ?? "");
  }
}
