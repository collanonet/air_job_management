import 'dart:ui';

import 'package:air_job_management/1_company_page/shift_calendar/widget/copy_paste.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/edit_shift_for_calendar.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/job_card_display.dart';
import 'package:air_job_management/1_company_page/shift_calendar/widget/shift_detail_dialog.dart';
import 'package:air_job_management/api/job_posting.dart';
import 'package:air_job_management/providers/company/shift_calendar.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:air_job_management/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../api/user_api.dart';
import '../../helper/japan_date_time.dart';
import '../../models/calendar.dart';
import '../../models/company.dart';
import '../../models/job_posting.dart';
import '../../providers/auth.dart';
import '../../providers/company/job_posting.dart';
import '../../utils/app_size.dart';
import '../../utils/my_route.dart';
import '../../utils/toast_message_util.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../job_posting/create_or_edit_job_posting.dart';
import '../job_posting/widget/matching_worker.dart';
import 'data_source/shift_calendar.dart';
import 'data_source/shift_calendar_by_job_post.dart';
import 'data_source/shift_calendar_for_job.dart';

class ShiftCalendarPage extends StatefulWidget {
  const ShiftCalendarPage({super.key});

  @override
  State<ShiftCalendarPage> createState() => _ShiftCalendarPageState();
}

class _ShiftCalendarPageState extends State<ShiftCalendarPage> with AfterBuildMixin {
  late AuthProvider authProvider;
  late ShiftCalendarProvider provider;
  ScrollController scrollController = ScrollController();
  late ShiftCalendarDataSource shiftCalendarDataSource;
  late ShiftCalendarDataSourceForJob shiftCalendarDataSourceForJob;
  late ShiftCalendarDataSourceByJobPosting shiftCalendarDataSourceByJobPosting;
  late JobPostingForCompanyProvider p;
  // JobPosting? selectedJob;

