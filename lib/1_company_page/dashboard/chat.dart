import 'package:air_job_management/1_company_page/dashboard/chat_detail.dart';
import 'package:air_job_management/helper/japan_date_time.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../api/user_api.dart';
import '../../api/worker_api/chat_api.dart';
import '../../models/company.dart';
import '../../models/user.dart';
import '../../providers/auth.dart';
import '../../providers/company/worker_management.dart';
import '../../utils/common_utils.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/empty_data.dart';

class ChatPageAtDashboard extends StatefulWidget {
  const ChatPageAtDashboard({super.key});

  @override
  State<ChatPageAtDashboard> createState() => _ChatPageAtDashboardState();
}

class _ChatPageAtDashboardState extends State<ChatPageAtDashboard> with AfterBuildMixin {
  List<String> userIdList = [];
  List<MyUser> myUserList = [];
  var db = FirebaseFirestore.instance;
  late WorkerManagementProvider workerManagementProvider;
  late AuthProvider authProvider;
  ScrollController scrollController = ScrollController();
  TextEditingController search = TextEditingController(text: "");
  int? selectIndex;

  @override
  void initState() {
    Provider.of<WorkerManagementProvider>(context, listen: false).onInitForList();
    super.initState();
  }

  getData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
        await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
        getAllUserId();
        workerManagementProvider.onChangeLoading(false);
      }
    } else {
      workerManagementProvider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await workerManagementProvider.getWorkerApply(authProvider.myCompany?.uid ?? "", authProvider.branch?.id ?? "");
      getAllUserId();
      workerManagementProvider.onChangeLoading(false);
    }
  }

  getAllUserId() {
    for (var worker in workerManagementProvider.workManagementList) {
      if (worker.userId != null && worker.userId != "" && worker.userId != "null") {}
      userIdList.add(worker.userId ?? "asd");
    }
    userIdList = userIdList.toSet().toList();
    for (int i = 0; i < userIdList.length; i++) {
      if (userIdList[i] == "asd") {
        userIdList.removeAt(i);
      }
    }
    for (var userId in userIdList) {
      for (var worker in workerManagementProvider.workManagementList) {
        if (userId == worker.userId) {
          myUserList.add(worker.myUser!);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    workerManagementProvider = Provider.of<WorkerManagementProvider>(context);
    return Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.all(8),
      height: 535,
      child: workerManagementProvider.isLoading
          ? Center(child: LoadingWidget(AppColor.primaryColor))
          : Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "チャット",
                          style: kTitleText.copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                    AppSize.spaceHeight16,
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: PrimaryTextField(
                        controller: search,
                        hint: "検索",
                        isRequired: false,
                        onChange: (v) {
                          setState(() {});
                        },
                      ),
                    ),
                    Scrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      child: SizedBox(
                        width: 300,
                        height: 420,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: userIdList.length,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              if (search.text.isEmpty ||
                                  (search.text.isNotEmpty && myUserList[index].nameKanJi!.toLowerCase().contains(search.text.toLowerCase()))) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          selectIndex = null;
                                        });
                                        await Future.delayed(const Duration(milliseconds: 300));
                                        setState(() {
                                          selectIndex = index;
                                        });
                                      },
                                      child: ListTile(
                                        onTap: () async {
                                          setState(() {
                                            selectIndex = null;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 300));
                                          setState(() {
                                            selectIndex = index;
                                          });
                                        },
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            width: 40,
                                            height: 40,
                                            imageUrl: myUserList[index].profileImage ?? "",
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColor.primaryColor),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppColor.whiteColor,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          myUserList[index].nameKanJi ?? "",
                                          style: kTitleText.copyWith(fontSize: 15),
                                        ),
                                        subtitle: StreamBuilder(
                                          stream: MessageApi(userIdList[index], authProvider!.myCompany!.uid!)
                                              .messageRef
                                              .limit(1)
                                              .orderBy("created_at", descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            var d = snapshot.data?.docs.firstOrNull;
                                            String message = d?["message"] ?? "";
                                            int type = d?["type"] ?? 3;
                                            var date = DateTime.parse(d?["created_at"] ?? "2000-10-11");
                                            var now = DateTime.now();
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.connectionState == ConnectionState.waiting
                                                      ? "Loading..."
                                                      : [message, "An Image", "A File", ""][type],
                                                  style: kNormalText.copyWith(fontSize: 14),
                                                ),
                                                Text(
                                                  snapshot.connectionState == ConnectionState.waiting
                                                      ? "Loading..."
                                                      : CommonUtils.isTheSameDate(date, now)
                                                          ? dateTimeToHourAndMinute(date)
                                                          : toJapanDateTimeNoWeekDay(date),
                                                  style: kNormalText.copyWith(fontSize: 12),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Divider(),
                                    )
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                selectIndex != null
                    ? DashboardChatPage(
                        myUser: myUserList[selectIndex!],
                        companyID: authProvider.myCompany!.uid!,
                        companyImageUrl: authProvider.myCompany!.companyProfile,
                        companyName: authProvider.myCompany!.companyName,
                      )
                    : const Expanded(
                        child: Center(
                          child: EmptyDataWidget(),
                        ),
                      )
              ],
            ),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }
}