  @override
  void initState() {
    Provider.of<JobPostingForCompanyProvider>(context, listen: false).setAllController = [];
    var provider = Provider.of<ShiftCalendarProvider>(context, listen: false);
    shiftCalendarDataSource = ShiftCalendarDataSource(provider: provider);
    shiftCalendarDataSourceForJob = ShiftCalendarDataSourceForJob(provider: provider);
    shiftCalendarDataSourceByJobPosting =
        ShiftCalendarDataSourceByJobPosting(provider: provider, onTap: (CountByDate job) => showJobApplyDialog(job.date, job.jobApplyId));
    Provider.of<ShiftCalendarProvider>(context, listen: false).initializeRangeDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    provider = Provider.of<ShiftCalendarProvider>(context);
    p = Provider.of<JobPostingForCompanyProvider>(context);
    return CustomLoadingOverlay(
        isLoading: provider.isLoading,
        child: Container(
          width: AppSize.getDeviceWidth(context),
          height: AppSize.getDeviceHeight(context),
          margin: const EdgeInsets.all(16.0),
          decoration: boxDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // const ShiftCalendarFilterDataWidgetForCompany(),
                    Row(
                      children: [
                        buildTab(provider.displayList[0]),
                        buildTab(provider.displayList[1]),
                        buildTab(provider.displayList[2]),
                        Expanded(
                            child: CopyPasteShiftCalendarWidget(onMatching: () {
                          if (provider.jobPosting == null ||
                              provider.selectDisplay == provider.displayList[1] ||
                              provider.selectDisplay == provider.displayList[1]) {
                            toastMessageError("最初にコピーしたいジョブを選択してください。", context);
                          } else {
                            showMatching();
                          }
                        }, onCopyPaste: () {
                          if (provider.jobPosting == null || provider.selectDisplay == provider.displayList[0]) {
                            toastMessageError("最初にコピーしたいジョブを選択してください。", context);
                          } else {
                            showCopyAndPaste();
                          }
                        }))
                      ],
                    ),
                    if (provider.selectDisplay == provider.displayList[0])
                      buildShiftPerDay()
                    else if (provider.selectDisplay == provider.displayList[1])
                      buildShiftPerMonth()
                    else
                      buildCalendarWidget()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  buildTab(String title) {
    return Container(
      width: 130,
      height: 40,
      decoration: BoxDecoration(
          color: title == provider.selectDisplay ? AppColor.primaryColor : const Color(0xffFFF7E5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomLeft: Radius.circular(provider.selectDisplay == provider.displayList[0] ? 6 : 0),
              bottomRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0),
              topRight: Radius.circular(provider.selectDisplay == provider.displayList[1] ? 6 : 0)),
          onTap: () => provider.onChangeDisplay(title),
          child: Center(
            child: Text(
              title,
              style: kNormalText.copyWith(
                  fontSize: 13, fontFamily: "Bold", color: title == provider.selectDisplay ? Colors.white : AppColor.primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  ScrollController scrollControllerForShiftPerDay = ScrollController();

  buildShiftPerDay() {
    return shiftCalendarDataSource == null
        ? const SizedBox()
        : Column(
            children: [
              AppSize.spaceHeight16,
              buildMonthDisplay(true),
              AppSize.spaceHeight16,
              AppSize.spaceHeight30,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 73),
                    child: SizedBox(
                      height: provider.jobApplyPerDay.length * 45,
                      width: 80,
                      child: ListView.builder(
                          itemCount: provider.jobApplyPerDay.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 45,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${provider.jobApplyPerDay[index].myUser?.nameKanJi}",
                                  style: kNormalText.copyWith(fontFamily: "Bold"),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 5, left: 10),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: AppColor.primaryColor,
                        ),
                        AppSize.spaceHeight5,
                        Container(
                          height: provider.jobApplyPerDay.length * 45,
                          width: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.primaryColor),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  scrollControllerForShiftPerDay.animateTo(0, duration: const Duration(milliseconds: 1000), curve: Curves.ease),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      }),
                      child: Scrollbar(
                        controller: scrollControllerForShiftPerDay,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: scrollControllerForShiftPerDay,
                          child: SfDataGrid(
                              source: shiftCalendarDataSource,
                              columnWidthMode: ColumnWidthMode.fill,
                              isScrollbarAlwaysShown: false,
                              rowHeight: 45,
                              headerRowHeight: 80,
                              shrinkWrapRows: true,
                              shrinkWrapColumns: true,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              // horizontalScrollController: scrollControllerForShiftPerDay,
                              horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                              verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                              columns: provider.rangeDateList.map((e) {
                                int applyCount = 0;
                                int recCount = 0;
                                for (var s in e.shiftModelList!) {
                                  if (s.date == e.date) {
                                    applyCount += s.applicantCount;
                                    recCount += int.parse(s.recruitmentCount);
                                  }
                                }
                                return GridColumn(
                                    width: 80,
                                    label: Center(
                                        child: Column(
                                      children: [
                                        Text(e.date.day.toString()),
                                        Container(
                                          width: 78,
                                          height: 23,
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          color: (e.date.weekday == 6 || e.date.weekday == 7)
                                              ? Colors.redAccent.withOpacity(0.1)
                                              : Colors.blue.withOpacity(0.1),
                                          alignment: Alignment.center,
                                          child: Text(
                                            toJapanWeekDayWithInt(e.date.weekday),
                                            style: kNormalText.copyWith(fontSize: 10),
                                          ),
                                        ),
                                        Container(
                                          width: 78,
                                          height: 23,
                                          color: applyCount == recCount ? const Color(0xff7DC338) : AppColor.primaryColor,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "$applyCount/$recCount",
                                            style: kNormalText.copyWith(fontSize: 10, color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )),
                                    columnName: e.date.toString());
                              }).toList()),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: provider.jobApplyPerDay.length * 45,
                    width: 35,
                    margin: const EdgeInsets.only(top: 73, left: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.primaryColor),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => scrollControllerForShiftPerDay.animateTo(scrollControllerForShiftPerDay.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 1000), curve: Curves.ease),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  buildShiftPerMonth() {
    return shiftCalendarDataSource == null
        ? const SizedBox()
        : Column(
            children: [
              AppSize.spaceHeight16,
              buildMonthDisplay(true),
              AppSize.spaceHeight16,
              AppSize.spaceHeight30,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 73),
                    child: SizedBox(
                      height: provider.jobPostingDataTableList.length * 45,
                      width: 80,
                      child: ListView.builder(
                          itemCount: provider.jobPostingDataTableList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 45,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  provider.jobPostingDataTableList[index].job,
                                  style: kNormalText.copyWith(fontFamily: "Bold"),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 5, left: 10),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: AppColor.primaryColor,
                        ),
                        AppSize.spaceHeight5,
                        Container(
                          height: provider.jobPostingDataTableList.length * 45,
                          width: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.primaryColor),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  scrollControllerForShiftPerDay.animateTo(0, duration: const Duration(milliseconds: 1000), curve: Curves.ease),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (provider.jobPostingDataTableList.length * 45) + 70,
                    width: AppSize.getDeviceWidth(context) * 0.65,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      }),
                      child: Scrollbar(
                        controller: scrollControllerForShiftPerDay,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: scrollControllerForShiftPerDay,
                          child: SfDataGrid(
                              source: shiftCalendarDataSourceByJobPosting,
                              columnWidthMode: ColumnWidthMode.fill,
                              isScrollbarAlwaysShown: false,
                              rowHeight: 45,
                              headerRowHeight: 65,
                              shrinkWrapRows: true,
                              shrinkWrapColumns: true,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              // horizontalScrollController: scrollControllerForShiftPerDay,
                              horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                              verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                              columns: provider.rangeDateList.map((e) {
                                return GridColumn(
                                    width: 80,
                                    label: Center(
                                        child: Column(
                                      children: [
                                        Text(e.date.day.toString()),
                                        Container(
                                          width: 78,
                                          height: 23,
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          color: (e.date.weekday == 6 || e.date.weekday == 7)
                                              ? Colors.redAccent.withOpacity(0.1)
                                              : Colors.blue.withOpacity(0.1),
                                          alignment: Alignment.center,
                                          child: Text(
                                            toJapanWeekDayWithInt(e.date.weekday),
                                            style: kNormalText.copyWith(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    )),
                                    columnName: e.date.toString());
                              }).toList()),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: provider.jobPostingDataTableList.length * 45,
                    width: 35,
                    margin: const EdgeInsets.only(top: 73, left: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.primaryColor),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => scrollControllerForShiftPerDay.animateTo(scrollControllerForShiftPerDay.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 1000), curve: Curves.ease),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  List<String> menuTab = ["日付を選んでシフト枠作成", "曜日と時間帯を選んでシフト枠作成"];
  String selectedTab = "日付を選んでシフト枠作成";

  buildCalendarWidget() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "カレンダー表示",
                style: titleStyle,
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 30,
                    color: const Color(0xff7DC338),
                    child: Center(
                      child: Text(
                        "満枠",
                        style: kNormalText.copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  AppSize.spaceWidth8,
                  Container(
                    width: 80,
                    height: 30,
                    color: AppColor.primaryColor,
                    child: Center(
                      child: Text(
                        "空き",
                        style: kNormalText.copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          buildMonthDisplay(false),
          AppSize.spaceHeight8,
          Center(
            child: SizedBox(
              width: AppSize.getDeviceWidth(context) * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "月",
                    style: kNormalText,
                  ),
                  Text(
                    "火",
                    style: kNormalText,
                  ),
                  Text(
                    "水",
                    style: kNormalText,
                  ),
                  Text(
                    "木",
                    style: kNormalText,
                  ),
                  Text(
                    "金",
                    style: kNormalText,
                  ),
                  Text(
                    "土",
                    style: kNormalText,
                  ),
                  Text(
                    "日",
                    style: kNormalText,
                  ),
                ],
              ),
            ),
          ),
          AppSize.spaceHeight8,
          Center(
            child: provider.rangeDateList.isEmpty
                ? const SizedBox()
                : Container(
                    width: AppSize.getDeviceWidth(context) * 0.6,
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      left: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      right: BorderSide(width: 0.4, color: AppColor.darkGrey),
                      bottom: BorderSide(width: 0.4, color: AppColor.darkGrey),
                    )),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 12 / 8),
                        itemCount: 42,
                        itemBuilder: (BuildContext context, int i) {
                          if (i + 1 >= provider.firstDate.weekday) {
                            int index = (i + 1) - provider.firstDate.weekday;
                            var date = index < provider.rangeDateList.length
                                ? provider.rangeDateList[(i + 1) - provider.firstDate.weekday]
                                : CalendarModel(date: DateTime(2000), shiftModelList: [], jobId: "");
                            var weekDay = date.date.weekday;
                            return Container(
                              decoration: BoxDecoration(
                                  color: weekDay == 6 && date.date.year != 2000
                                      ? const Color(0xffEFFCFF)
                                      : weekDay == 7 && date.date.year != 2000
                                          ? const Color(0xffFFF2F2)
                                          : Colors.white,
                                  border: Border.all(width: 0.2, color: AppColor.darkGrey)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          date.date.year == 2000 ? "" : '${date.date.day}',
                                          style: kTitleText.copyWith(color: AppColor.midGrey, fontSize: 16),
                                        )),
                                  ),
                                  Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: date.shiftModelList!.length,
                                          itemBuilder: (context, ind) {
                                            var shift = date.shiftModelList![ind];
                                            return Container(
                                              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 4),
                                              width: 400,
                                              color: shift.applicantCount.toString() == shift.recruitmentCount.toString()
                                                  ? const Color(0xff7DC338)
                                                  : AppColor.primaryColor,
                                              height: 20,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    var job = await JobPostingApiService().getAJobPosting(shift.myJob?.uid ?? "");
                                                    p.onInitForJobPostingDetail(shift.myJob?.uid ?? "", jobP: job);
                                                    provider.jobPosting = job;
                                                    setState(() {});
                                                  },
                                                  onDoubleTap: () => showJobApplyDialog(shift.date!, shift.jobId!),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${shift.startWorkTime} - ${shift.endWorkTime} ",
                                                            style: kNormalText.copyWith(color: Colors.white, fontSize: 12),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                        AppSize.spaceWidth5,
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 1),
                                                          child: Text(
                                                            "${shift.applicantCount}/${shift.recruitmentCount}",
                                                            style: kNormalText.copyWith(color: Colors.white, fontSize: 11),
                                                          ),
                                                        ),
                                                        AppSize.spaceWidth5,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                  color: i == 33 || i == 5
                                      ? const Color(0xffEFFCFF)
                                      : i == 34
                                          ? const Color(0xffFFF2F2)
                                          : Colors.white,
                                  border: Border.all(width: 0.2, color: AppColor.darkGrey)),
                            );
                          }
                        }),
                  ),
          ),
          AppSize.spaceHeight30,
          buildTabForCreateShift(),
          AppSize.spaceHeight30,
          if (provider.jobPosting == null)
            const Center(
              child: EmptyDataWidget(),
            )
          else
            buildEditJobPosting()
        ],
      ),
    );
  }

  buildEditJobPosting() {
    return EditShiftForCalendarPage();
  }

  buildTabForCreateShift() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTab = menuTab[0];
              });
            },
            child: Container(
              // width: AppSize.getDeviceWidth(context) * 0.41,
              height: 39,
              alignment: Alignment.center,
              child: Text(
                menuTab[0],
                style: normalTextStyle.copyWith(
                    fontSize: 16, fontFamily: "Bold", color: selectedTab == menuTab[0] ? Colors.white : AppColor.primaryColor),
              ),
              decoration: BoxDecoration(
                  color: selectedTab == menuTab[0] ? AppColor.primaryColor : Colors.white,
                  border: Border.all(width: 2, color: AppColor.primaryColor),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            ),
          ),
        ),
        AppSize.spaceWidth16,
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTab = menuTab[1];
              });
            },
            child: Container(
              // width: AppSize.getDeviceWidth(context) * 0.41,
              height: 39,
              alignment: Alignment.center,
              child: Text(
                menuTab[1],
                style: normalTextStyle.copyWith(
                    fontSize: 16, fontFamily: "Bold", color: selectedTab == menuTab[1] ? Colors.white : AppColor.primaryColor),
              ),
              decoration: BoxDecoration(
                  color: selectedTab == menuTab[1] ? AppColor.primaryColor : Colors.white,
                  border: Border.all(width: 2, color: AppColor.primaryColor),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            ),
          ),
        ),
      ],
    );
  }

  showJobApplyDialog(DateTime date, String jobId) {
    showDialog(
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceHeight(context) * 0.1, vertical: 32),
              child: ShiftDetailDialogWidget(
                jobId: jobId,
                date: date,
              ),
            ));
  }

  buildMonthDisplay(bool isShowStatus) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: Container(
            height: 45,
            width: 180,
            margin: const EdgeInsets.only(right: 64),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1, color: AppColor.primaryColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.month.year, provider.month.month - 1, provider.month.day));
                      await getData();
                      await provider.findJobByOccupation();
                      shiftCalendarDataSource = ShiftCalendarDataSource(provider: provider);
                      shiftCalendarDataSourceForJob = ShiftCalendarDataSourceForJob(provider: provider);
                      shiftCalendarDataSourceByJobPosting = ShiftCalendarDataSourceByJobPosting(
                          provider: provider, onTap: (CountByDate job) => showJobApplyDialog(job.date, job.jobApplyId));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                      color: AppColor.primaryColor,
                    )),
                Text(
                  "${toJapanMonthAndYear(provider.month)}",
                  style: titleStyle.copyWith(fontFamily: "Medium", fontSize: 14),
                ),
                IconButton(
                    onPressed: () async {
                      provider.onChangeMonth(DateTime(provider.month.year, provider.month.month + 1, provider.month.day));
                      await getData();
                      await provider.findJobByOccupation();
                      shiftCalendarDataSource = ShiftCalendarDataSource(provider: provider);
                      shiftCalendarDataSourceForJob = ShiftCalendarDataSourceForJob(provider: provider);
                      shiftCalendarDataSourceByJobPosting = ShiftCalendarDataSourceByJobPosting(
                          provider: provider, onTap: (CountByDate job) => showJobApplyDialog(job.date, job.jobApplyId));
                    },
                    icon: Icon(
                      color: AppColor.primaryColor,
                      Icons.arrow_forward_ios_rounded,
                      size: 25,
                    )),
              ],
            ),
          ),
        ),
        isShowStatus
            ? Positioned(
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 30,
                      color: const Color(0xff7DC338),
                      child: Center(
                        child: Text(
                          "満枠",
                          style: kNormalText.copyWith(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ),
                    AppSize.spaceWidth8,
                    Container(
                      width: 60,
                      height: 30,
                      color: AppColor.primaryColor,
                      child: Center(
                        child: Text(
                          "空き",
                          style: kNormalText.copyWith(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ),
                    AppSize.spaceWidth8,
                    Text(
                      "確定",
                      style: kNormalText.copyWith(fontSize: 13),
                    ),
                    AppSize.spaceWidth8,
                    Container(
                      width: 65,
                      height: 50,
                      color: AppColor.primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "10:30",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.white),
                          ),
                          Text(
                            "~",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.white, height: 0.4),
                          ),
                          Text(
                            "15:00",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    AppSize.spaceWidth8,
                    Text(
                      "未確定",
                      style: kNormalText.copyWith(fontSize: 13),
                    ),
                    AppSize.spaceWidth8,
                    Container(
                      width: 65,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), border: Border.all(width: 2, color: AppColor.primaryColor)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "11:30",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.black),
                          ),
                          Text(
                            "~",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.black, height: 0.4),
                          ),
                          Text(
                            "19:00",
                            style: kNormalText.copyWith(fontSize: 13, color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }

  buildList() {
    return Container(
      width: AppSize.getDeviceWidth(context),
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          TitleWidget(title: provider.displayList[0]),
          AppSize.spaceHeight16,
          Row(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Text(
                        "求人タイトル",
                        style: normalTextStyle.copyWith(fontSize: 13),
                      ),
                    )),
                flex: 3,
              ),
              Expanded(
                child: Center(
                  child: Text("稼働期間", style: normalTextStyle.copyWith(fontSize: 13)),
                ),
                flex: 2,
              ),
              SizedBox(
                  width: 100,
                  child: Center(
                    child: Text("掲載状況", style: normalTextStyle.copyWith(fontSize: 13)),
                  ))
            ],
          ),
          AppSize.spaceHeight16,
          ListView.builder(
              shrinkWrap: true,
              itemCount: provider.jobPostingList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var job = provider.jobPostingList[index];
                return JobCardDisplay(
                  title: job.title!,
                  shiftFrame: job,
                  onClick: () {
                    setState(() {
                      provider.jobPosting = job;
                    });
                  },
                  selectShiftFrame: provider.jobPosting,
                );
              })
        ],
      ),
    );
  }

  showMatching() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: MatchingWorkerPage(
                jobPosting: provider.jobPosting!,
                shiftFrame: provider.jobPosting!.shiftFrameList!.first,
                onSuccess: () {
                  //Refresh data
                },
              ),
            ));
  }

  showCopyAndPaste() {
    showDialog(
        context: context,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.getDeviceHeight(context) * 0.1, vertical: 32),
            child: CreateOrEditJobPostingPageForCompany(
              jobPosting: provider.jobPosting!.uid,
              isCopyPaste: true,
            ),
          );
        }).then((value) {
      if (value == true) {
        getData();
      }
    });
  }

  @override
  void afterBuild(BuildContext context) async {
    await getData();
    shiftCalendarDataSource = ShiftCalendarDataSource(provider: provider);
    shiftCalendarDataSourceForJob = ShiftCalendarDataSourceForJob(provider: provider);
    await provider.findJobByOccupation();
    shiftCalendarDataSourceByJobPosting =
        ShiftCalendarDataSourceByJobPosting(provider: provider, onTap: (CountByDate job) => showJobApplyDialog(job.date, job.jobApplyId));
  }

  getData() async {
    if (authProvider.myCompany == null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Company? company = await UserApiServices().getProfileCompany(user.uid);
        authProvider.onChangeCompany(company);
        provider.setCompanyId = authProvider.myCompany?.uid ?? "";
        await provider.getApplicantList(authProvider.myCompany?.uid ?? "");
        provider.onChangeLoading(false);
      } else {
        context.go(MyRoute.companyLogin);
      }
    } else {
      provider.setCompanyId = authProvider.myCompany?.uid ?? "";
      await provider.getApplicantList(authProvider.myCompany?.uid ?? "");
      provider.onChangeLoading(false);
    }
  }
}
